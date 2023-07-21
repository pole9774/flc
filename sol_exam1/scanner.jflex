import java_cup.runtime.*;

%%

%cup

number		=	[0-9]+
word 		=	[a-zA-Z]+
comment		=	"//".*
ident  		=	[_a-zA-Z][_a-zA-Z0-9]*


%%

"->"    	{return new Symbol(sym.ARROW); }
"-"		{return new Symbol(sym.MINUS); }
"+"		{return new Symbol(sym.PLUS); }
"/"		{return new Symbol(sym.DIV); }
"*"		{return new Symbol(sym.STAR); }
"("		{return new Symbol(sym.OB); }
")"		{return new Symbol(sym.CB); }
";"		{return new Symbol(sym.SC); }
","		{return new Symbol(sym.C); }
"."		{return new Symbol(sym.D); }
":"		{return new Symbol(sym.DD); }
"="		{return new Symbol(sym.EQ); }

{comment} 	{;}
{number}	{return new Symbol(sym.NUMBER, new Integer(yytext())); }
{word}		{return new Symbol(sym.WORD, new String(yytext())); }
{ident} 	{return new Symbol(sym.ID, new String(yytext())); }

\n|\r|\r\n 	{;}
[ \t]		{;}

