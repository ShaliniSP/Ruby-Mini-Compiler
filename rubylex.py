import ply.lex as lex
import re
 
reserved_words = ['puts', 
                  'do',
                  'end',
                  'begin',
                  'when',
                  'case',
                  'while',
                  'else',
                  'return',
                  'def'
                  'next',
                  'then',
                  'nil',
                  'not',
                  'and',
                  'or',
                  'true',
                  'false',
                  'unless',
                  'until',
                  'break']
reserved = {word: word.upper() for word in reserved_words}
#print(reserved)

# List of token names.   This is always required
 
tokens = ['ALPHABET',
         'VALID', 
         'DIGIT',
         'VAR',
         'STRING',
         'SIGN', 
         'INT',
         'FLOAT',
         'BOOL',
         'INRANGE',
         'EXRANGE',
         'ARITH_OP', 
         'AR_EXP',
         'BOOL_OP',
         'REL_OP_SING',
         'REL_OP_MUL',
         'S_AS_OP',
         'C_ARITH_AS_OP', 
         'C_BOOL_AS_OP',
         'P_AS_OP',
         'expas',
         'exp',
         'ccomp',
         'scomp',
         'addas',
         'mulas',
         'comp',
         'gte',
         'lte',
         'ne',
         'subas',
         'divas',
         'modas',
         'asop'] + list(reserved.values())


# Regular expression rules for simple tokens

t_asop      = r'='      
t_exp       = r'\*\*'
t_comp      = r'=='
t_gte       = r'>='
t_lte       = r'<='
t_ne        = r'!='
t_ccomp     = r'<=>'
t_scomp     = r'==='
st_expas     = r'\*\*='
t_addas     = r'\+='
t_subas     = r'-='
t_mulas     = r'\*='
t_divas     = r'/='
t_modas     = r'%='
t_INRANGE   = r'\d+\.\.\d+'
t_EXRANGE   = r'\d+\.\.\.\d+'
 

 # A regular expression rule with some action code
def ARITH_OP(t):
   r'\+|\-|\*|\/|%'
   t.value = float(t.value)
   return t

def REL_OP_SING(t):
   r'">"|"<"'
   return t

def VAR(t):
   r'[a-zA-Z_][a-zA-Z_0-9]*'
   t.type = reserved.get(t.value,'ID')
   return t

def INT(t):
   r'\d+'
   t.value = int(t.value)
   return t

def FLOAT(t):
   r'\d+\.\d+'
   t.value = float(t.value)
   return t

t_ignore = ' \t'

def STRING(t):
   r'["].*?["]'
   return t

# Error handling rule
def t_error(t):
   print("Illegal character '%s'" % t.value[0])
   t.lexer.skip(1)

# Define a rule so we can track line numbers
def t_newline(t):
   r'\n+'
   t.lexer.lineno += len(t.value)

 # Build the lexer
lexer = lex.lex()

lexer.input("3 + 4")

while True:
     tok = lexer.token()
     if not tok: 
         break      # No more input
     print(tok.type, tok.value, tok.lineno, tok.lexpos)