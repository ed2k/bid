from typing import Dict, List, Tuple, Optional, Any, Callable, Set
from bid.models import Hand, Card, Suit, Strain, Rank, Seat, Call, CallType
from bid.features import BridgeFeatures
from bid.decision_net import DecisionNetRule, RuleCondition, DecisionNet
from bid.sampling import Deal, PartialState
from bid.pidm import PIDMEngine

class ProtocolOpType:
    SHOW = "SHOW"
    ASK = "ASK"
    COMMAND = "COMMAND"
    TRANSFER = "TRANSFER"
    ENCODE = "ENCODE"
    CONCEAL = "CONCEAL"
    AMBIGUATE = "AMBIGUATE"
    POOL = "POOL"

class ProtocolStep:
    def __init__(self,
                 name: str,
                 op_type: str,
                 trigger_sequence: List[Call],
                 target_feature: str,
                 call_mapping: Dict[Any, Call],
                 description: str = ""):
        self.name = name
        self.op_type = op_type
        self.trigger_sequence = list(trigger_sequence)
        self.target_feature = target_feature
        self.call_mapping = call_mapping
        self.description = description

    def generate_rules(self, priority: int = 30) -> List[DecisionNetRule]:
        """Convert protocol step into executable DecisionNetRules."""
        rules = []
        for val, call in self.call_mapping.items():
            rule_id = f"{self.name}_{val}_{call}"
            # Create feature condition
            if isinstance(val, tuple) and len(val) == 2:
                # Range [min, max]
                conditions = [
                    RuleCondition(self.target_feature, ">=", val[0]),
                    RuleCondition(self.target_feature, "<=", val[1])
                ]
            else:
                conditions = [RuleCondition(self.target_feature, "==", val)]

            rule = DecisionNetRule(
                rule_id=rule_id,
                call=call,
                conditions=conditions,
                description=f"{self.op_type} {self.target_feature}={val} -> {call}",
                priority=priority
            )
            rules.append(rule)
        return rules

