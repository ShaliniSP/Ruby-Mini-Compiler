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
    T_class = 274,
    T_openpar = 275,
    T_closepar = 276,
    T_opencurly = 277,
    T_closecurly = 278,
    T_openbox = 279,
    T_closebox = 280,
    T_asop = 281,
    T_exp = 282,
    T_comp = 283,
    T_gte = 284,
    T_lte = 285,
    T_ne = 286,
    T_ccomp = 287,
    T_scomp = 288,
    T_expas = 289,
    T_addas = 290,
    T_subas = 291,
    T_mulas = 292,
    T_divas = 293,
    T_modas = 294,
    T_and = 295,
    T_or = 296,
    T_not = 297,
    T_comma = 298,
    T_true = 299,
    T_false = 300,
    T_inrange = 301,
    T_exrange = 302
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
#define T_class 274
#define T_openpar 275
#define T_closepar 276
#define T_opencurly 277
#define T_closecurly 278
#define T_openbox 279
#define T_closebox 280
#define T_asop 281
#define T_exp 282
#define T_comp 283
#define T_gte 284
#define T_lte 285
#define T_ne 286
#define T_ccomp 287
#define T_scomp 288
#define T_expas 289
#define T_addas 290
#define T_subas 291
#define T_mulas 292
#define T_divas 293
#define T_modas 294
#define T_and 295
#define T_or 296
#define T_not 297
#define T_comma 298
#define T_true 299
#define T_false 300
#define T_inrange 301
#define T_exrange 302

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 17 "ruby2.y" /* yacc.c:1909  */

    char *id;
    char* array;
    int intval;
    char *str;
    float floatval;
    int boo;
    int arithop;
    int relop;
    int asop;
    struct table{
        char *tok_name;
        char *tok_val;
        char *scope;
        int line_no;
        int int_val;
        float float_val;
        int bool_val;
        char* str;
        char* array;
        int occurences;
    }table;

    struct table tab_arr[20];

#line 174 "y.tab.h" /* yacc.c:1909  */
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
