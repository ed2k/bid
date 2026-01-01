import re
from typing import List, Dict
from bid.models import Call, CallType, Suit, Strain
from bid.constraints import HandConstraints
from bid.system import Rule, BiddingSystem

class SystemTranslator:
    def __init__(self):
        print("DEBUG: SystemTranslator Moving Steps Logic Outside")
        pass

    def parse(self, text: str) -> BiddingSystem:
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
                    self._add_rule_from_data(system, current_rule_data)
                
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
                    'tp': (0, 50),
                    'controls': (0, 12),
                    'shape': {},
                    'balanced': None,
                    'priority': 10
                }
            elif current_rule_data:
                if line.startswith('HCP:'):
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
            self._add_rule_from_data(system, current_rule_data)
        return system

    def _add_rule_from_data(self, system: BiddingSystem, data: Dict):
        call = self._parse_call(data['bid'])
        
        constraints = HandConstraints(
            hcp_min=data['hcp'][0],
            hcp_max=data['hcp'][1],
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
        
        def trigger(history: List[Call]) -> bool:
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
                    
                return True

            return False 
            
        prio = 10
        if data['balanced']: prio += 5
        if call.level == 1 and call.strain == Strain.NT: prio = 20
        
        rule = Rule(prio, trigger, constraints, call, description=f"{trig_type} {data['bid']}")
        system.add_rule(rule)

    def _parse_call(self, s: str) -> Call:
        if s == 'PASS': return Call(CallType.PASS)
        if s == 'X': return Call(CallType.DOUBLE)
        if s == 'XX': return Call(CallType.REDOUBLE)
        
        level = int(s[0])
        strain_str = s[1:]
        strains = {'C': Strain.CLUBS, 'D': Strain.DIAMONDS, 'H': Strain.HEARTS, 'S': Strain.SPADES, 'NT': Strain.NT}
        return Call(CallType.BID, level, strains[strain_str])
