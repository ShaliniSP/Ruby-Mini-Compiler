/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_int = 258,
    T_flt = 259,
    T_id = 260,
    T_string = 261,
    T_ARITH_OP = 262,
    T_REL_OP_SING = 263,
    T_puts = 264,
    T_do = 265,
    T_end = 266,
    T_begin = 267,
    T_when = 268,
    T_case = 269,
    T_while = 270,
    T_else = 271,
    T_return = 272,
    T_def = 273,
    T_asop = 274,
    T_exp = 275,
    T_comp = 276,
    T_gte = 277,
    T_lte = 278,
    T_ne = 279,
    T_ccomp = 280,
    T_scomp = 281,
    T_expas = 282,
    T_addas = 283,
    T_subas = 284,
    T_mulas = 285,
    T_divas = 286,
    T_modas = 287,
    T_and = 288,
    T_or = 289,
    T_not = 290,
    T_true = 291,
    T_false = 292,
    T_inrange = 293,
    T_exrange = 294
  };
#endif
/* Tokens.  */
#define T_int 258
#define T_flt 259
#define T_id 260
#define T_string 261
#define T_ARITH_OP 262
#define T_REL_OP_SING 263
#define T_puts 264
#define T_do 265
#define T_end 266
#define T_begin 267
#define T_when 268
#define T_case 269
#define T_while 270
#define T_else 271
#define T_return 272
#define T_def 273
#define T_asop 274
#define T_exp 275
#define T_comp 276
#define T_gte 277
#define T_lte 278
#define T_ne 279
#define T_ccomp 280
#define T_scomp 281
#define T_expas 282
#define T_addas 283
#define T_subas 284
#define T_mulas 285
#define T_divas 286
#define T_modas 287
#define T_and 288
#define T_or 289
#define T_not 290
#define T_true 291
#define T_false 292
#define T_inrange 293
#define T_exrange 294

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 15 "ruby2.y" /* yacc.c:1909  */

    int intval;
    char *str;
    float floatval;
    int boo;
    int arithop;
    int relop;
    int asop;
    st_rec* symbol_table[100];  //Chained hash

#line 143 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
