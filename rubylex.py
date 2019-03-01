import ply.lex as lex
 
reserved_words = ["puts", "else", "BEGIN","do","next","then","END","nil","true","not","and","end","or","false","unless","begin","until","break","when","case","return","while","def"]

 # List of token names.   This is always required
tokens = (
    'puts',
    'do',
    'end',
    'begin',
    'when',
    'case',
    'while',
    'else',
    'return',
    'def',
 )
 
 # Regular expression rules for simple tokens
#reserved = {word: word.upper() for word in reserved_words}

tokens = ['ALPHABET','VALID', 'DIGIT', 'SPACES', 'VAR', 'STRING', 'SIGN', 
            'INT', 'FLOAT', 'BOOL', 'IN_RANGE', 'EX_RANGE',
            'ARITH_OP', 'AR_EXP', 'BOOL_OP', 'REL_OP_SING',
            'REL_OP_MUL', 'S_AS_OP', 'C_ARITH_AS_OP', 
            'C_BOOL_AS_OP', 'P_AS_OP', 'EXPAS', 'EXP', 'CCOMP', 'SCOMP', 
            'ADDAS', 'MULAS', 'COMP', 'GTE', 'LTE'] + list(reserved_words)

#  t_PLUS    = r'\+'
#  t_MINUS   = r'-'
#  t_TIMES   = r'\*'
#  t_DIVIDE  = r'/'
#  t_LPAREN  = r'\('
#  t_RPAREN  = r'\)'

t_puts      = r'puts'
t_do        = r'do'      
t_end       = r'end'
t_begin     = r'begin'
t_when      = r'when'
t_case      = r'case'
t_while     = r'while'
t_else      = r'else'
t_return    = r'return'
t_def       = r'def'
t_asop      = r'='      
t_exp       = r'\*\*'
t_comp      = r'=='
t_gte       = r'>='
t_lte       = r'<='
t_ne        = r'!='
t_ccomp     = r'<=>'
t_scomp     = r'==='
t_expas     = r'\*\*='
t_addas     = r'\+='
t_subas     = r'-='
t_mulas     = r'\*='
t_divas     = r'/='
t_modas     = r'%='
t_and       = r'&&|and' 
t_or        = r'\|\| | or'
t_not       = r'! | not'
t_true      = r'true'
t_false     = r'false'
#t_INRANGE   = r'\d+\.\.\d+'
#t_EXRANGE   = r'\d+\.\.\.\d+'
 
def t_ARITH_OP(t):
    r'\+|\-|\*|\/|%'
    t.value = float(t.value)
    return t

def t_REL_OP_SING(t):
    r'">"|"<"'
    return t

def t_VAR(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reversed.get(t.value,'ID')
    return t

def t_INT(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_FLOAT(t):
    r'\d+\.\d+'
    t.value = float(t.value)
    return t

def t_STRING(t):
    r'["].*?["]'
    return t

def t_IN_RANGE(t):
    r'\d+\.\.\d+'
    return 

 # A regular expression rule with some action code
#  def t_NUMBER(t):
#      r'\d+'
#      t.value = int(t.value)
#      return t
 
#  # Define a rule so we can track line numbers
#  def t_newline(t):
#      r'\n+'
#      t.lexer.lineno += len(t.value)
 
#  # A string containing ignored characters (spaces and tabs)
#  t_ignore  = ' \t'
 
#  # Error handling rule
#  def t_error(t):
#      print(Illegal character '%s' % t.value[0])
#      t.lexer.skip(1)
 
 # Build the lexer
lexer = lex.lex()