class ConventionProtocol:
    """
    Structured bridge communication protocol consisting of multi-stage questions,
    commands, encodings, or pooling instructions.
    """
    def __init__(self, name: str):
        self.name = name
        self.steps: List[ProtocolStep] = []

    def add_step(self, step: ProtocolStep):
        self.steps.append(step)

    def compile_to_rules(self, base_priority: int = 30) -> List[DecisionNetRule]:
        compiled_rules = []
        for i, step in enumerate(self.steps):
            compiled_rules.extend(step.generate_rules(priority=base_priority + i))
        return compiled_rules

    @staticmethod
    def create_stayman() -> 'ConventionProtocol':
        """Stayman 2C query after 1NT opening."""
        proto = ConventionProtocol("Stayman")
        # Responder 2C asks opener for 4-card major
        # Opener responses: 2D (no 4M), 2H (4 hearts), 2S (4 spades)
        proto.add_step(ProtocolStep(
            name="Stayman_Response",
            op_type=ProtocolOpType.ENCODE,
            trigger_sequence=[Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.CLUBS)],
            target_feature="heart_len",
            call_mapping={
                (4, 13): Call(CallType.BID, 2, Strain.HEARTS),
                (0, 3): Call(CallType.BID, 2, Strain.DIAMONDS)
            },
            description="Opener encodes major suit holding"
        ))
        return proto

    @staticmethod
    def create_jacoby_transfer() -> 'ConventionProtocol':
        """Jacoby Transfer: 2D -> 2H, 2H -> 2S after 1NT opening."""
        proto = ConventionProtocol("JacobyTransfer")
        proto.add_step(ProtocolStep(
            name="Jacoby_Transfer_Hearts",
            op_type=ProtocolOpType.TRANSFER,
            trigger_sequence=[Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.DIAMONDS)],
            target_feature="is_balanced", # Opener always accepts transfer
            call_mapping={
                True: Call(CallType.BID, 2, Strain.HEARTS),
                False: Call(CallType.BID, 2, Strain.HEARTS)
            },
            description="Opener forced to bid 2H to make strong hand declarer"
        ))
        return proto

    @staticmethod
    def create_blackwood() -> 'ConventionProtocol':
        """Blackwood 4NT asking for aces: 5C=0/4, 5D=1, 5H=2, 5S=3."""
        proto = ConventionProtocol("Blackwood")
        proto.add_step(ProtocolStep(
            name="Blackwood_Ace_Encoding",
            op_type=ProtocolOpType.ENCODE,
            trigger_sequence=[Call(CallType.BID, 4, Strain.NT)],
            target_feature="ace_count",
            call_mapping={
                0: Call(CallType.BID, 5, Strain.CLUBS),
                1: Call(CallType.BID, 5, Strain.DIAMONDS),
                2: Call(CallType.BID, 5, Strain.HEARTS),
                3: Call(CallType.BID, 5, Strain.SPADES),
                4: Call(CallType.BID, 5, Strain.CLUBS)
            },
            description="Step coded response to ace ask"
        ))
        return proto

    @staticmethod
    def create_strategic_gambling() -> 'ConventionProtocol':
        """Strategic concealment / pooling convention."""
        proto = ConventionProtocol("GamblingPool")
        proto.add_step(ProtocolStep(
            name="Gambling_3NT",
            op_type=ProtocolOpType.POOL,
            trigger_sequence=[],
            target_feature="longest_suit_len",
            call_mapping={
                (7, 13): Call(CallType.BID, 3, Strain.NT)
            },
            description="Direct 3NT to conceal intermediate stoppers from defense"
        ))
        return proto

    @staticmethod
    def create_texas_transfer() -> 'ConventionProtocol':
        """Texas Transfer 4D->4H, 4H->4S over 1NT/2NT with 6+ major."""
        proto = ConventionProtocol("TexasTransfer")
        proto.add_step(ProtocolStep(
            name="Texas_Transfer_4D",
            op_type=ProtocolOpType.TRANSFER,
            trigger_sequence=[Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 4, Strain.DIAMONDS)],
            target_feature="is_balanced",
            call_mapping={
                True: Call(CallType.BID, 4, Strain.HEARTS),
                False: Call(CallType.BID, 4, Strain.HEARTS)
            },
            description="Accept Texas transfer to 4H"
        ))
        return proto

    @staticmethod
    def create_reverse_drury() -> 'ConventionProtocol':
        """Reverse Drury: 2C by passed hand over 1M showing 10-11 HCP with 3+ card support."""
        proto = ConventionProtocol("ReverseDrury")
        proto.add_step(ProtocolStep(
            name="Reverse_Drury_Rebid",
            op_type=ProtocolOpType.ENCODE,
            trigger_sequence=[Call(CallType.BID, 1, Strain.HEARTS), Call(CallType.BID, 2, Strain.CLUBS)],
            target_feature="hcp",
            call_mapping={
                (12, 14): Call(CallType.BID, 2, Strain.HEARTS), # Subminimum signoff
                (15, 21): Call(CallType.BID, 4, Strain.HEARTS)  # Full opening game bid
            },
            description="Opener confirms or declines game invitation after Drury 2C"
        ))
        return proto

    @staticmethod
    def create_michaels_cuebid() -> 'ConventionProtocol':
        """Michaels Cuebid: 2m over 1m showing 5-5 in both majors."""
        proto = ConventionProtocol("MichaelsCuebid")
        proto.add_step(ProtocolStep(
            name="Michaels_Response",
            op_type=ProtocolOpType.COMMAND,
            trigger_sequence=[Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.BID, 2, Strain.CLUBS)],
            target_feature="heart_len",
            call_mapping={
                (3, 13): Call(CallType.BID, 2, Strain.HEARTS),
                (0, 2): Call(CallType.BID, 2, Strain.SPADES)
            },
            description="Partner picks preferred major after Michaels cuebid"
        ))
        return proto

    @staticmethod
    def create_unusual_2nt() -> 'ConventionProtocol':
        """Unusual 2NT: 2NT over 1M showing 5-5 in lowest two unbid suits."""
        proto = ConventionProtocol("Unusual2NT")
        proto.add_step(ProtocolStep(
            name="Unusual_2NT_Response",
            op_type=ProtocolOpType.COMMAND,
            trigger_sequence=[Call(CallType.BID, 1, Strain.HEARTS), Call(CallType.BID, 2, Strain.NT)],
            target_feature="diamond_len",
            call_mapping={
                (3, 13): Call(CallType.BID, 3, Strain.DIAMONDS),
                (0, 2): Call(CallType.BID, 3, Strain.CLUBS)
            },
            description="Partner picks minor after Unusual 2NT"
        ))
        return proto

    @staticmethod
    def create_cappelletti() -> 'ConventionProtocol':
        """Cappelletti over 1NT: 2C=one suiter, 2D=both majors, 2H=hearts+minor, 2S=spades+minor."""
        proto = ConventionProtocol("Cappelletti")
        proto.add_step(ProtocolStep(
            name="Cappelletti_2D_Response",
            op_type=ProtocolOpType.COMMAND,
            trigger_sequence=[Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.DIAMONDS)],
            target_feature="heart_len",
            call_mapping={
                (3, 13): Call(CallType.BID, 2, Strain.HEARTS),
                (0, 2): Call(CallType.BID, 2, Strain.SPADES)
            },
            description="Partner passes or bids longer major over Cappelletti 2D"
        ))
        return proto

    @staticmethod
    def create_smolen() -> 'ConventionProtocol':
        """Smolen: after 1NT - 2C - 2D, jump to 3M with 5 in the OTHER major."""
        proto = ConventionProtocol("Smolen")
        proto.add_step(ProtocolStep(
            name="Smolen_Transfer",
            op_type=ProtocolOpType.TRANSFER,
            trigger_sequence=[Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.CLUBS), Call(CallType.BID, 2, Strain.DIAMONDS), Call(CallType.BID, 3, Strain.SPADES)],
            target_feature="is_balanced",
            call_mapping={
                True: Call(CallType.BID, 4, Strain.HEARTS),
                False: Call(CallType.BID, 4, Strain.HEARTS)
            },
            description="Opener with 3-card heart support converts Smolen 3S to 4H"
        ))
        return proto

