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

// definition of association and precedence of operators
%left '+' '-' OR
%left '*' '/' AND
%nonassoc UMINUS

// workaround for handling dangling else
// LOWER_THAN_ELSE stands for a not existing else
%nonassoc LOWER_THAN_ELSE
%nonassoc KW_ELSE

%%

program: program_starpart;
program_starpart: %empty | program_starpart program_starpart_inner;
program_starpart_inner: declassignment ';' | functiondefinition;

functiondefinition: type id '(' parameterlist ')' '{' statementlist '}'
| type id '(' ')' '{' statementlist '}';

parameterlist: type id parameterlist_starpart;
parameterlist_starpart: %empty | parameterlist_starpart ',' type id;

functioncall: id '(' assignment functioncall_starpart ')'
| id '(' ')';
functioncall_starpart: %empty | functioncall_starpart ',' assignment;

statementlist: statementlist_starpart;
statementlist_starpart: %empty | statementlist_starpart block;

block: '{' statementlist '}'
| statement;

statement: ifstatement
| forstatement
| whilestatement
| returnstatement ';'
| dowhilestatement ';'
| printf ';'
| declassignment ';'
| statassignment ';'
| functioncall ';';

statblock: '{' statementlist '}'
| statement;

ifstatement: KW_IF '(' assignment ')' statblock KW_ELSE statblock %prec KW_ELSE
| KW_IF '(' assignment ')' statblock %prec LOWER_THAN_ELSE;

forstatement: KW_FOR '(' statassignment ';' expr ';' statassignment ')' statblock
| KW_FOR '(' declassignment ';' expr ';' statassignment ')' statblock;

dowhilestatement: KW_DO statblock KW_WHILE '(' assignment ')';

whilestatement: KW_WHILE '(' assignment ')' statblock;

returnstatement: KW_RETURN assignment
| KW_RETURN;

printf: KW_PRINTF '(' assignment ')'
| KW_PRINTF '(' CONST_STRING ')';

declassignment: type id '=' assignment
| type id;

statassignment: id '=' assignment;

assignment: id '=' assignment
| expr;

expr: simpexpr
| simpexpr EQ simpexpr
| simpexpr NEQ simpexpr
| simpexpr LEQ simpexpr 
| simpexpr GEQ simpexpr
| simpexpr LSS simpexpr
| simpexpr GRT simpexpr;

simpexpr: '-' term simpexpr_starpart %prec UMINUS
| term simpexpr_starpart;
simpexpr_starpart: %empty
| simpexpr_starpart simpexpr_starpart_inner;
simpexpr_starpart_inner: '+' term
| '-' term
| OR term;

term: factor term_starpart;
term_starpart: %empty
| term_starpart term_starpart_inner;
term_starpart_inner: '*' factor
| '/' factor
| AND factor;

factor: CONST_INT
| CONST_FLOAT
| CONST_BOOLEAN
| functioncall
| id
| '(' assignment ')';

type: KW_BOOLEAN
| KW_FLOAT
| KW_INT
| KW_VOID;

id: ID;

%%

int main(int argc, char *argv[]) {
	yydebug = 0;

	if (argc < 2) {
		yyin = stdin;
	} else {
		yyin = fopen(argv[1], "r");
		if (yyin == 0) {
			printf("ERROR: Datei %s nicht gefunden", argv[1]);
		}
	}

	return yyparse();
}

void yyerror(const char *msg) {
	fprintf(stderr, "Line %d: %s\n", yylineno, msg);
}
