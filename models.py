from enum import Enum, IntEnum
from typing import List, Optional, Tuple, Dict
import random

class Suit(IntEnum):
    CLUBS = 0
    DIAMONDS = 1
    HEARTS = 2
    SPADES = 3

    def __str__(self):
        return ["C", "D", "H", "S"][self.value]

class Strain(IntEnum):
    CLUBS = 0
    DIAMONDS = 1
    HEARTS = 2
    SPADES = 3
    NT = 4

    def __str__(self):
        return ["C", "D", "H", "S", "NT"][self.value]

class Seat(IntEnum):
    NORTH = 0
    EAST = 1
    SOUTH = 2
    WEST = 3

    def __str__(self):
        return ["N", "E", "S", "W"][self.value]

    @property
    def partner(self):
        return Seat((self.value + 2) % 4)

class Rank(IntEnum):
    TWO = 2
    THREE = 3
    FOUR = 4
    FIVE = 5
    SIX = 6
    SEVEN = 7
    EIGHT = 8
    NINE = 9
    TEN = 10
    JACK = 11
    QUEEN = 12
    KING = 13
    ACE = 14

    def __str__(self):
        if self.value <= 9: return str(self.value)
        return {10: "T", 11: "J", 12: "Q", 13: "K", 14: "A"}[self.value]

class Card:
    def __init__(self, suit: Suit, rank: Rank):
        self.suit = suit
        self.rank = rank

    def __repr__(self):
        return f"{self.rank}{self.suit}"
    
    @property
    def hcp(self):
        return max(0, self.rank.value - 10)

