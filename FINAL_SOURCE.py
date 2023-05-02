import itertools
class Fact:
   def __init__(self, op='', args=[], negated=False):
      self.op = op               # Relation or function
      self.args = args           # Varibles and constants
      self.negated = negated     # Not

   def __repr__(self):
      return '{}({})'.format(self.op, ', '.join(self.args))

   def __lt__(self, rhs):
      if self.op != rhs.op:
         return self.op < rhs.op
      if self.negated != rhs.negated:
         return self.negated < rhs.negated
      return self.args < rhs.args

   def __eq__(self, rhs):
      if self.op != rhs.op:
         return False
      if self.negated != rhs.negated:
         return False
      return self.args == rhs.args

   def __hash__(self):
      return hash(str(self))
   
   def copy(self):
      return Fact(self.op, self.args.copy(), self.negated)

   def negate(self):
      self.negated = 1 - self.negated

   def get_args(self):
      return self.args

   def get_op(self):
      return self.op

   @staticmethod
   def parse_fact(fact_str):
      # Example: female(princess_diana).
      fact_str = fact_str.strip().rstrip('.').replace(' ', '')
      sep_idx = -1
      if '(' in fact_str: 
         sep_idx = fact_str.index('(')
      elif '\\' or '=' in fact_str:
         sep_idx = fact_str.index('\\' or '=')
         
         
      # Op and args are separated by '('
      op = fact_str[:sep_idx]
      args = fact_str[sep_idx + 1 : -1].split(',')
      return Fact(op, args)
  

def is_variable(x):
   return isinstance(x, str) and len(x) > 0 and x[0].isupper()

def is_compound(x):
   return isinstance(x, Fact)

def is_list(x):
   return isinstance(x, list)

def unify(x, y, theta):
   if theta is False:
      return False
   if x == y:        # i.e: Parent = Parent, z = z, Mary = Mary
      return theta
   if is_variable(x):
      return unify_var(x, y, theta)
   if is_variable(y):
      return unify_var(y, x, theta)
   if is_compound(x) and is_compound(y):
      return unify(x.get_args(), y.get_args(), unify(x.get_op(), y.get_op(), theta))
   if is_list(x) and is_list(y) and len(x) == len(y):
      return unify(x[1:], y[1:], unify(x[0], y[0], theta))
   return False

def unify_var(var, x, theta):
   if theta.contains(var):
      return unify(theta.substitute_of(var), x, theta)
   if theta.contains(x):
      return unify(var, theta.substitute_of(x), theta)
   theta.add(var, x)
   return theta

class Substitution:
   def __init__(self):
      self.mappings = dict()

   def __repr__(self):
      return ', '.join('{} = {}'.format(key, value) for key, value in self.mappings.items())

   def __eq__(self, rhs):
      return self.mappings == rhs.mappings

   def __hash__(self):
      return hash(frozenset(self.mappings.items()))

   def empty(self):
      return len(self.mappings) == 0

   def contains(self, var):
      return var in self.mappings

   def substitute_of(self, var):
      return self.mappings[var]

   def substitute(self, fact):
      for idx, arg in enumerate(fact.args):
         if self.contains(arg):
            fact.args[idx] = self.substitute_of(arg)

   def add(self, var, x):
      self.mappings[var] = x 

def subst(facts_1, facts_2):   
   if len(facts_1) != len(facts_2):
      return False

   for f1, f2 in zip(facts_1, facts_2):
      if f1.get_op() != f2.get_op():
         return False

   return unify(facts_1, facts_2, Substitution())

def forward_chaining(kb, alpha):
   res = set()
   # Pre-check if current facts are enough to answer
   for fact in kb.facts:
      phi = unify(fact, alpha, Substitution())
      if phi:
         if phi.empty():
            res.add('true')
            return res
         res.add(phi)

   last_generated_facts = kb.facts.copy()

   timelimit = 10000
   while timelimit > 0:
      timelimit -= 1
      new_facts = set()
 
      for rule in kb.rules:
         if not rule.may_triggered(last_generated_facts):
            continue

         num_premises = rule.get_num_premises()
         potential_facts = kb.get_potential_facts(rule)
         
         if not rule.dup_predicate: potential_premises = itertools.combinations(sorted(potential_facts), num_premises)
         else: potential_premises = itertools.permutations(potential_facts, num_premises)

         for tuple_premises in potential_premises:
            premises = [premise for premise in tuple_premises]
            theta = subst(rule.premises, premises)
            if not theta: continue
                        
            new_fact = rule.conclusion.copy()
            theta.substitute(new_fact)
            
            if new_fact not in new_facts and new_fact not in kb.facts:
               new_facts.add(new_fact)
               phi = unify(new_fact, alpha, Substitution())
               if phi:
                  if phi.empty():
                     kb.facts.update(new_facts)
                     res.add('true')
                     return res
                  res.add(phi)

      last_generated_facts = new_facts
      if not new_facts:
         if not res:
            res.add('false')
         return res
      kb.facts.update(new_facts)
   return ("broken thing")

