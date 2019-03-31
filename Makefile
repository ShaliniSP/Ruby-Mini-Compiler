all:
	lex ruby.l
	yacc -d ruby2.y -v
	gcc lex.yy.c y.tab.c -ll -ly
	