class Hand:
    def __init__(self, cards: List[Card]):
        self.cards = sorted(cards, key=lambda c: (c.suit.value, c.rank.value), reverse=True)
        self.by_suit = {s: [] for s in Suit}
        for c in self.cards:
            self.by_suit[c.suit].append(c)

    @property
    def hcp(self) -> int:
        return sum(c.hcp for c in self.cards)

    def length(self, suit: Suit) -> int:
        return len(self.by_suit[suit])

    @property
    def distribution(self) -> Dict[Suit, int]:
        return {s: len(self.by_suit[s]) for s in Suit}

    @property
    def total_points(self) -> int:
        """
        GIB Total Points = HCP + Redistribution Points.
        Void=3, Singleton=2, Doubleton=1.
        Short suits (length < 3) with an Honor (J,Q,K,A) get -1 point.
        """
        dist_points = 0
        penalty = 0
        
        for suit in Suit:
            length = self.length(suit)
            if length == 0:
                dist_points += 3
            elif length == 1:
                dist_points += 2
            elif length == 2:
                dist_points += 1
            
            # Check penalty: short suit with honor
            if length < 3:
                # Check for honors in this suit
                has_honor = False
                for card in self.by_suit[suit]:
                    if card.rank.value >= Rank.JACK.value:
                        has_honor = True
                        break
                if has_honor:
                    penalty += 1
                    
        return self.hcp + dist_points - penalty

    @property
    def controls(self) -> int:
        """
        Blue Club Controls: Ace=2, King=1.
        """
        count = 0
        for suit in Suit:
            for card in self.by_suit[suit]:
                if card.rank == Rank.ACE:
                    count += 2
                elif card.rank == Rank.KING:
                    count += 1
        return count

    @property
    def ace_count(self) -> int:
        count = 0
        for suit in Suit:
            for card in self.by_suit[suit]:
                if card.rank == Rank.ACE:
                    count += 1
        return count

    @property
    def ace_topology(self) -> str:
        """
        Returns 'RANK', 'COLOR', 'MIXED', or 'NONE'.
        Only relevant if ace_count == 2.
        RANK: Both Majors or Both Minors.
        COLOR: Both Black or Both Red.
        MIXED: Neither Same Rank nor Same Color (e.g. S+D, H+C).
        """
        if self.ace_count != 2:
            return "NONE"
            
        aces = []
        for suit in Suit:
            for card in self.by_suit[suit]:
                if card.rank == Rank.ACE:
                    aces.append(suit)
        
        s1, s2 = aces[0], aces[1]
        
        # Check Rank (Both Major or Both Minor)
        is_major1 = s1 in (Suit.SPADES, Suit.HEARTS)
        is_major2 = s2 in (Suit.SPADES, Suit.HEARTS)
        if is_major1 == is_major2:
            return "RANK"
            
        # Check Color (Both Black or Both Red)
        is_black1 = s1 in (Suit.SPADES, Suit.CLUBS)
        is_black2 = s2 in (Suit.SPADES, Suit.CLUBS)
        if is_black1 == is_black2:
            return "COLOR"
            
        return "MIXED"

    @property
    def is_balanced(self) -> bool:
        """Standard balanced definition: no singleton/void, at most one doubleton."""
        lengths = sorted(self.distribution.values())
        # Possible balanced shapes: 4333, 4432, 5332
        # (Though some consider 5422 semi-balanced, stick to strict for now)
        return lengths in [[3, 3, 3, 4], [2, 3, 4, 4], [2, 3, 3, 5]]

    def from_string(s: str) -> 'Hand':
        """
        Parse string like 'S:AKJ H:T98 ...' or 'SAK2 HK432...' or space separated cards 'SA SK ...'
        Simplified: 'SA K5 C2...'
        Let's support: "SAK32 HK3 DK2 C432"
        """
        cards = []
        # Remove "S:", "H:" etc formatting if present, or just parse simple format
        # Implementation: Input like "SAK43 CAK..." -> split by suit char?
        # Simpler Input: List of cards like "SA SK SQ ..." or "AK43.KD.T9.872" (PBN-ish)
        # Let's support "SA SK SQ ..." for now
        
        # If input is "SAK..." style
        # "S A K 3 2 H K 3 D K 2 C 4 3 2"
        # Let's stick to "SA SK S3 S2 HK H3 DK D2 C4 C3 C2" space separated
        items = s.split()
        suits = {'C': Suit.CLUBS, 'D': Suit.DIAMONDS, 'H': Suit.HEARTS, 'S': Suit.SPADES}
        ranks = {
            '2': Rank.TWO, '3': Rank.THREE, '4': Rank.FOUR, '5': Rank.FIVE,
            '6': Rank.SIX, '7': Rank.SEVEN, '8': Rank.EIGHT, '9': Rank.NINE,
            'T': Rank.TEN, 'J': Rank.JACK, 'Q': Rank.QUEEN, 'K': Rank.KING, 'A': Rank.ACE
        }
        
        for item in items:
            # Check if using Suit + Ranks format (e.g. "SAK43")
            if item[0] in suits and len(item) > 1:
                # Iterate over rest of chars as ranks
                current_suit = suits[item[0]]
                for r_char in item[1:]:
                    if r_char not in ranks:
                         # Fallback or error? ignore
                         continue
                    cards.append(Card(current_suit, ranks[r_char]))
            else:
                # Assume single card format e.g. "AS", "2C"
                suit_char = item[-1] 
                rank_str = item[:-1]
                
                if suit_char in suits:
                    cards.append(Card(suits[suit_char], ranks[rank_str]))
                else:
                    raise ValueError(f"Unknown card format: {item}")
            
        return Hand(cards)

    @staticmethod
    def random() -> 'Hand':
        deck = [Card(s, r) for s in Suit for r in Rank]
        random.shuffle(deck)
        return Hand(deck[:13])

class CallType(Enum):
    BID = 1
    PASS = 2
    DOUBLE = 3
    REDOUBLE = 4

class Call:
    def __init__(self, type: CallType, level: int = 0, strain: Strain = None):
        self.type = type
        self.level = level
        self.strain = strain

    def __str__(self):
        if self.type == CallType.PASS: return "PASS"
        if self.type == CallType.DOUBLE: return "X"
        if self.type == CallType.REDOUBLE: return "XX"
        return f"{self.level}{self.strain}"

    def __eq__(self, other):
        if not isinstance(other, Call):
            return False
        return (self.type == other.type and 
                self.level == other.level and 
                self.strain == other.strain)

    def __hash__(self):
        return hash((self.type, self.level, self.strain))

    def __eq__(self, other):
        return (isinstance(other, Call) and 
                self.type == other.type and 
                self.level == other.level and 
                self.strain == other.strain)
