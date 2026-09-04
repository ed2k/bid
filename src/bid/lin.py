import os
import re
import urllib.parse
from typing import List, Dict, Optional, Tuple
from bid.models import Hand, Card, Suit, Rank, Call, CallType, Strain, Seat


def clean_alert(alert_text: str) -> str:
    """Replace BBO suit markers (!C, !D, !H, !S, !N) with symbols and clean up formatting."""
    if not alert_text:
        return ""
    replacements = {
        "!C": "♣", "!c": "♣",
        "!D": "♦", "!d": "♦",
        "!H": "♥", "!h": "♥",
        "!S": "♠", "!s": "♠",
        "!N": "NT", "!n": "NT",
    }
    res = alert_text
    for k, v in replacements.items():
        res = res.replace(k, v)
    return res.strip()


class LinDeal:
    """Represents a parsed LIN format deal including metadata, hands, and auction."""
    
    def __init__(self):
        self.board_id: str = ""
        self.dealer: Seat = Seat.SOUTH
        self.vulnerability: str = "NONE"  # 'NONE', 'NS', 'EW', 'BOTH'
        self.players: Dict[Seat, str] = {s: "" for s in Seat}
        self.hands: Dict[Seat, Optional[Hand]] = {s: None for s in Seat}
        self.bidding_history: List[Call] = []
        self.bidding_alerts: List[str] = []
        self.play_history: List[str] = []
        self.claim: Optional[int] = None
        self.raw_lin: str = ""

    def __repr__(self):
        return f"<LinDeal board='{self.board_id}' dealer={self.dealer} vul='{self.vulnerability}' bids={len(self.bidding_history)}>"


