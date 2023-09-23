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

odd_num		=	("-"27[13]) |
				("-"2[0-6][13579]) |
				("-"1[0-9][13579]) |
				("-"[1-9][13579]) |
				("-"[13579]) |
				[13579] |
				([1-9][13579]) |
				([123][0-9][13579]) |
				(4[0-4][13579]) |
				(45[1357])

token1		=	(A "_" {odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}) |
				(A "_" {odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}) |
				(A "_" {odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num}"*"{odd_num})

date		=	2023 "/" ((09)|"September") "/" ((2[2-9]) | (30)) |
				2023 "/" ((10)|"October") "/" ((0[1-9]) | ([12][0-9]) | (3[01])) |
				2023 "/" ((11)|"November") "/" ((0[1-9]) | ([12][0-9]) | (30)) |
				2023 "/" ((12)|"December") "/" ((0[1-9]) | ([12][0-9]) | (3[01])) |
				2024 "/" ((01)|"January") "/" ((0[1-9]) | ([12][0-9]) | (3[01])) |
				2024 "/" ((02)|"February") "/" (0[1-7])

token2		=	B "_" {date}

sep 		=	"*" | "$" | "&"

exa 		=	([0-9a-fA-F]{4}){1,2}

token3		=	C "_" ({exa}{sep}{exa}{sep}{exa}{sep}{exa}) ({sep}{exa}{sep}{exa})*

uint        =   0 | ([1-9][0-9]*)

comment		=	"[[+".*"+]]"

%%


{token1}            { return new Symbol(sym.TOKEN1, yyline, yycolumn); }
{token2}            { return new Symbol(sym.TOKEN2, yyline, yycolumn); }
{token3}            { return new Symbol(sym.TOKEN3, yyline, yycolumn); }
{uint}              { return new Symbol(sym.UINT, yyline, yycolumn, new Integer(yytext())); }
"["					{ return new Symbol(sym.SO, yyline, yycolumn); }
"]"					{ return new Symbol(sym.SC, yyline, yycolumn); }
"("					{ return new Symbol(sym.RO, yyline, yycolumn); }
")"					{ return new Symbol(sym.RC, yyline, yycolumn); }
","					{ return new Symbol(sym.CM, yyline, yycolumn); }
"+"					{ return new Symbol(sym.PLUS, yyline, yycolumn); }
"-"					{ return new Symbol(sym.MIN, yyline, yycolumn); }
"*"					{ return new Symbol(sym.STAR, yyline, yycolumn); }
"/"					{ return new Symbol(sym.DIV, yyline, yycolumn); }
"INS"				{ return new Symbol(sym.INS, yyline, yycolumn); }
"CMP"				{ return new Symbol(sym.CMP, yyline, yycolumn); }
"SUM"				{ return new Symbol(sym.SUM, yyline, yycolumn); }
";"					{ return new Symbol(sym.S, yyline, yycolumn); }
"##"				{ return new Symbol(sym.SEP, yyline, yycolumn); }

{comment}           { ; }

\r | \n | \r\n | " " | \t	{;}

.					{ System.out.println("Scanner Error: " + yytext()); }
