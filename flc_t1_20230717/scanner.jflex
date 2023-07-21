/**************************
 Scanner
***************************/

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

comment 	= ("//".*) | ("{" "{" .* "}" "}")


// token1

hexadecimal = 2 ([7-9]|[A-Fa-f]) [A-Fa-f] |
			  ([3-9]|[A-Fa-f]) ([0-9]|[A-Fa-f]){2} |
			  12B [0-3] |
			  12 ([0-9]|[Aa]) ([0-9]|[A-Fa-f]) |
			  1 [0-1] ([0-9]|[A-Fa-f]){2}

odd_alpha = [A-Za-z]{5} ([A-Za-z]{2})*
			  
token1 = {hexadecimal} "*" {odd_alpha} "-" ( ("****"("**")*) | ("Y" "X"("XX")* "Y") ){0,1}


// token2

ip_num = (2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])
ip = {ip_num}"."{ip_num}"."{ip_num}"."{ip_num}

date = 2023 "/" 12 "/" (0[1-9]|[1-2][0-9]|3[0-1]) |
	   2023 "/" 11 "/" (0[1-9]|[1-2][0-9]|30) |
	   2023 "/" 10 "/" (0[5-9]|[1-2][0-9]|3[0-1]) |
	   2024 "/" 01 "/" (0[1-9]|[1-2][0-9]|3[0-1]) |
	   2024 "/" 02 "/" (0[1-9]|[1-2][0-9]) |
	   2024 "/" 03 "/" 0[1-3]

token2 = {ip} "-" {date}


// token3

number = ([0-9][0-9][0-9][0-9]) | ([0-9][0-9][0-9][0-9][0-9][0-9])

token3 = {number}("-"|"+"){number}("-"|"+"){number} | 
		 {number}("-"|"+"){number}("-"|"+"){number}("-"|"+"){number}("-"|"+"){number}


q_string	= \" [-_A-Za-z0-9]+ \"
uint		= 0 | ([1-9][0-9]*)
double		= (0|[1-9][0-9]*) "." [0-9]+


%%

{token1}	{ return new Symbol(sym.TOKEN1, yyline, yycolumn); }
{token2}	{ return new Symbol(sym.TOKEN2, yyline, yycolumn); }
{token3}	{ return new Symbol(sym.TOKEN3, yyline, yycolumn); }
{q_string}	{ return new Symbol(sym.QSTRING, yyline, yycolumn, new String(yytext())); }
{uint}		{ return new Symbol(sym.UINT, yyline, yycolumn, new Integer(yytext())); }
{double}	{ return new Symbol(sym.DOUBLE, yyline, yycolumn, new Double(yytext())); }

"***"		{ return new Symbol(sym.SEP, yyline, yycolumn); }
"-"			{ return new Symbol(sym.MINUS, yyline, yycolumn); }
";"			{ return new Symbol(sym.S, yyline, yycolumn); }
","			{ return new Symbol(sym.CM, yyline, yycolumn); }
"euro"		{ return new Symbol(sym.EURO, yyline, yycolumn); }
"%"			{ return new Symbol(sym.PERC, yyline, yycolumn); }


{comment}	{ ; }

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
