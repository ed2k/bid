import re
from typing import List, Dict
from bid.models import Call, CallType, Suit, Strain
from bid.constraints import HandConstraints
from bid.system import Rule, BiddingSystem

class SystemTranslator:
    def __init__(self):
        pass

    def parse(self, text: str) -> BiddingSystem:
        system = BiddingSystem("ParsedSystem")
        lines = text.strip().split('\n')
        
        current_rule_data = None
        
        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            # Look for rule start: "OPEN 1NT:" or "RESPONSE 1NT:"
            # Simplified: Assuming lines ending in ":" start a new rule block
            if line.endswith(':'):
                if current_rule_data:
                    self._add_rule_from_data(system, current_rule_data)
                
                heading = line[:-1] # Remove ':'
                if '-' in heading:
                    # Sequence: "1NT - 2C"
                    parts = [p.strip() for p in heading.split('-')]
                    trigger_type = 'SEQUENCE'
                    bid_str = parts[-1] 
                    # Store previous calls for trigger
                    sequence_history = parts[:-1]
                else:
                     parts = heading.split()
                     trigger_type = parts[0] # OPEN, etc.
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
                    'priority': 10 # Default
                }
            elif current_rule_data:
                # Parse attributes
                if line.startswith('HCP:'):
                    # HCP: 15-17
                    val = line.split(':')[1].strip()
                    if '-' in val:
                        mn, mx = map(int, val.split('-'))
                        current_rule_data['hcp'] = (mn, mx)
                    elif '+' in val:
                        mn = int(val.replace('+', ''))
                        current_rule_data['hcp'] = (mn, 37)
                
                elif line.startswith('TP:'):
                    # TP: 25+
                    val = line.split(':')[1].strip()
                    if '-' in val:
                        mn, mx = map(int, val.split('-'))
                        current_rule_data['tp'] = (mn, mx)
                    elif '+' in val:
                        mn = int(val.replace('+', ''))
                        current_rule_data['tp'] = (mn, 50) # Max TP arbitrary high
                        
                elif line.startswith('CONTROLS:'):
                    # CONTROLS: 3
                    # CONTROLS: 4-5
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
                    # ACES: 1,4
                    val = line.split(':')[1].strip()
                    parts = map(str.strip, val.split(','))
                    current_rule_data['aces'] = set(int(p) for p in parts)

                elif line.startswith('ACE_TOPOLOGY:'):
                    # ACE_TOPOLOGY: RANK
                    val = line.split(':')[1].strip()
                    current_rule_data['ace_topology'] = {val}

                elif line.startswith('SHAPE:'):
                    # SHAPE: BALANCED
                    val = line.split(':')[1].strip()
                    if val == 'BALANCED':
                        current_rule_data['balanced'] = True
                    elif val == 'UNBALANCED':
                        current_rule_data['balanced'] = False
                        
                elif line.startswith('LEN'):
                    # LEN H: 5+ or LEN S: 4-6
                    # Format: LEN <SUIT>: <RANGE>
                    parts = line.split(':')
                    suit_str = parts[0].split()[1] # H
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
        # 1. Parse Call
        call = self._parse_call(data['bid'])
        
        # 2. Build Constraints
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
        
        # 3. Build Trigger
        trig_type = data['trigger']
        sequence_data = data.get('sequence', [])
        
        parsed_sequence = [self._parse_call(s) for s in sequence_data]
        
        def trigger(history: List[Call]) -> bool:
            if trig_type == 'OPEN':
                # OPEN means empty history or all passes (dealer passed)
                # Simplified: empty history
                return len(history) == 0 or (len(history) < 4 and all(c.type == CallType.PASS for c in history))
            
            if trig_type == 'SEQUENCE':
                 # Sequence trigger: history must match sequence steps
                 # Problem: History includes opponents' PASSES.
                 # Assuming uncontested auction: 1NT - Pass - 2C ?
                 # parsed_sequence = [1NT]. history = [1NT, Pass].
                 # Or history = [Pass, Pass, 1NT, Pass].
                 
                 # Logic: Extract relevant team bids? 
                 # Or simper: Filter out passes, check sequence?
                 # Warning: Passing can be significant.
                 
                 # Simplest approach for "1NT - 2C":
                 # Check if the *last non-pass bids* match the sequence.
                 
                 # Let's filter history to exclude initial passes? No.
                 # Let's clean history of consecutive passes between bids?
                 # GIB: "1NT" means we opened. "1NT - 2C" means P opened, opp passed, we bid 2C.
                 
                 # Robust Check:
                 # Match parsed_sequence against the end of history (ignoring intervening passes if uncontested).
                 # history: [1NT, Pass] -> aligns with [1NT]. Trigger for 2C returns True.
                 
                 # Check strict alignment of turns?
                 # If sequence is [1NT], we are responding.
                 # History (uncontested): [1NT, Pass]. Len=2.
                 
                 real_calls = [c for c in history if c.type != CallType.PASS] 
                 seq_calls = [c for c in parsed_sequence if c.type != CallType.PASS]
                 
                 if len(real_calls) != len(seq_calls):
                     return False
                     
                 for rc, sc in zip(real_calls, seq_calls):
                     if rc != sc:
                         return False
                 
                 return True

            return False 
            
        # 4. Create Rule
        # Priority logic: longer specific matches usually higher priority? 
        # For now, let's just assume order in file or explicit priority.
        # Giving 1NT higher priority than suit openings if HCP range is tighter?
        # Simple heuristic: Balanced rules > Unbalanced rules?
        # Let's rely on specific prioritization or just use input order (reversed in AddRule?)
        # Actually system.add_rule sorts by priority. Let's give specific priority.
        prio = 10
        if data['balanced']: prio += 5 # 1NT/2NT usually specific
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
