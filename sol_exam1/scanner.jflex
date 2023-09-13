import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

%{
	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	
	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
	
%}

uint    = 0 | [1-9][0-9]*
word    = [A-Za-z]+
id      = [_A-Za-z][_A-Za-z0-9]*
comment = "//".*

%%

"("                 { return new Symbol(sym.RO, yyline, yycolumn); }
")"                 { return new Symbol(sym.RC, yyline, yycolumn); }
":"                 { return new Symbol(sym.C, yyline, yycolumn); }
"->"                { return new Symbol(sym.ARR, yyline, yycolumn); }
","                 { return new Symbol(sym.CM, yyline, yycolumn); }
"."                 { return new Symbol(sym.DOT, yyline, yycolumn); }
"*"                 { return new Symbol(sym.STAR, yyline, yycolumn); }
"+"                 { return new Symbol(sym.PLUS, yyline, yycolumn); }
"/"                 { return new Symbol(sym.DIV, yyline, yycolumn); }
"-"                 { return new Symbol(sym.MIN, yyline, yycolumn); }
";"                 { return new Symbol(sym.S, yyline, yycolumn); }
"="                 { return new Symbol(sym.EQ, yyline, yycolumn); }
{uint}              { return new Symbol(sym.UINT, yyline, yycolumn, new Integer(yytext())); }
{word}              { return new Symbol(sym.WORD, yyline, yycolumn, new String(yytext())); }
{id}                { return new Symbol(sym.ID, yyline, yycolumn, new String(yytext())); }
{comment}           { ; }

\r|\n|\r\n|" "|\t	{ ; }
.                   { ; }
