parser grammar tsqlexpression;

// This is ANTLR4 versions of expressions for TSQL. Note that an expression
// is overly permissive in what it allows as an expression. This is because
// the parser is not responsible for validating the expression semantically.
// You need to verify that the expression is valid in the context in which
// it is used.

// Expression is either used directly or used in a higher construct such as search_condition
//
expression
    : LPAREN expression RPAREN	// An expression with precedence
    | (OPMINUS | OPPLUS | OPBNOT) expression
    | keyw_id               // An identifier, which may take x.y.z form
    | atoms
    | money     			// A DECIMAL or integer, preceded by a currency symbol
    | functions_and_vars	// Function calls and variable references
    | paren_sub_query       // Subquery (though must be scalar for an expression, and this should be checked in your next phase)
    | function              // Function call is not always valid, use your semantic checker to verify
    | expression DOT expression
    | someAllAny predicated_paren_sub_query
    | expression op1=operators_prec_1 expression
    | expression op2=operators_prec_2 expression
    | expression (op3=operators_prec_3 | do=dodgy_operators)
             expression
    | expression op4=operators_prec_4 expression
    | expression order_by_collate
    | expression COLON COLON expression // Static property
    ;

operators_prec_1
    : OPMUL | OPDIV | OPMOD
    ;

operators_prec_2
    : OPPLUS | OPMINUS
    ;

operators_prec_3
    : OPSEQ | OPMULEQ | OPDIVEQ | OPMODEQ | OPBANDEQ | OPBOREQ | OPMINUSEQ | OPBXOREQ
    | OPEQ | OPNE | OPGE | OPNGT | OPLE | OPNLT | OPLT | OPGT
    | OPBAND | OPBXOR | OPBOR | OPBNOT
    ;

operators_prec_4
    : KAND | KOR | KNOT
    ;

// T-SQL lexer is weak and allows <      > to mean OPNE and so on
//
dodgy_operators
    : ol=OPLT
        (
              OPGT
            | OPEQ
            |
        )

    | og=OPGT
        (
              OPEQ
            |
        )

    | BANG
        (
              OPLT
            | OPGT
        )
    ;

// Elements that are atoms are elements that can be reduced no further
// because they are things like constants such as 42.
//
atoms
	: INTEGER			// As the name implies just a string of digits with no decimal point
	| DECIMAL			// A number containing a decimal point
	| FLOAT				// A number specified in scientific notation NNN.NNNENNN
    | HEXNUM            // A Hexadecimal number of the form 0xXXXX...
    | KNULL             // NULL
    | SQ_LITERAL        // A string literal
    | DQ_LITERAL        // A string literal
    | BR_LITERAL        // A string literal
	| case_expression	// An atomic value based on a CASE expression
	;

case_expression
	: CASE
		(
				search_condition
				case_when_clause+
			|	case_boolean_when_clause+
		)
		case_else?
	  END
	;

///////////////////////////////////////////////////////////////////////////////////
// Specially constructed constants as parser rules to enable multiple use
// where a specific type or set of types is required, or where the makeup
// of the syntactical element must be a number of lexer tokens, such
// as with currency values. In general, these are parser rules representing
// elements as named in the SQL Server Online Books
//

money
	: (DOLLAR | CURRENCY_SYMBOL) (OPMINUS | OPPLUS )? (INTEGER | DECIMAL)
	;

case_else
	: ELSE expression
	;

case_when_clause
	: WHEN search_condition THEN expression
	;

case_boolean_when_clause
	: WHEN search_condition THEN e=expression
	;
