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

start_token1    =   ("%%%%%"("%%")*) | (("**"|"???"){2,3})
end_token1      =   ("-"3[135]) | ("-"[12][13579]) | ("-"[13579]) |
                    [13579] | ([1-9][13579]) | ([12][0-9][13579]) | (3[012][13579]) |
                    (33[13])
token1          =   {start_token1}{end_token1}{0,1}

date            =   (2015 "/" 12 "/" (1[2-9] | 2[0-9] | 3[01])) |
                    (2016 "/" 01 "/" (0[12346789] | [12][0-9] | 3[01])) |
                    (2016 "/" 02 "/" (0[1-9] | [12][0-9])) |
                    (2016 "/" 03 "/" (0[1-9] | 1[0-3]))
token2          =   {date} ("+"|"-") {date}

binary_num      =   (101) | (110) | (111) |
                    (1 (0|1){3,4}) |
                    (100 (0|1){3}) |
                    101000
token3          =   "$"{binary_num}

sep             =   "####"("##")*

quoted_string   =   \" [_A-Za-z0-9]+ \"

uint            =   0 | ([1-9][0-9]*)

comment         =   "//".*

%%

";"                 { return new Symbol(sym.S, yyline, yycolumn); }
"{"                 { return new Symbol(sym.BO, yyline, yycolumn); }
"}"                 { return new Symbol(sym.BC, yyline, yycolumn); }
"="                 { return new Symbol(sym.EQ, yyline, yycolumn); }
"m/s"               { return new Symbol(sym.MS, yyline, yycolumn); }
","                 { return new Symbol(sym.CM, yyline, yycolumn); }
"->"                { return new Symbol(sym.ARR, yyline, yycolumn); }
"("                 { return new Symbol(sym.RO, yyline, yycolumn); }
")"                 { return new Symbol(sym.RC, yyline, yycolumn); }
"PRINT_MIN_MAX"     { return new Symbol(sym.PMM, yyline, yycolumn); }
"PART"              { return new Symbol(sym.PART, yyline, yycolumn); }
":"                 { return new Symbol(sym.C, yyline, yycolumn); }
"|"                 { return new Symbol(sym.PARTSEP, yyline, yycolumn); }
"m"                 { return new Symbol(sym.M, yyline, yycolumn); }
{token1}            { return new Symbol(sym.TOKEN1, yyline, yycolumn); }
{token2}            { return new Symbol(sym.TOKEN2, yyline, yycolumn); }
{token3}            { return new Symbol(sym.TOKEN3, yyline, yycolumn); }
{sep}               { return new Symbol(sym.SEP, yyline, yycolumn); }
{quoted_string}     { return new Symbol(sym.QSTRING, yyline, yycolumn, new String(yytext())); }
{uint}              { return new Symbol(sym.UINT, yyline, yycolumn, new Integer(yytext())); }
{comment}           { ; }
\r|\n|\r\n|" "|\t	{ ; }
.                   { System.out.println("Scanner Error: " + yytext()); }
