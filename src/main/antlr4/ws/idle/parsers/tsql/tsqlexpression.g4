parser grammar tsqlexpression;

// This is ANTLR4 versions of expressions for TSQL. Note that an expression
// is overly permissive in what it allows as an expression. This is because
// the parser is not responsible for validating the expression semantically.
// You need to verify that the expression is valid in the context in which
// it is used.

// Expression is either used directly or used in a higher construct such as search_condition
// Note that it accepts syntax that is not valid but looks valid to the parser. This is normal
// practice, and your walker or semantic pass should catch these errors.
//
// For instance promitives such as ON or OFF are really only valid for setting options
// in a SET statement, but the parser will accept them as valid expressions. Such as:
//
// SELECT A + ON
//
// This will also accept tings liek logical expression for set expressions, so you
// must make sure that the expression is valid in the context in which it is used.
//
expression
    : LPAREN expression RPAREN	                                #exprPrecedence
    | <assoc=right> expression (DOT expression)+                #exprDot
    | <assoc=right> OPBNOT expression                           #exprBitNot
    | <assoc=right> op=(OPMINUS | OPPLUS) expression            #exprUnary
    | expression op=(OPMUL | OPDIV | OPMOD) expression          #exprOpPrec1
    | expression op=(OPPLUS | OPMINUS) expression               #exprOpPrec2
    | expression op=(OPBAND | OPBXOR | OPBOR) expression        #exprOpPrec3
    | expression OPCAT expression                               #exprOpCat
    | expression op=(OPSEQ | OPMULEQ | OPDIVEQ |
                     OPMODEQ | OPBANDEQ | OPBOREQ | OPMINUSEQ
                     | OPBXOREQ)
                     expression                                 #exprOpPrec5
    | expression op=(
                          OPEQ | OPNE | OPGE | OPNGT | OPLE
                        | OPLT | OPGT
                        | OPNLT | OPNGT
                    )
                    expression                                  #exprOpPrec6
    | expression op=(KNOT | BANG) expression                    #exprLogicNot
    | expression op=KOR expression                              #exprLogicOr
    | expression op=KAND expression                             #exprLogicAnd

    // Not expression opertors per-se, but used in expressions and recurse to expression
    // They are labelled because they must all be labeled. But are likely better visited
    // directly.

    | functions_and_vars	                    #exprFV     // Function calls and variable references
    | paren_sub_query                           #exprPSQ    // Subquery (though must be scalar for an expression, and should be checked)
    | someAllAny predicated_paren_sub_query     #exprSAA    // SOME / ANY / ALL with a subquery
    | expression order_by_collate               #exprOBC    // Collations and ORDER BY
    | case_expression                           #exprCase   // An atomic value based on a CASE expression
    | expression COLON COLON expression         #exprStatic // Static property
    | keyw_id_part                              #exprId     // An identifier, which may be [bracketed] etc
    | money     			                    #exprMoney  // A DECIMAL or integer, preceded by a currency symbol
    | atoms                                     #exprAtoms  // An atomic value
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
    | ON                // ON is easier to just stick here and use it only when it is allowed
    | OFF
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
