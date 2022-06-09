%define parse.error verbose
%define parse.trace

%code requires {
	#include <stdio.h>
	
	extern void yyerror(const char*);
	extern FILE *yyin;
}

%code {
	extern int yylex();
	extern int yylineno;
}

%union {
	char *string;
	double floatValue;
	int intValue;
}

%token AND           "&&"
%token OR            "||"
%token EQ            "=="
%token NEQ           "!="
%token LEQ           "<="
%token GEQ           ">="
%token LSS           "<"
%token GRT           ">"
%token KW_BOOLEAN    "bool"
%token KW_DO         "do"
%token KW_ELSE       "else"
%token KW_FLOAT      "float"
%token KW_FOR        "for"
%token KW_IF         "if"
%token KW_INT        "int"
%token KW_PRINTF     "printf"
%token KW_RETURN     "return"
%token KW_VOID       "void"
%token KW_WHILE      "while"
%token CONST_INT     "integer literal"
%token CONST_FLOAT   "float literal"
%token CONST_BOOLEAN "boolean literal"
%token CONST_STRING  "string literal"
%token ID            "identifier"

%%

program:
	;


%%

int main() {
	yydebug = 1;
	// TODO: add code to open and read from the input file
	// (if passed to the program)
	return yyparse();
}

void yyerror(const char *msg) {
	// TODO: print error messages
}
