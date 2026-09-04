"""
Bidding system and convention identification engine for Bridge deals and LIN files.

Analyzes hand distributions, opening bids, responses, and bidding alert annotations (e.g. BBO GIB)
to determine the bidding system (e.g. BBO GIB 2/1 GF, Standard American / SAYC, Precision Club, Acol)
and specific bridge conventions utilized by each partnership.
"""

from typing import List, Dict, Tuple, Optional, Set
from dataclasses import dataclass, field
import re

from bid.models import Seat, Suit, Strain, Call, CallType, Hand
from bid.lin import LinDeal, clean_alert


@dataclass
class PartnershipSystem:
    partnership: str  # "North-South" or "East-West"
    system_name: str  # e.g. "BBO GIB (Modern 2/1 Game Force)"
    confidence: str   # "High", "Medium", "Inferred"
    primary_style: str # Summary of system parameters
    key_conventions: List[str] = field(default_factory=list)
    evidence: List[str] = field(default_factory=list)
    alerts: List[Tuple[Seat, Call, str]] = field(default_factory=list)


@dataclass
class SystemIdentificationResult:
    ns: PartnershipSystem
    ew: PartnershipSystem
    is_bbo_gib: bool
    summary: str


class BiddingSystemIdentifier:
    """Identifies the bidding system and conventions for both partnerships on a board."""

    GIB_KEYWORDS = [
        "ruleof-", "loserlevel", "hcp-", "total points", "* artificial",
        "last resort - defensive, sensible", "no new information",
        "responses to 2c", "slam try", "major suit opening --",
        "one over one --", "splinter --", "cue bid --", "game forcing",
        "stayman", "jacoby transfer"
    ]

    @classmethod
    def identify(cls, deal: LinDeal) -> SystemIdentificationResult:
        """Analyze a LinDeal and return system identification for NS and EW."""
        ns_seats = {Seat.NORTH, Seat.SOUTH}
        ew_seats = {Seat.EAST, Seat.WEST}

        ns_alerts: List[Tuple[Seat, Call, str]] = []
        ew_alerts: List[Tuple[Seat, Call, str]] = []

        # Map calls to seats
        curr_seat = deal.dealer
        call_seat_alert_list: List[Tuple[Seat, Call, str]] = []
        for i, call in enumerate(deal.bidding_history):
            alert = deal.bidding_alerts[i] if i < len(deal.bidding_alerts) else ""
            call_seat_alert_list.append((curr_seat, call, alert))
            if curr_seat in ns_seats:
                if alert:
                    ns_alerts.append((curr_seat, call, alert))
            else:
                if alert:
                    ew_alerts.append((curr_seat, call, alert))
            curr_seat = Seat((curr_seat.value + 1) % 4)

        # Check for BBO GIB
        ns_gib = cls._detect_gib_signatures(ns_alerts)
        ew_gib = cls._detect_gib_signatures(ew_alerts)
        is_bbo_gib = bool(ns_gib or ew_gib)

        # Analyze each partnership
        ns_system = cls._analyze_partnership("North-South", ns_seats, call_seat_alert_list, deal, ns_alerts, ns_gib)
        ew_system = cls._analyze_partnership("East-West", ew_seats, call_seat_alert_list, deal, ew_alerts, ew_gib)

        # Generate summary
        summary = f"North-South: {ns_system.system_name} ({ns_system.confidence} confidence) | East-West: {ew_system.system_name} ({ew_system.confidence} confidence)"

        return SystemIdentificationResult(
            ns=ns_system,
            ew=ew_system,
            is_bbo_gib=is_bbo_gib,
            summary=summary
        )

    @classmethod
    def _detect_gib_signatures(cls, alerts: List[Tuple[Seat, Call, str]]) -> List[str]:
        signatures = []
        for seat, call, alert in alerts:
            al_lower = alert.lower()
            for kw in cls.GIB_KEYWORDS:
                if kw in al_lower:
                    signatures.append(f"{seat.name} {call}: '{clean_alert(alert)}'")
                    break
        return signatures

    @classmethod
    def _analyze_partnership(
        cls,
        name: str,
        seats: Set[Seat],
        all_calls: List[Tuple[Seat, Call, str]],
        deal: LinDeal,
        alerts: List[Tuple[Seat, Call, str]],
        gib_evidence: List[str]
    ) -> PartnershipSystem:
        evidence: List[str] = []
        conventions: Set[str] = set()
        system_name = "Standard American / SAYC"
        confidence = "Inferred"
        primary_style = "5-Card Majors, Strong 1NT (15-17), Strong 2♣"

        # Check GIB
        if gib_evidence:
            system_name = "BBO GIB (Modern 2/1 Game Force)"
            confidence = "High"
            primary_style = "2/1 Game Force, 5-Card Majors, Strong 1NT (15-17), Strong 2♣, GIB algorithmic rules"
            evidence.append(f"GIB alert signatures matched ({len(gib_evidence)} calls annotated with GIB rule tokens)")

        # Analyze auction steps
        # Find first opening bid by this partnership
        opening_call: Optional[Call] = None
        opener_seat: Optional[Seat] = None
        opener_hand: Optional[Hand] = None
        opener_alert: str = ""

        first_response: Optional[Call] = None
        responder_seat: Optional[Seat] = None
        responder_hand: Optional[Hand] = None
        response_alert: str = ""

        # Track first opening of the entire table
        first_bid_idx = -1
        for idx, (s, c, al) in enumerate(all_calls):
            if c.type == CallType.BID:
                first_bid_idx = idx
                break

        for idx, (s, c, al) in enumerate(all_calls):
            if s in seats and c.type == CallType.BID:
                if opening_call is None:
                    opening_call = c
                    opener_seat = s
                    opener_hand = deal.hands.get(s)
                    opener_alert = al
                elif first_response is None and opener_seat is not None and s != opener_seat:
                    first_response = c
                    responder_seat = s
                    responder_hand = deal.hands.get(s)
                    response_alert = al

        # 1. Opening bid analysis
        if opening_call is not None and opener_seat is not None:
            clean_op_al = clean_alert(opener_alert)
            hcp_str = f" ({opener_hand.hcp} HCP)" if opener_hand else ""

            # Check 2C Opening
            if opening_call.level == 2 and opening_call.strain == Strain.CLUBS:
                if (opener_hand and opener_hand.hcp >= 20) or "22+" in opener_alert or "strong" in opener_alert.lower() or "artificial" in opener_alert.lower():
                    conventions.add("Strong 2♣ Opening")
                    evidence.append(f"{opener_seat.name} opened 2♣{hcp_str}: Strong/Artificial 22+ HCP")
                    if "22+" in opener_alert or "strong" in opener_alert.lower():
                        confidence = "High"
                elif opener_hand and opener_hand.hcp <= 15 and opener_hand.length(Suit.CLUBS) >= 5:
                    conventions.add("Precision 2♣ Opening (11-15 HCP, 5+ ♣)")
                    system_name = "Precision Club"
                    confidence = "High"
                    primary_style = "Precision Club (Strong 1♣, Nebulous 1♦, 2♣ 5+ ♣ 11-15 HCP)"
                    evidence.append(f"{opener_seat.name} opened 2♣{hcp_str}: Precision 5+ clubs (11-15 HCP)")

            # Check 1C Opening
            elif opening_call.level == 1 and opening_call.strain == Strain.CLUBS:
                if "artificial" in opener_alert.lower() or "16+" in opener_alert or (opener_hand and opener_hand.hcp >= 16 and "strong" in opener_alert.lower()):
                    conventions.add("Strong 1♣ Opening")
                    system_name = "Precision Club"
                    confidence = "High"
                    primary_style = "Strong 1♣ (16+ HCP), 5-Card Majors, Weak 1NT"
                    evidence.append(f"{opener_seat.name} opened 1♣{hcp_str}: Strong Artificial Club (16+ HCP)")
                else:
                    evidence.append(f"{opener_seat.name} opened natural 1♣{hcp_str}")

            # Check 1NT Opening
            elif opening_call.level == 1 and opening_call.strain == Strain.NT:
                al_lower = opener_alert.lower()
                if "12-14" in al_lower or "weak" in al_lower:
                    evidence.append(f"{opener_seat.name} opened 1NT{hcp_str}: Weak 1NT (12-14 HCP, e.g. Acol)")
                    if not gib_evidence:
                        system_name = "Acol"
                        confidence = "High"
                        primary_style = "4-Card Majors, Weak 1NT (12-14), Strong 2-bids"
                elif "15-17" in al_lower or "strong" in al_lower or (opener_hand and 15 <= opener_hand.hcp <= 17):
                    evidence.append(f"{opener_seat.name} opened 1NT{hcp_str}: Strong 1NT (15-17 HCP)")
                    if not gib_evidence:
                        system_name = "Modern 2/1 Game Force / SAYC"
                        confidence = "Medium"
                elif opener_hand and 12 <= opener_hand.hcp <= 14:
                    evidence.append(f"{opener_seat.name} opened 1NT{hcp_str}: Weak 1NT (12-14 HCP, e.g. Acol)")
                    if not gib_evidence:
                        system_name = "Acol"
                        confidence = "High"
                        primary_style = "4-Card Majors, Weak 1NT (12-14), Strong 2-bids"

            # Check Major Openings (1H, 1S)
            elif opening_call.level == 1 and opening_call.strain in (Strain.HEARTS, Strain.SPADES):
                suit = Suit.HEARTS if opening_call.strain == Strain.HEARTS else Suit.SPADES
                if opener_hand:
                    suit_len = opener_hand.length(suit)
                    if suit_len >= 5:
                        evidence.append(f"{opener_seat.name} opened 1{opening_call.strain.name[0]}{hcp_str}: 5-card major ({suit_len} cards)")
                    elif suit_len == 4:
                        evidence.append(f"{opener_seat.name} opened 1{opening_call.strain.name[0]}{hcp_str}: 4-card major ({suit_len} cards, Acol/Canapé style)")
                        if not gib_evidence and system_name != "Precision Club":
                            system_name = "Acol / 4-Card Majors"

            # Check Weak Two Bids (2D, 2H, 2S)
            elif opening_call.level == 2 and opening_call.strain in (Strain.DIAMONDS, Strain.HEARTS, Strain.SPADES):
                if (opener_hand and opener_hand.hcp <= 11) or "weak" in opener_alert.lower() or "preempt" in opener_alert.lower():
                    conventions.add("Weak Two Bids")
                    evidence.append(f"{opener_seat.name} opened weak 2{opening_call.strain.name[0]}{hcp_str}")

            # Check Preempts (3-level / 4-level)
            elif opening_call.level in (3, 4) and opener_hand and opener_hand.hcp <= 10:
                conventions.add("Preemptive Opening")
                evidence.append(f"{opener_seat.name} opened preemptive {opening_call}{hcp_str}")

        # 2. Response / Continuation analysis
        if opening_call is not None and first_response is not None and responder_seat is not None:
            resp_hcp = f" ({responder_hand.hcp} HCP)" if responder_hand else ""
            clean_resp_al = clean_alert(response_alert)

            # 2/1 Response to 1 Major
            if opening_call.level == 1 and opening_call.strain in (Strain.HEARTS, Strain.SPADES):
                if first_response.level == 2 and first_response.strain.value < opening_call.strain.value:
                    if "game forcing" in response_alert.lower() or (responder_hand and responder_hand.hcp >= 12):
                        conventions.add("2/1 Game Force")
                        if not gib_evidence:
                            system_name = "Modern 2/1 Game Force"
                            confidence = "High"
                        evidence.append(f"{responder_seat.name} responded 2{first_response.strain.name[0]}{resp_hcp}: 2/1 Game Force")

            # Responses to 1NT
            if opening_call.level == 1 and opening_call.strain == Strain.NT:
                if first_response.level == 2 and first_response.strain == Strain.CLUBS:
                    conventions.add("Stayman")
                    evidence.append(f"{responder_seat.name} bid 2♣ over 1NT: Stayman inquiry")
                elif first_response.level == 2 and first_response.strain == Strain.DIAMONDS:
                    conventions.add("Jacoby Transfer to Hearts")
                    evidence.append(f"{responder_seat.name} bid 2♦ over 1NT: Jacoby Transfer to ♥")
                elif first_response.level == 2 and first_response.strain == Strain.HEARTS:
                    conventions.add("Jacoby Transfer to Spades")
                    evidence.append(f"{responder_seat.name} bid 2♥ over 1NT: Jacoby Transfer to ♠")

            # Responses to 2C
            if opening_call.level == 2 and opening_call.strain == Strain.CLUBS:
                if first_response.level == 2 and first_response.strain == Strain.DIAMONDS:
                    conventions.add("2♦ Waiting / Negative over 2♣")
                    evidence.append(f"{responder_seat.name} bid 2♦: Waiting response to 2♣")
                elif first_response.level == 2 and first_response.strain in (Strain.HEARTS, Strain.SPADES):
                    conventions.add(f"Positive {first_response.strain.name.title()} Response over 2♣")
                    evidence.append(f"{responder_seat.name} bid positive {first_response}{resp_hcp} over 2♣")

        # 3. Scan all partnership calls for conventions (Splinters, Slam tries, Blackwood, Alerts)
        for s, c, al in all_calls:
            if s not in seats:
                continue
            al_clean = clean_alert(al)
            al_lower = al.lower()

            if "splinter" in al_lower:
                conventions.add("Splinter Bids")
                evidence.append(f"{s.name} made a Splinter bid ({c}): {al_clean}")
            if "slam try" in al_lower:
                conventions.add("Slam Try")
                evidence.append(f"{s.name} made a Slam Try ({c}): {al_clean}")
            if "cue bid" in al_lower or "control" in al_lower:
                conventions.add("Control Cue Bidding")
                evidence.append(f"{s.name} made a Control Cue Bid ({c}): {al_clean}")
            if c.type == CallType.BID and c.level == 4 and c.strain == Strain.NT:
                if "keycard" in al_lower or "rkcb" in al_lower or "1430" in al_lower or "3041" in al_lower:
                    conventions.add("Roman Key Card Blackwood (RKCB)")
                    evidence.append(f"{s.name} 4NT: Roman Key Card Blackwood (RKCB)")
                else:
                    conventions.add("Blackwood 4NT")
                    evidence.append(f"{s.name} 4NT: Ace-asking Blackwood")
            if "jacoby" in al_lower or "transfer" in al_lower:
                conventions.add("Transfer Bids")
            if "stayman" in al_lower:
                conventions.add("Stayman")

        # Deduplicate evidence
        unique_evidence = []
        for e in evidence:
            if e not in unique_evidence:
                unique_evidence.append(e)

        return PartnershipSystem(
            partnership=name,
            system_name=system_name,
            confidence=confidence,
            primary_style=primary_style,
            key_conventions=sorted(list(conventions)),
            evidence=unique_evidence,
            alerts=alerts
        )
