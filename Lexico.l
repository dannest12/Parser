%{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
int lineas = 0;
%}
%option noyywrap
%option yylineno

letra           [a-zA-Z_]
DIGITO          [0-9]
ID              ([a-zA-Z]|"_")([a-zA-Z0-9]|"_")*
TIPOSDATO       "char"|"int"|"long"|"short"|"float"|"double"|"void"
OPRELACION      "<"|">"|">="|"<="|"!="|"=="
OPINCREMENTO    "+"|"-"|"*"|"/"
OPINCREMENTO2   "++"|"--"
OPINCREMENTO3   "+="|"-="|"*="|"/="
OPLOG           "&&"|"||"

%%

"else"                      {yylval.valor = strdup(yytext); return(T_ELSE);}
"switch"                    {yylval.valor = strdup(yytext); return(T_SWITCH);}
"case"                      {yylval.valor = strdup(yytext); return(T_CASE);}
"for"                       {yylval.valor = strdup(yytext); return(T_FOR);}
"while"                     {yylval.valor = strdup(yytext); return(T_WHILE);}
"do"                        {yylval.valor = strdup(yytext); return(T_DO);}
"if"                        {yylval.valor = strdup(yytext); return(T_IF);}
"return"                    {yylval.valor = strdup(yytext); return(T_RETURN);}
"break"                     {yylval.valor = strdup(yytext); return(T_BREAK);}
"struct"                    {yylval.valor = strdup(yytext); return(T_STRUCT);}
{DIGITO}+                   {yylval.valor = strdup(yytext); return(T_INT);}
{DIGITO}+"."{DIGITO}+       {yylval.valor = strdup(yytext); return(T_FLOAT);}
"'"{letra}"'"               {yylval.valor = strdup(yytext); return(T_CAR);}
"\""{letra}"\""             {yylval.valor = strdup(yytext); return(T_CHAR);}
{TIPOSDATO}                 {yylval.valor = strdup(yytext); return(T_TDATO);}
{ID}                        {yylval.valor = strdup(yytext); return(T_ID);}
{OPINCREMENTO}              {yylval.valor = strdup(yytext); return(T_INCR);}
{OPINCREMENTO3}             {yylval.valor = strdup(yytext); return(T_OPAARIT);}
{OPINCREMENTO2}             {yylval.valor = strdup(yytext); return(T_INCR2);}
{OPRELACION}                {yylval.valor = strdup(yytext); return(T_OPRELACION);}
{OPLOG}                     {yylval.valor = strdup(yytext); return(T_ANDOR);}
";"                         {yylval.valor = strdup(yytext); return(T_PTCOM);}
","                         {yylval.valor = strdup(yytext); return(T_COMA);}
":"                         {yylval.valor = strdup(yytext); return(T_DOSPTO);}
"="                         {yylval.valor = strdup(yytext); return(T_OPASIG);}
"("                         {yylval.valor = strdup(yytext); return(T_PA);}
")"                         {yylval.valor = strdup(yytext); return(T_PC);}
"{"                         {yylval.valor = strdup(yytext); return(T_CA);}
"}"                         {yylval.valor = strdup(yytext); return(T_CC);}
\n      ++lineas;
.       {}
%%
