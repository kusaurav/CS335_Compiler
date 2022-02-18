%{
	#include <math.h>
	#include<string.h>
	#include<stdlib.h>
	#include<stdio.h>
	#include <stdarg.h>
	#define YYDEBUG 1
	
	extern void yyerror(char *c);
	extern int yylineno;
        extern FILE *yyin;
        extern char* yytext;
	int yylex(void);  
	
%}
%union{
	int iVal;
	char* sVal;
	char cVal;	
};


%token  CLASS CHAR CONST CASE CONTINUE DEFAULT DO DOUBLE
%token  ELSE ENUM EXTERN FALSE NEW FLOAT FOR IF  INT LONG
%token  PRIVATE PROTECTED PUBLIC REGISTER  RETURN SHORT SIGNED STATIC STRUCT SWITCH TYPEDEF THIS  TRUE UNION VOLATILE
%token  UNSIGNED VOID WHILE  BOOL 
%token  AUTO BREAK GOTO IDENTIFIER 


%token   ARROW CONSTANT HEX_CONSTANT OCT_CONSTANT STRING LOR LAND EQ NEQ LE GE LSHIFT RSHIFT INC DEC SIZEOF APLUS AMINUS AMULT ADIV AMOD AAND AOR AXOR LSHIFTEQ RSHIFTEQ
%start prog.start   
%%
prog.start: translation_unit     
			;
constant: 
		 CONSTANT
		| HEX_CONSTANT
		|OCT_CONSTANT 
		;


string_literal_list: STRING
					;



primary_expression : IDENTIFIER
			| constant
			| string_literal_list 
			| THIS
			| '(' expression ')'
			;


expression  : assignment_expression
			| expression ',' assignment_expression
			;
expression_opt: /* nothing */
			|expression
			;

assignment_expression : conditional_expression
					  | unary_expression assignment_operator assignment_expression
					  ;
constant_expression: conditional_expression
                   ;
conditional_expression : logical_or_expression 
					   | logical_or_expression '?' expression ':' conditional_expression
					   ;

logical_or_expression: logical_and_expression 
| logical_or_expression LOR logical_and_expression
;
logical_and_expression: inclusive_or_expression 
| logical_and_expression LAND inclusive_or_expression 
;
inclusive_or_expression: exclusive_or_expression				
	| inclusive_or_expression '|' exclusive_or_expression	
    ;

exclusive_or_expression
	: and_expression				
	| exclusive_or_expression '^' and_expression	
	;	

and_expression
	: equality_expression				
	| and_expression '&' equality_expression	
	;

equality_expression
	: relational_expression					
	| equality_expression EQ relational_expression	
	| equality_expression NEQ relational_expression	
	;		

relational_expression
	: shift_expression				
	| relational_expression '<' shift_expression	
	| relational_expression '>' shift_expression	
	| relational_expression LE shift_expression	
	| relational_expression GE shift_expression	
	;

shift_expression
	: additive_expression				
	| shift_expression LSHIFT additive_expression	
	| shift_expression RSHIFT additive_expression	
	;	

additive_expression
	: multiplicative_expression				
	| additive_expression '+' multiplicative_expression	
	| additive_expression '-' multiplicative_expression	
	;

multiplicative_expression
	: cast_expression				
	| multiplicative_expression '*' cast_expression	
	| multiplicative_expression '/' cast_expression	
	| multiplicative_expression '%' cast_expression	
	;	


cast_expression
	: unary_expression			
	| '(' type_name ')' cast_expression	
	;
unary_expression: postfix_expression			
	| INC unary_expression		
	| DEC unary_expression		
	| unary_operator cast_expression	
	| SIZEOF unary_expression		
	| SIZEOF '(' type_name ')'		
	;

unary_operator: '&'
			| '*'
			| '+'
			| '-'
			| '~'
			| '!'
			;	
assignment_operator
	: '='		 
	| AMULT	 
	| APLUS	 
	| AMINUS	 
	| ADIV	 
	| AAND	 
	| AOR	 
	| AXOR	 
	| AMOD	 
	| RSHIFTEQ	 
	| LSHIFTEQ 
	;			

postfix_expression
	: primary_expression	
	| postfix_expression '[' expression ']'	

	| postfix_expression '(' ')'	
	| postfix_expression '(' argument_expression_list ')'	

	| postfix_expression '.' IDENTIFIER	
	| postfix_expression ARROW IDENTIFIER
	| postfix_expression INC
	| postfix_expression DEC
	;	

argument_expression_list
	: assignment_expression					
	| argument_expression_list ',' assignment_expression	
	;	

struct_specifier:  struct_id  '{' struct_declaration_list '}'	
	|  struct_id 	 			
	;

struct_id: struct_or_union IDENTIFIER
 ;
struct_or_union: STRUCT 
|UNION
;
;
struct_declaration_list
	:  struct_declaration	 			
	|  struct_declaration_list struct_declaration	
	;
struct_declaration
	:  specifier_qualifier_list struct_declarator_list ';'
	|specifier_qualifier_list ';'	 
	;

specifier_qualifier_list
	:  type_specifier specifier_qualifier_list	
	|  type_specifier	 			
	|  type_qualifier specifier_qualifier_list	
	|  type_qualifier	 		
	;