class LinParser:
    """Parser for LIN (Bridge Base Online) deal and auction format."""

    DEALER_MAP = {
        '1': Seat.SOUTH,
        '2': Seat.WEST,
        '3': Seat.NORTH,
        '4': Seat.EAST,
        's': Seat.SOUTH,
        'w': Seat.WEST,
        'n': Seat.NORTH,
        'e': Seat.EAST
    }

    VUL_MAP = {
        '0': 'NONE', 'o': 'NONE', '-': 'NONE',
        'n': 'NS', 'ns': 'NS',
        'e': 'EW', 'ew': 'EW',
        'b': 'BOTH', 'both': 'BOTH', 'all': 'BOTH'
    }

    SUIT_CHAR_MAP = {
        'S': Suit.SPADES,
        'H': Suit.HEARTS,
        'D': Suit.DIAMONDS,
        'C': Suit.CLUBS
    }

    RANK_CHAR_MAP = {
        '2': Rank.TWO, '3': Rank.THREE, '4': Rank.FOUR, '5': Rank.FIVE,
        '6': Rank.SIX, '7': Rank.SEVEN, '8': Rank.EIGHT, '9': Rank.NINE,
        'T': Rank.TEN, '10': Rank.TEN, 'J': Rank.JACK, 'Q': Rank.QUEEN,
        'K': Rank.KING, 'A': Rank.ACE
    }

    STRAIN_CHAR_MAP = {
        'C': Strain.CLUBS,
        'D': Strain.DIAMONDS,
        'H': Strain.HEARTS,
        'S': Strain.SPADES,
        'N': Strain.NT,
        'NT': Strain.NT
    }

    @staticmethod
    def extract_lin_content(lin_input: str) -> str:
        """Extract raw LIN string from a URL, a file path, or an inline LIN string."""
        lin_str = lin_input.strip()
        if not lin_str:
            return ""

        # If it's a valid local file path with multiple lines, don't collapse them into one string
        if os.path.isfile(lin_str):
            try:
                with open(lin_str, 'r', encoding='utf-8', errors='ignore') as f:
                    lines = [line.strip() for line in f if line.strip()]
                if len(lines) > 1:
                    return lin_str  # Handled in parse() directly
                elif len(lines) == 1:
                    lin_str = lines[0]
            except Exception:
                pass

        # If it's a URL or contains lin query parameter
        if "lin=" in lin_str:
            idx = lin_str.find("lin=")
            sub = lin_str[idx + 4:]
            end_idx = len(sub)
            for delim in ('&', '#', '\n', '\r'):
                d_pos = sub.find(delim)
                if d_pos != -1 and d_pos < end_idx:
                    end_idx = d_pos
            encoded_lin = sub[:end_idx]
            # Use urllib.parse.unquote to decode %7C -> |, %20 -> ' ', etc. while preserving '+'
            lin_str = urllib.parse.unquote(encoded_lin)
        elif lin_str.startswith("http://") or lin_str.startswith("https://"):
            # URL without lin= parameter, or already unquoted
            parsed = urllib.parse.urlparse(lin_str)
            qs = urllib.parse.parse_qs(parsed.query)
            if 'lin' in qs and qs['lin']:
                lin_str = qs['lin'][0]

        return lin_str

    def parse(self, lin_text: str) -> List[LinDeal]:
        """Parse LIN format text (single or multi-deal, URL or raw text) into a list of LinDeal objects."""
        # Handle file paths with multiple lines
        candidate_file = lin_text.strip()
        if os.path.isfile(candidate_file):
            try:
                with open(candidate_file, 'r', encoding='utf-8', errors='ignore') as f:
                    lines = [line.strip() for line in f if line.strip()]
                if len(lines) > 1:
                    all_deals: List[LinDeal] = []
                    for line in lines:
                        all_deals.extend(self.parse(line))
                    return all_deals
            except Exception:
                pass

        lin_text = self.extract_lin_content(lin_text)
        if not lin_text:
            return []

        # Split by qx| tag if multiple boards present, or parse as single stream
        deals = []
        
        # Split tokens by pipe
        tokens = lin_text.split('|')
        
        current_deal = LinDeal()
        current_deal.raw_lin = lin_text
        
        i = 0
        while i < len(tokens) - 1:
            tag = tokens[i].strip().lower()
            val = tokens[i+1].strip()
            
            if tag in ('qx', 'ah'):
                # Board tag (qx or ah)
                if tag == 'qx' and (current_deal.hands[Seat.SOUTH] or current_deal.bidding_history or current_deal.board_id):
                    deals.append(current_deal)
                    current_deal = LinDeal()
                if not current_deal.board_id or tag == 'qx':
                    current_deal.board_id = val
                i += 2
            elif tag == 'pn':
                # Player names: South, West, North, East (comma or pipe separated)
                if ',' in val:
                    names = [n.strip() for n in val.split(',')]
                    i += 2
                else:
                    names = [val]
                    j = i + 2
                    while j < len(tokens) and len(names) < 4:
                        names.append(tokens[j].strip())
                        j += 1
                    i = j
                
                seats = [Seat.SOUTH, Seat.WEST, Seat.NORTH, Seat.EAST]
                for idx, name in enumerate(names[:4]):
                    current_deal.players[seats[idx]] = name
            elif tag in ('st', 'rh'):
                # Subtitle/board info or re-header
                i += 2
            elif tag == 'md':
                # Deal data: md|1S...H...D...C...,...|
                self._parse_md_tag(val, current_deal)
                i += 2
            elif tag == 'sv':
                # Vulnerability
                vul_code = val.lower()
                current_deal.vulnerability = self.VUL_MAP.get(vul_code, 'NONE')
                i += 2
            elif tag == 'mb':
                # Bidding call
                call = self._parse_mb_tag(val)
                if call:
                    current_deal.bidding_history.append(call)
                    # Maintain 1-to-1 alignment for bidding_alerts
                    current_deal.bidding_alerts.append("")
                i += 2
            elif tag == 'an':
                # Alert/annotation for previous bid
                if current_deal.bidding_alerts:
                    current_deal.bidding_alerts[-1] = val
                else:
                    current_deal.bidding_alerts.append(val)
                i += 2
            elif tag == 'pc':
                # Play card
                current_deal.play_history.append(val)
                i += 2
            elif tag == 'mc':
                # Claim
                if val.isdigit():
                    current_deal.claim = int(val)
                i += 2
            else:
                # Advance tag
                i += 2

        if current_deal.hands[Seat.SOUTH] or current_deal.bidding_history or current_deal.board_id:
            deals.append(current_deal)

        return deals

    def _parse_md_tag(self, val: str, deal: LinDeal):
        """Parse LIN md tag e.g. '1SK982HKQJDJT9CKQ,ST876H543DA87CT98,SQJ54HAT92DKQ5CJ2'."""
        if not val:
            return
        
        dealer_char = val[0]
        deal.dealer = self.DEALER_MAP.get(dealer_char, Seat.SOUTH)
        
        hands_str = val[1:]
        hand_tokens = hands_str.split(',')
        
        # BBO LIN md format: Hand 1=South, Hand 2=West, Hand 3=North, Hand 4=East
        seats = [Seat.SOUTH, Seat.WEST, Seat.NORTH, Seat.EAST]
        
        parsed_hands = {}
        all_cards = set((s, r) for s in Suit for r in Rank)
        used_cards = set()

        for idx, h_str in enumerate(hand_tokens):
            if idx < 4 and h_str.strip():
                hand = self.parse_hand_str(h_str.strip())
                parsed_hands[seats[idx]] = hand
                for c in hand.cards:
                    used_cards.add((c.suit, c.rank))

        # Assign parsed hands to deal
        for s in seats:
            if s in parsed_hands:
                deal.hands[s] = parsed_hands[s]

        # If 4th hand is missing, infer it from remaining unused cards
        missing_seats = [s for s in seats if deal.hands[s] is None]
        if len(missing_seats) == 1:
            remaining = all_cards - used_cards
            inferred_cards = [Card(s, r) for s, r in remaining]
            deal.hands[missing_seats[0]] = Hand(inferred_cards)

    def parse_hand_str(self, s: str) -> Hand:
        """Parse LIN hand string e.g. 'SAK92HKQJDJT9CKQ' into a Hand object."""
        cards = []
        current_suit = None
        
        idx = 0
        while idx < len(s):
            char = s[idx].upper()
            if char in self.SUIT_CHAR_MAP:
                current_suit = self.SUIT_CHAR_MAP[char]
                idx += 1
            elif current_suit is not None:
                # Handle 10 / T rank
                if char == '1' and idx + 1 < len(s) and s[idx+1] == '0':
                    cards.append(Card(current_suit, Rank.TEN))
                    idx += 2
                elif char in self.RANK_CHAR_MAP:
                    cards.append(Card(current_suit, self.RANK_CHAR_MAP[char]))
                    idx += 1
                else:
                    idx += 1
            else:
                idx += 1

        return Hand(cards)

    def _parse_mb_tag(self, val: str) -> Optional[Call]:
        """Parse LIN mb tag e.g. '1C', '1NT', 'P', 'D', 'R', '1C!' into a Call object."""
        clean_val = val.strip().upper()
        # Remove alert punctuation e.g. '1C!' -> '1C'
        clean_val = re.sub(r'[^A-Z0-9]', '', clean_val)
        
        if not clean_val:
            return None

        if clean_val in ('P', 'PAS', 'PASS'):
            return Call(CallType.PASS)
        if clean_val in ('D', 'X', 'DBL', 'DOUBLE'):
            return Call(CallType.DOUBLE)
        if clean_val in ('R', 'XX', 'REDBL', 'REDOUBLE'):
            return Call(CallType.REDOUBLE)

        # Match bid pattern e.g. 1C, 2NT, 3H
        match = re.match(r'^([1-7])([CDHS]|N|NT)$', clean_val)
        if match:
            level = int(match.group(1))
            strain_str = match.group(2)
            strain = self.STRAIN_CHAR_MAP[strain_str]
            return Call(CallType.BID, level, strain)

        return None
