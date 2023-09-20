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


exa         =   (27[a-fA-F]) |
                (2[89a-fA-F][0-9a-fA-F]) |
                ([3-9a-fA-F][0-9a-fA-F][0-9a-fA-F]) |
                (12(b|B)[0-3]) |
                (12[0-9aA][0-9a-fA-F]) |
                (1(0|1)[0-9a-fA-F][0-9a-fA-F])

odd_alpha   =   [a-zA-Z]{5}([a-zA-Z]{2})*

token1      =   {exa} "*" {odd_alpha} "-" (("****"("**")*) | (Y(X(XX)*)Y)){0,1}

ip_num      =   [0-9] |
                ([1-9][0-9]) |
                (1[0-9][0-9]) |
                (2[0-4][0-9]) |
                (25[0-5])

ip          =   {ip_num}\.{ip_num}\.{ip_num}\.{ip_num}

date        =   (2023 "/" 10 "/" ((0[5-9]) | ([12][0-9]) | (3[01]))) |
                (2023 "/" 11 "/" ((0[1-9]) | ([12][0-9]) | (30))) |
                (2023 "/" 12 "/" ((0[1-9]) | ([12][0-9]) | (3[01]))) |
                (2024 "/" 01 "/" ((0[1-9]) | ([12][0-9]) | (3[01]))) |
                (2024 "/" 02 "/" ((0[1-9]) | ([12][0-9]))) |
                (2024 "/" 03 "/" 0[1-3])

token2      =   {ip} "-" {date}

num         =   [1-9][0-9]{3} ([0-9]{2}){0,1}

token3      =   {num} ("+"|"-") {num} ("+"|"-") {num} (("+"|"-") {num} ("+"|"-") {num}){0,1}

qstring     =   \" [-_A-Za-z0-9]+ \"

uint        =   0 | ([1-9][0-9]*)

realnum     =   (0 | ([1-9][0-9]*)) \. [0-9]*

comment     =   ("{{".*"}}") | ("//".*)

%%

";"                 { return new Symbol(sym.S, yyline, yycolumn); }
"***"               { return new Symbol(sym.SEP, yyline, yycolumn); }
"-"                 { return new Symbol(sym.MIN, yyline, yycolumn); }
","                 { return new Symbol(sym.CM, yyline, yycolumn); }
"euro"              { return new Symbol(sym.EURO, yyline, yycolumn); }
"%"                 { return new Symbol(sym.PERC, yyline, yycolumn); }
{token1}            { return new Symbol(sym.TOKEN1, yyline, yycolumn); }
{token2}            { return new Symbol(sym.TOKEN2, yyline, yycolumn); }
{token3}            { return new Symbol(sym.TOKEN3, yyline, yycolumn); }
{qstring}           { return new Symbol(sym.QSTRING, yyline, yycolumn, new String(yytext())); }
{uint}              { return new Symbol(sym.UINT, yyline, yycolumn, new Integer(yytext())); }
{realnum}           { return new Symbol(sym.REALNUM, yyline, yycolumn, new Float(yytext())); }
{comment}           { ; }
\r|\n|\r\n|" "|\t	{ ; }
.                   { System.out.println("Scanner Error: " + yytext()); }