type_specifier
	:  VOID				
	|  CHAR				
	|  SHORT			
	|  INT				
	|  LONG				
	|  FLOAT			
	|  DOUBLE			
	|  SIGNED			
	|  UNSIGNED	
	| BOOL		
	|  struct_specifier 	
	|  enum_specifier					
	;

type_name
	:  specifier_qualifier_list	 		
	|  specifier_qualifier_list abstract_declarator	
	;	
struct_declarator_list
	:  declarator	 			
	|  struct_declarator_list ',' declarator	 
	;
declarator
	:  pointer direct_declarator	 
	|  direct_declarator	 	
	;


pointer
	:  '*'	 				
	|  '*' type_qualifier_list	 	
	|  '*' pointer	 			
	|  '*' type_qualifier_list pointer
	;
abstract_declarator
	:  pointer	 			
	|  direct_abstract_declarator	 	
	|  pointer direct_abstract_declarator	
	;

direct_abstract_declarator
	:  '[' ']'							
	|  '[' CONSTANT ']'	 				
	|  direct_abstract_declarator '[' ']'				 
	|  direct_abstract_declarator '[' CONSTANT ']'
	;	

direct_declarator
	:  IDENTIFIER	 					 
	|  direct_declarator '[' CONSTANT ']'	 		 
	|  direct_declarator '[' '-' CONSTANT ']'	    
	|  direct_declarator '(' parameter_type_list ')'	
	|  direct_declarator '(' ')'				
	;

type_qualifier_list
	:  type_qualifier	 					
	|  type_qualifier_list type_qualifier	
	;	

parameter_type_list
	:  parameter_list	 	 		
	;

parameter_list
	:  parameter_declaration	 		
	|  parameter_list ',' parameter_declaration	
	;

parameter_declaration
	:  declaration_specifiers declarator	 		
	|  declaration_specifiers abstract_declarator	
	|  declaration_specifiers	 					 
	;
declaration_specifiers
	: storage_class_specifier				
	| storage_class_specifier declaration_specifiers	 
	| type_specifier					
	| type_specifier declaration_specifiers			
	| type_qualifier				
	| type_qualifier declaration_specifiers			
	;	
type_qualifier
	: CONST
	| VOLATILE
	;
storage_class_specifier
	:  TYPEDEF	 
	|  EXTERN	
	|  STATIC	
	|  AUTO	 	
	|  REGISTER	
	;	

enum_specifier
	:  ENUM '{' enumerator_list '}'	 		
	|  ENUM IDENTIFIER '{' enumerator_list '}'
	|  ENUM IDENTIFIER	 			
	;

enumerator_list
	:  enumerator	 			 
	|  enumerator_list ',' enumerator	 
	;

enumerator
	:  IDENTIFIER	 			
	|  IDENTIFIER '=' constant_expression	 
	;
statement
	:  labeled_statement	
	|  compound_statement	 
	|  expression_statement	 
	|  selection_statement	 
	|  iteration_statement	 
	|  jump_statement	 
	;
labeled_statement
	:  IDENTIFIER ':'  statement	 		
	|  CASE constant_expression':'  statement		
	|  DEFAULT ':'  statement	 		
	;


compound_statement
	:  '{' '}'	 			               
	|  '{' statement_list '}'	 		       
	|  '{' declaration_list '}'	 	        
	|  '{' declaration_list statement_list '}'		
	;

declaration_list
	:  declaration	 		 		 
	|  declaration_list declaration	 
	;

statement_list
	:  statement			 	 			 
	|  statement_list  statement
	;

/* This is automatically an expression */
expression_statement			 	
	:  expression_opt ';' 
		
	;

selection_statement
	:  IF '(' expression  ')'  statement	 			
	|  IF '(' expression  ')'  statement  ELSE  statement	
	|  SWITCH '(' expression  ')' statement 			 
	;	

iteration_statement
	:  WHILE '('  expression')'  statement	 
	|  DO  statement WHILE '('  expression  ')' ';'	
	|  FOR '(' expression_opt ';'  expression_opt ';' 
				
			')'  statement	 
	|  FOR '(' expression_opt ';' expression_opt ';'
				
			  expression_opt  ')'  statement	 
	;

jump_statement
	:  GOTO IDENTIFIER ';'	 
	|  CONTINUE ';'	 		
	|  BREAK ';'	 		
	|  RETURN ';'	 		 
	|  RETURN expression_opt ';' 
	;	
translation_unit: external_declaration
| translation_unit external_declaration
;

external_declaration
	:  function_definition	 
	|  declaration	 
	;

declaration
	: declaration_specifiers ';'		 
	| declaration_specifiers init_declarator_list ';'
	
	;
init_declarator_list
	: init_declarator				
	| init_declarator_list ',' init_declarator	 		
	;

init_declarator
	: declarator			
	| declarator '='  assignment_expression	
	;

function_declaration
	: declaration_specifiers declarator 
	;

function_definition
	:  function_declaration compound_statement	 
	;


%%	

extern FILE *yyin;

extern void yyerror(char *c){
		printf("%s\n", c);
	} 


int main(int argc, char* argv[]){
	FILE *file;
	if (argc==2 &&(file=fopen(argv[1],"r"))) {
		yyin = file;
		
		
		}
	else if (argc!=2){
		printf("Please give the file \n");
		
	}
	
yyparse();
	
	
	
	return 0;
}