class ValueOfInformationEvaluator:
    """
    Calculates Value of Information (VOI):
    VOI(Q) = E[max_a V(a | Q)] - max_a E[V(a)]
    """
    def __init__(self, engine: PIDMEngine):
        self.engine = engine

    def evaluate_voi(self,
                     query_step: ProtocolStep,
                     states_under_query: List[PartialState],
                     models: Dict[Seat, DecisionNet]) -> float:
        """
        Estimates expected payoff with information query vs without information query.
        """
        if not states_under_query:
            return 0.0

        total_gain = 0.0
        for p_state in states_under_query:
            # Score without query
            uninformed_call, uninformed_values = self.engine.decide(p_state, models)
            uninformed_val = uninformed_values.get(uninformed_call, 0.0)

            # Score with query branches
            informed_vals = []
            for val, call in query_step.call_mapping.items():
                temp_hist = p_state.history + [call]
                # Fast evaluation of resulting state
                deal = Deal.completion_from_known(p_state.my_seat, p_state.my_hand, p_state.dealer, p_state.vuln)
                score = self.engine.lookahead(deal, temp_hist, models, p_state.my_seat, p_state.dealer, p_state.vuln, depth=1)
                informed_vals.append(score)

            expected_informed_val = max(informed_vals) if informed_vals else uninformed_val
            total_gain += max(0.0, expected_informed_val - uninformed_val)

        return total_gain / len(states_under_query)

    def evaluate_competitive_voi(self,
                                 query_step: ProtocolStep,
                                 states_under_query: List[PartialState],
                                 models: Dict[Seat, DecisionNet],
                                 leakage_penalty: float = 0.2,
                                 preemption_bonus: float = 0.3) -> Dict[str, float]:
        """
        Calculates Bidirectional / Competitive Value of Information (VOI):
        VOI_comp(Q) = VOI_partner(Q) - leakage_penalty * InformationLeakage(Q) + preemption_bonus * Disruption(Q)
        """
        if not states_under_query:
            return {"voi_partner": 0.0, "leakage": 0.0, "disruption": 0.0, "net_voi": 0.0}

        partner_voi = self.evaluate_voi(query_step, states_under_query, models)
        
        # Estimate information leakage: granularity of target features exposed to opponents
        num_branches = len(query_step.call_mapping)
        leakage = (num_branches - 1) / max(1, num_branches)

        # Estimate preemption disruption: altitude jump of query/response calls
        disruptive_calls = [c for c in query_step.call_mapping.values() if getattr(c, "level", 0) >= 3]
        disruption = len(disruptive_calls) / max(1, num_branches)

        net_voi = partner_voi - (leakage_penalty * leakage) + (preemption_bonus * disruption)
        return {
            "voi_partner": partner_voi,
            "leakage": leakage,
            "disruption": disruption,
            "net_voi": net_voi
        }