class Sentence:

   @staticmethod
   def categorize(sent_str):
      sent_str = sent_str.strip()
      if not sent_str:
         return 'blank'
      if sent_str.startswith('/*') and sent_str.endswith('*/'):
         return 'comment'
      if ':-' in sent_str:
         return 'rule'
      return 'fact'

   @staticmethod
   def next(inp_str):
      idx = 0
      next_str = inp_str[idx].strip()
      if next_str.startswith('/*'):     
         while not next_str.endswith('*/'):
            idx += 1
            next_str += inp_str[idx].strip()
      elif next_str:                   
         while not next_str.endswith('.'):
            idx += 1
            next_str += inp_str[idx].strip()

      return next_str, inp_str[idx + 1:]

class Rule:
   def __init__(self, conclusion=Fact(), premises=[]):
      self.conclusion = conclusion   
      self.premises = premises     
      self.ops = self.get_ops()        

      self.premises.sort()
      self.dup_predicate = self.detect_dup_predicate()

   def __repr__(self):
      return '{} => {}'.format(' & '.join([str(cond) for cond in self.premises]), str(self.conclusion))

   def copy(self):
      return Rule(self.conclusion.copy(), self.premises.copy())

   def get_num_premises(self):
      return len(self.premises)

   def get_ops(self):
      ops = set()
      for premise in self.premises:
         ops.add(premise.op)
      return ops

   def may_helpful(self, fact_op):
      return fact_op in self.ops

   def may_triggered(self, new_facts):
      for new_fact in new_facts:
         for premise in self.premises:
            if unify(new_fact, premise, Substitution()):
               return True
      return False

   def detect_dup_predicate(self):
      num_premises = self.get_num_premises()
      for i in range(num_premises - 1):
         if self.premises[i].op == self.premises[i + 1].op:
            return True
      return False

   @staticmethod
   def parse_rule(rule_str):       
      rule_str = rule_str.strip().rstrip('.').replace(' ', '')
      sep_idx = rule_str.find(':-')
      
      conclusion = Fact.parse_fact(rule_str[: sep_idx])
      premises = []
      list_fact_str = rule_str[sep_idx + 2:].split('),')

      for idx, fact_str in enumerate(list_fact_str):
         if idx != len(list_fact_str) - 1:
            fact_str += ')'
         if ')' not in fact_str: continue # patch
         fact = Fact.parse_fact(fact_str)
         premises.append(fact)

      return Rule(conclusion, premises)
  
class KnowledgeBase:
   def __init__(self):
      self.facts = set()
      self.rules = []

   def add_fact(self, fact):
      self.facts.add(fact)

   def add_rule(self, rule):
      self.rules.append(rule)

   def query(self, alpha):
      return forward_chaining(self, alpha)

   def get_potential_facts(self, rule):
      facts = []
      for fact in self.facts:
         if rule.may_helpful(fact.op):
            facts.append(fact)
      return facts

   @staticmethod
   def declare(kb, list_sent_str):
      while list_sent_str:
         sent_str, list_sent_str = Sentence.next(list_sent_str)
         sent_type = Sentence.categorize(sent_str)
         if sent_type == 'fact':
            fact = Fact.parse_fact(sent_str)
            kb.add_fact(fact)
         elif sent_type == 'rule':
            rule = Rule.parse_rule(sent_str)
            kb.add_rule(rule)

# Main function
test_number = input("Choose the number of test case for example 04: ").strip()
inp_file = 'testcase/' + test_number + '/knowledge.pl'
query_file = 'testcase/' + test_number + '/query.pl'
outp_file = 'testcase/' + test_number + '/answers.txt'

kb = KnowledgeBase()
with open(inp_file, 'r') as f_in:
   list_sentences = f_in.readlines()
   KnowledgeBase.declare(kb, list_sentences)

with open(query_file, 'r') as f_query:
   with open(outp_file, 'w') as f_out:
      for query_str in f_query.readlines():
         alpha = Fact.parse_fact(query_str)
         alpha_str = str(alpha) + '.'
         print(alpha_str)
         substs = set(kb.query(alpha))
         substs_str = ' ;\n'.join([str(subst) for subst in substs]) + '.\n'
         print(substs_str)
         f_out.write(alpha_str + '\n')
         f_out.write(substs_str + '\n')

print('Results of queries from {} are written to {}.'.format(query_file, outp_file))