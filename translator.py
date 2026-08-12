import re
from typing import List, Dict, Optional
from bid.models import Call, CallType, Suit, Strain
from bid.constraints import HandConstraints
from bid.system import Rule, BiddingSystem

class SystemTranslator:
    def __init__(self):
        print("DEBUG: SystemTranslator Moving Steps Logic Outside")
        pass

    def parse(self, text: str, system: Optional[BiddingSystem] = None, is_common: bool = False) -> BiddingSystem:
        if system is None:
            system = BiddingSystem("ParsedSystem")
        lines = text.strip().split('\n')
        
        current_rule_data = None
        
        for line in lines:
            line = line.split('#')[0].strip()
            if not line:
                continue

            # Look for rule start: "OPEN 1NT:" or "RESPONSE 1NT:"
            if line.endswith(':'):
                if current_rule_data:
                    self._add_rule_from_data(system, current_rule_data, is_common=is_common)
                
                heading = line[:-1]
                if '-' in heading:
                    parts = [p.strip() for p in heading.split('-')]
                    trigger_type = 'SEQUENCE'
                    bid_str = parts[-1] 
                    sequence_history = parts[:-1]
                else:
                     parts = heading.split()
                     trigger_type = parts[0]
                     bid_str = parts[1]
                     sequence_history = []
                
                current_rule_data = {
                    'trigger': trigger_type,
                    'sequence': sequence_history,
                    'bid': bid_str,
                    'hcp': (0, 37),
                    'major_hcp': (0, 37),
                    'tp': (0, 50),
                    'controls': (0, 12),
                    'shape': {},
                    'balanced': None,
                    'priority': 10,
                    'bid_class': None,
                    'cuebid_type': None,
                    'cue_target': None,
                    'forcing': None,
                    'convention': None,
                    'priority_bonus': 0,
                    'passed_hand': None,
                    'partner_passed_hand': None,
                    'opener_seat': None
                }
            elif current_rule_data:
                if line.startswith('MAJOR_HCP:'):
                    val = line.split(':')[1].strip()
                    if '-' in val:
                        mn, mx = map(int, val.split('-'))
                        current_rule_data['major_hcp'] = (mn, mx)
                    elif '+' in val:
                        mn = int(val.replace('+', ''))
                        current_rule_data['major_hcp'] = (mn, 37)
                    else:
                        mn = int(val)
                        current_rule_data['major_hcp'] = (mn, mn)
                elif line.startswith('HCP:'):
                    val = line.split(':')[1].strip()
                    if '-' in val:
                        mn, mx = map(int, val.split('-'))
                        current_rule_data['hcp'] = (mn, mx)
                    elif '+' in val:
                        mn = int(val.replace('+', ''))
                        current_rule_data['hcp'] = (mn, 37)
                elif line.startswith('TP:'):
                    val = line.split(':')[1].strip()
                    if '-' in val:
                        mn, mx = map(int, val.split('-'))
                        current_rule_data['tp'] = (mn, mx)
                    elif '+' in val:
                        mn = int(val.replace('+', ''))
                        current_rule_data['tp'] = (mn, 50)
                elif line.startswith('CONTROLS:'):
                    val = line.split(':')[1].strip()
                    if '-' in val:
                        mn, mx = map(int, val.split('-'))
                        current_rule_data['controls'] = (mn, mx)
                    elif '+' in val:
                        mn = int(val.replace('+', ''))
                        current_rule_data['controls'] = (mn, 12)
                    else:
                        mn = int(val)
                        current_rule_data['controls'] = (mn, mn)
                elif line.startswith('ACES:'):
                    val = line.split(':')[1].strip()
                    parts = map(str.strip, val.split(','))
                    current_rule_data['aces'] = set(int(p) for p in parts)
                elif line.startswith('ACE_TOPOLOGY:'):
                    val = line.split(':')[1].strip()
                    current_rule_data['ace_topology'] = {val}
                elif line.startswith('SHAPE:'):
                    val = line.split(':')[1].strip()
                    if val == 'BALANCED':
                        current_rule_data['balanced'] = True
                    elif val == 'UNBALANCED':
                        current_rule_data['balanced'] = False
                elif line.startswith('BID_CLASS:'):
                    current_rule_data['bid_class'] = line.split(':')[1].strip()
                elif line.startswith('CUEBID_TYPE:'):
                    current_rule_data['cuebid_type'] = line.split(':')[1].strip()
                elif line.startswith('CUE_TARGET:'):
                    current_rule_data['cue_target'] = line.split(':')[1].strip()
                elif line.startswith('FORCING:'):
                    current_rule_data['forcing'] = line.split(':')[1].strip()
                elif line.startswith('CONVENTION:'):
                    current_rule_data['convention'] = line.split(':')[1].strip()
                elif line.startswith('PRIORITY_BONUS:'):
                    current_rule_data['priority_bonus'] = int(line.split(':')[1].strip())
                elif line.startswith('PASSED_HAND:'):
                    val = line.split(':')[1].strip().upper()
                    current_rule_data['passed_hand'] = (val == 'TRUE')
                elif line.startswith('PARTNER_PASSED_HAND:'):
                    val = line.split(':')[1].strip().upper()
                    current_rule_data['partner_passed_hand'] = (val == 'TRUE')
                elif line.startswith('OPENER_SEAT:'):
                    val = line.split(':')[1].strip()
                    seats = set()
                    if '1' in val: seats.add(0)
                    if '2' in val: seats.add(1)
                    if '3' in val: seats.add(2)
                    if '4' in val: seats.add(3)
                    current_rule_data['opener_seat'] = seats
                elif line.startswith('LEN'):
                    parts = line.split(':')
                    suit_str = parts[0].split()[1]
                    rng_str = parts[1].strip()
                    suit = {'C': Suit.CLUBS, 'D': Suit.DIAMONDS, 'H': Suit.HEARTS, 'S': Suit.SPADES}[suit_str]
                    mn, mx = 0, 13
                    if '+' in rng_str:
                        mn = int(rng_str.replace('+', ''))
                    elif '-' in rng_str:
                        mn, mx = map(int, rng_str.split('-'))
                    else:
                        mn = mx = int(rng_str)
                    current_rule_data['shape'][suit] = (mn, mx)

        if current_rule_data:
            self._add_rule_from_data(system, current_rule_data, is_common=is_common)
        return system

    def _add_rule_from_data(self, system: BiddingSystem, data: Dict, is_common: bool = False):
        call = self._parse_call(data['bid'])
        
        constraints = HandConstraints(
            hcp_min=data['hcp'][0],
            hcp_max=data['hcp'][1],
            major_hcp_min=data['major_hcp'][0],
            major_hcp_max=data['major_hcp'][1],
            tp_min=data['tp'][0],
            tp_max=data['tp'][1],
            controls_min=data['controls'][0],
            controls_max=data['controls'][1],
            aces=data.get('aces'),
            ace_topology=data.get('ace_topology'),
            length_min={s: data['shape'].get(s, (0, 13))[0] for s in Suit},
            length_max={s: data['shape'].get(s, (0, 13))[1] for s in Suit},
            balanced=data['balanced']
        )
        
        trig_type = data['trigger']
        passed_hand = data.get('passed_hand')
        partner_passed_hand = data.get('partner_passed_hand')
        opener_seats = data.get('opener_seat')
        
        # Parse sequence steps ONCE here
        steps = []
        if trig_type == 'SEQUENCE':
            raw_seq = data.get('sequence', [])
            for item in raw_seq:
                is_direct = False
                s = item
                if s.startswith('(') and s.endswith(')'):
                    is_direct = True
                    s = s[1:-1]
                call_obj = self._parse_call(s)
                steps.append((call_obj, is_direct))
            
            # DEBUG
            # print(f"DEBUG TRANS: Rule {data['bid']} Steps={[(str(c), d) for c,d in steps]} Shape={data['shape']}")
        
        def trigger(history: List[Call]) -> bool:
            if passed_hand is not None:
                if len(history) < 4:
                    is_passed = False
                else:
                    first_turn_idx = len(history) % 4
                    is_passed = (history[first_turn_idx].type == CallType.PASS)
                if is_passed != passed_hand:
                    return False

            if partner_passed_hand is not None:
                partner_seat = (len(history) + 2) % 4
                if len(history) <= partner_seat:
                    is_partner_passed = False
                else:
                    is_partner_passed = (history[partner_seat].type == CallType.PASS)
                if is_partner_passed != partner_passed_hand:
                    return False

            if opener_seats is not None:
                first_bid_idx = -1
                for idx, c in enumerate(history):
                    if c.type == CallType.BID:
                        first_bid_idx = idx
                        break
                if first_bid_idx not in opener_seats:
                    return False

            if trig_type == 'OPEN':
                return len(history) == 0 or (len(history) < 4 and all(c.type == CallType.PASS for c in history))
            
            if trig_type == 'SEQUENCE':
                if not history and not steps:
                    return True
                if not history:
                    return False
                
                hist_idx = len(history) - 1
                step_idx = len(steps) - 1
                
                while step_idx >= 0:
                    if hist_idx < 0:
                        return False
                    
                    call_target, is_direct = steps[step_idx]
                    
                    if is_direct:
                        # Direct mode: No intervening pass allowed
                        if history[hist_idx] != call_target:
                            return False
                        hist_idx -= 1
                    else:
                        # Standard mode: Typically implies Partner's bid + Opponent Pass
                        pass_found = False
                        
                        # Consume passes
                        while hist_idx >= 0 and history[hist_idx].type == CallType.PASS:
                            pass_found = True
                            hist_idx -= 1
                        
                        # Standard Rules require matching at least one pass if history implies response
                        # BUT for uncontested response, we MUST have a pass.
                        if not pass_found:
                            return False
                            
                        if hist_idx < 0:
                            return False
                        
                        if history[hist_idx] != call_target:
                            return False
                        
                        hist_idx -= 1
                    
                    step_idx -= 1
                
                # Strict Match Check: Ensure no remaining non-pass calls in history
                while hist_idx >= 0:
                    if history[hist_idx].type != CallType.PASS:
                        return False
                    hist_idx -= 1

                return True

            return False 
            
        prio = data.get('priority', 10)
        prio += data.get('priority_bonus', 0)
        
        if data['balanced']: prio += 5
        if call.level == 1 and call.strain == Strain.NT: prio = 20
        
        metadata = {
            'bid_class': data.get('bid_class'),
            'cuebid_type': data.get('cuebid_type'),
            'cue_target': data.get('cue_target'),
            'forcing': data.get('forcing'),
            'convention': data.get('convention'),
            'priority_bonus': data.get('priority_bonus'),
            'passed_hand': data.get('passed_hand'),
            'partner_passed_hand': data.get('partner_passed_hand'),
            'opener_seat': data.get('opener_seat')
        }
        metadata = {k: v for k, v in metadata.items() if v is not None}
        
        rule = Rule(
            prio, 
            trigger, 
            constraints, 
            call, 
            description=f"{trig_type} {data['bid']}",
            metadata=metadata,
            trigger_type=trig_type,
            sequence_history=data.get('sequence', []),
            is_common=is_common
        )
        system.add_rule(rule)

    def _parse_call(self, s: str) -> Call:
        s_upper = s.upper()
        if s_upper in ('PASS', 'P'): return Call(CallType.PASS)
        if s_upper in ('X', 'DBL', 'DOUBLE'): return Call(CallType.DOUBLE)
        if s_upper in ('XX', 'RDBL', 'REDOUBLE'): return Call(CallType.REDOUBLE)
        
        level = int(s[0])
        strain_str = s[1:]
        strains = {'C': Strain.CLUBS, 'D': Strain.DIAMONDS, 'H': Strain.HEARTS, 'S': Strain.SPADES, 'NT': Strain.NT}
        return Call(CallType.BID, level, strains[strain_str])