class AdversarialSignalingEvaluator:
    """
    Evaluates net strategic payoff:
    Net Payoff = Delta V_partner - Delta V_opponent
    Measures whether revealing vs concealing/pooling improves total game score against defenders.
    """
    def __init__(self, engine: PIDMEngine):
        self.engine = engine

    def evaluate_disclosure_payoff(self,
                                   descriptive_proto: ConventionProtocol,
                                   concealing_proto: ConventionProtocol,
                                   test_deals: List[Deal],
                                   base_models: Dict[Seat, DecisionNet]) -> Dict[str, float]:
        """
        Compares average score of descriptive protocol vs concealing protocol across deals.
        """
        # Build models with descriptive
        desc_models = {s: m.clone() for s, m in base_models.items()}
        for r in descriptive_proto.compile_to_rules():
            desc_models[Seat.NORTH].add_rule(r)
            desc_models[Seat.SOUTH].add_rule(r)

        # Build models with concealing
        conc_models = {s: m.clone() for s, m in base_models.items()}
        for r in concealing_proto.compile_to_rules():
            conc_models[Seat.NORTH].add_rule(r)
            conc_models[Seat.SOUTH].add_rule(r)

        score_desc = 0.0
        score_conc = 0.0

        for deal in test_deals:
            # 1. Descriptive game
            hist_desc: List[Call] = []
            curr = deal.dealer
            while True:
                ps = PartialState(curr, deal.hands[curr], hist_desc, deal.dealer, deal.vuln)
                if ps.is_auction_over() or len(hist_desc) >= 15:
                    break
                call, _ = self.engine.decide(ps, desc_models)
                hist_desc.append(call)
                curr = Seat((curr.value + 1) % 4)
            score_desc += self.engine.evaluate_terminal_deal(deal, hist_desc, Seat.SOUTH, deal.dealer, deal.vuln)

            # 2. Concealing game
            hist_conc: List[Call] = []
            curr = deal.dealer
            while True:
                ps = PartialState(curr, deal.hands[curr], hist_conc, deal.dealer, deal.vuln)
                if ps.is_auction_over() or len(hist_conc) >= 15:
                    break
                call, _ = self.engine.decide(ps, conc_models)
                hist_conc.append(call)
                curr = Seat((curr.value + 1) % 4)
            score_conc += self.engine.evaluate_terminal_deal(deal, hist_conc, Seat.SOUTH, deal.dealer, deal.vuln)

        n = len(test_deals) if test_deals else 1
        return {
            "descriptive_avg_score": score_desc / n,
            "concealing_avg_score": score_conc / n,
            "concealing_advantage": (score_conc - score_desc) / n
        }
