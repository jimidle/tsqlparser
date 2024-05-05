parser grammar TSqlParser;

options
{
	// Import the lexers token numbering scheme.
	//
	tokenVocab	= TSqlTokens;
}

 
// Import the grammar for the million SQL statements
//
import tsqlcommon, tsqlexpression, tsqlselect, tsqlalter, tsqlcreate, tsqlpermissions, tsqlcursors, tsqlmisc, tsqlmisc2, tsqldrop;

aaa_translation_unit
        : b=batch_statements EOF
        ;

batch_statements
	    :	 first_exec*
            (     statements
                | (SEMI)
            )*
	    ;

first_exec
    :  exec_sp (SEMI)*
    ;
///////////////////////////////////////////////////
// Statements
//

statement_block
        : s+=statements+
        |
        ;

statements
		: ddl_statements
		| sql_statements
        | execute_statement ( fe+=first_exec)*
        | GO (SEMI)*
                    (first_exec)*
		;
		
ddl_statements
		: add_statement
		| alter_statement
        | create_statement
		| backup_statement
		| bulk_statement
        | cursor_ddl
        | permissions_ddl
        | drop_statement
		;
		
sql_statements
		: select_statement
		| use_statement
		| with_common_table
        | miscellaneous_statements
        | cursor_statements
		;

///////////////////////////////////////////////////////////
// use_statement statements
//
use_statement 
	: USE keyw_id SEMI?
	;
// End: use_statement
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// WITH common table expression
//
with_common_table
		: WITH common_table_expression_list
			(
				  select_statement
                | delete_statement
                | insert_statement
                | update_statement
                | merge_statement
			)
			SEMI?
		;
		
common_table_expression_list
		: ce+=common_table_expression (COMMA ce+=common_table_expression)*
		

		;

common_table_expression
		: tn=func_keyw_id ccl=cte_col_list?
			AS 	LPAREN
					cqd=cte_query_definition
				RPAREN
				

		;
				
cte_col_list
		: LPAREN
			cn+=column_name (COMMA cn+=column_name)*
		  RPAREN
		  

		;

cte_query_definition
		: select_statement
		;
// End: WITH common table expression
///////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////
// ADD statements...
//
add_statement
		: KADD COUNTER? SIGNATURE TO module BY crypto_list SEMI?
		;

module	: module_class? module_name
		;
		
module_class
		: (keyw_id COLON COLON)
		;
		
module_name
		: keyw_id
		;
		
crypto_list
		: crypto_options (COMMA crypto_options)*
		;
		
crypto_options
		: CERTIFICATE keyw_id		pass_sig_opts?
		| ASYMMETRIC KEY keyw_id 	pass_sig_opts?
		;
		
pass_sig_opts
		:  WITH  (
		  			  PASSWORD OPEQ SQ_LITERAL
		  			| SIGNATURE OPEQ keyw_id
		  		)
		;
// End: ADD statement
///////////////////////////////////////////////////////////







	
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
// Common syntactical elements, shared between two or more rules.
//
not_for_replication
	: KNOT FOR REPLICATION
	;

keyw_id_paren_list
	: LPAREN keyw_id_list RPAREN
	;
	
keyw_id_list
	: k+=keyw_id (COMMA k+=keyw_id)*
	;
	
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
	
///////////////////////////////////////////////////////////
// Definition of a search condition
//
search_condition
		: sc=search_conditions
		;

search_conditions
		: or_predicate (KOR or_predicate)*
		;

or_predicate
		: and_predicate (KAND and_predicate)*
		;

and_predicate
		: (KNOT)? predicate
		;

predicate
	: expression
		(
			  (KNOT)?
				(
					  LIKE expression (ESCAPE SQ_LITERAL)?
					| BETWEEN expression KAND expression
					| KIN
						LPAREN
						(
		  					  psq=predicated_sub_query
							| el=expression_list
						)
  						RPAREN
				)
			| IS KNOT? KNULL
            |
		)
	| CONTAINS
		LPAREN
            (
                  column_list_np (COMMA SQ_LITERAL)?
                | OPMUL COMMA (SQ_LITERAL|keyw_id)
            )
		RPAREN
	| FREETEXT
		LPAREN
			(
                  column_list_np (COMMA SQ_LITERAL)?
                | OPMUL COMMA (SQ_LITERAL|keyw_id)
            )
		RPAREN
	| EXISTS paren_sub_query
	;

someAllAny
	: (SOME | ALL | ANY)
	;
	    
column_list_np
	: column_name (COMMA column_name)*
	;

column_list
	: LPAREN column_list_np RPAREN
	| OPMUL
	;
// End: Search Condition
///////////////////////////////////////////////////////////

// Expression parser, with implicit precedence.
//
expression_list
		: expression (COMMA expression)*
		;

// --------------------------
// Generic function handler. Because some of the functions are without
// parameters and the () are optional for these, we basically just track everything here and then
// rewrite to the tree based on what we can make sense of here syntactically. The
// tree parsing phase should verify the semantic of everything else based on declarations
// and so on. Most functions are not declared as keywords here as they are just the same pattern
// of keyword followed by a parenthesised list. Some functions, such as rowset or ranking
// functions have specific syntax that does make sense to actually parse rather than conduct
// only semantic analysis.
//
functions_and_vars
	: aggregate_windowed_functions
    | ranking_functions
    | function
    | keyw_id_for_func
	;

function
    : func_name
        (
            function_args
        )
    ;

func_name
    : keyw_id_for_func

    // Some functions, if list in the keyword as var list, will cause massive ambiguity
    // so
    | UPDATE
    | RIGHT
    | LEFT
    | IDENTITY
    ;

function_args
	: LPAREN pl=param_list_or_all? RPAREN
	;
	
param_list_or_all
	: param_list
	| OPMUL
	;
	
param_list
	: p+=param_list_el (COMMA p+=param_list_el)*
	;

param_list_el
    :  LPAREN RPAREN
    | LPAREN param_list RPAREN  // 2008 R2 table constructor
    | expression
    | DEFAULT
    ;
	
rowset_function
	: CONTAINSTABLE 	fc_table_clause			// Precise and fuzzy matching
	| FREETEXTTABLE	fc_table_clause			// Freetext column searching
	| OPENDATASOURCE							// Connect to OLEDB data sink
		LPAREN
			SQ_LITERAL							// PROGID of the OLE DB provider
            COMMA
			SQ_LITERAL							// Connection/Initialization string
		RPAREN
		
			DOT keyw_id							// Navigation to a specific table in the OLEDB connection
			
	| OPENQUERY
		LPAREN
			keyw_id_part						// Handle variable for the linked OLE DB provider
            COMMA
			SQ_LITERAL							// Connection/Initialization string
		RPAREN
			
	| OPENROWSET
		LPAREN
		  (
			  oledbProvider
			  
			| bulkRows
		  )
		RPAREN
	
	| OPENXML 			openxml_clause			// XML table source
	;

bulkRows
	: BULK										// BULK import option from data files
				SQ_LITERAL									// Path to the import data file
                COMMA
				(
					  FORMATFILE OPEQ SQ_LITERAL 				// Path to definition file describing the import data
									bulk_options?				// Possible option list
					| SINGLE_BLOB
					| SINGLE_CLOB
					| SINGLE_NCLOB
				)
	;
	
oledbProvider
	: sl=SQ_LITERAL								// OLE DB provider name
			  (
				COMMA 
					cs=connectionString
				COMMA
					(keyw_id | SQ_LITERAL)
			  )?					// IF omitted then the string is assumed to be a passthru query
			  

	;
	
connectionString
	: s1=SQ_LITERAL								// Connection/Initialization string
		(SEMI s2=SQ_LITERAL SEMI s3=SQ_LITERAL)?		// Connection string is optionally 3 params ds, user, passwd
		

					
	;
	
bulk_options
	: (COMMA boe+=bulk_options_ents)+
	

	;
	
bulk_options_ents
	: CODEPAGE 			OPEQ SQ_LITERAL
	| ERRORFILE 		OPEQ SQ_LITERAL
	| FIRSTROW			OPEQ INTEGER
	| LASTROW 			OPEQ INTEGER
	| MAXERRORS 		OPEQ INTEGER
	| ROWS_PER_BATCH	OPEQ INTEGER
	;
		
fc_table_clause
	: LPAREN
	  
	  	keyw_id				// Table name
	  	COMMA
	  		(
	  			  func_keyw_id		// Column name in the contains table
	  			| column_list		// List of columns in the contains table
	  		)
	  	COMMA SQ_LITERAL			// The contains condition, which is a thing unto itself
	  	(COMMA LANGUAGE
	  			(
	  				  INTEGER		// Language identifier (LCID)
	  				| SQ_LITERAL	// Alias in syslanguages table
	  				| HEXNUM		// HEx representation of the LCID
	  			)
	  	)?
	  	(COMMA expression)?			// Ranking limiter - probably literal or @var only, but it isn't the job of the
	  								// parser to work that out yet.	
	  	
	  RPAREN
	;
	
openxml_clause
	: LPAREN
		
		func_keyw_id			// Document handle

		COMMA expression		// XPATH Pattern into the doc. Expression is allowed here but it must
								// of course yield a string, or semantics will throw it out.
			
		(COMMA INTEGER)?		// Mapping flags

      RPAREN
		(


                WITH LPAREN
				(
					  schema_declaration
					| keyw_id
				)
				RPAREN
		)?
										
	  
	;

schema_declaration
	: scd+=schema_col_def (COMMA scd+=schema_col_def)*
	

	;

schema_col_def
	: scd=schema_col_def_set

	;

schema_col_def_set
	: func_keyw_id ct_data_type
			  SQ_LITERAL?			// XPath column pattern or XML meta property mp:xxxx
	;
	
ranking_functions
	: 	(
			  ROW_NUMBER	(LPAREN RPAREN)?
			| RANK			(LPAREN RPAREN)?
			| DENSE_RANK	(LPAREN RPAREN)?
			| NTILE			LPAREN INTEGER RPAREN
	  	)
	  		ranking_over
	;

ranking_over
	: OVER
		LPAREN
			partition_by_clause?
			order_by_clause
		RPAREN
	;
	
aggregate_windowed_functions
	:	(
			  (AVG | CHECKSUM_AGG | KMAX | KMIN | SUM | STDEV | STDEVP | VAR | VARP)
			  			LPAREN  (ALL | DISTINCT)? expression RPAREN					// No sub queries and no agg funcs allowed, semantics will check this
			| (COUNT	| COUNT_BIG)
						LPAREN ((ALL | DISTINCT)? expression | OPMUL) RPAREN			// No sub queries and no agg funcs allowed, semantics will check this
			| GROUPING
                (
					  LPAREN  column_name RPAREN									// OVER clause was removed from SQL Server 2003 online books example
                    | SETS function_args
                )

		)
		grouping_over?
	;
	
grouping_over
	: OVER					// This is an optional clause for some functions, semantics should catch use or not
		LPAREN
			partition_by_clause?
		RPAREN
	;
	
partition_by_clause
	: PARTITION BY partition_by_expression_list
	;
	
partition_by_expression_list
	: partition_by_expression (COMMA partition_by_expression)*
	;
	
partition_by_expression
	: expression
	;
		
order_by_clause
	: ORDER BY ob=order_by_expression_list
	;

order_by_expression_list
	: ob+=order_by_expression (COMMA ob+=order_by_expression)*
	;
	
order_by_expression
	: expression order_by_collate? (ASC | DESC)?
	;

order_by_collate
	: COLLATE func_keyw_id
	;
	
// Columns are {x.y.}z reference, the alias name, or the INTEGER
// position of the column in the SELECT list
//
column_name
	: keyw_id
	| INTEGER
	;

uniqueidentifier
	: SQ_LITERAL
	| HEXNUM
	;	

////////////////////////////////////////////////////////////////////////////////////////////
// Identifier handling...
//
// T-SQL allow lots of keywords (but not all) to be an identifier and relies on context
// to interpret the keyword as if it were an identifier, so we allow
// a standard ID token, and just about any of the keywords to be used as identifiers
// Note that the SQL Server 2005/2008 T-SQl Online reference says that keywords are reserved
// and must be enclosed in [ ] if it is a keyword. However, do not believe that claim.
//
keyw_id_for_func
    : keyw_id_orcc ((DOT)+ keyw_id_part)*
    ;

keyw_id_orcc
    : keyw_id_part
    | CAST LPAREN e=expression AS dt=data_type RPAREN
	| CONVERT LPAREN dt=data_type COMMA e=expression (COMMA i2=expression)? RPAREN
    ;

keyw_id
	: keyw_id_part ((DOT)+ keyw_id_part)*
    | ((DOT)+ keyw_id_part)+
	;

keyw_id_part
	: func_keyw_id | DQ_LITERAL 
	;
	
func_keyw_id
	: ID
    | BR_LITERAL
	| keywords
	;

// Literals that can be bracketed or single quoted
//
sq_br_literal
    : SQ_LITERAL
    | BR_LITERAL
    ;

// Literals that can be bracketed, double quoted or single quoted
//
dq_sq_br_literal
    : SQ_LITERAL
    | BR_LITERAL
    | DQ_LITERAL
    ;

// Literal that can be keyword enclosed or double quoted
//
dq_br_literal
    : DQ_LITERAL
    | BR_LITERAL
    ;

// Keywords allowed as IDs. This is an optional thing in TSQL, though why you woudl allow it
// is beyond me. It is a bit of a pain to parse, but it is allowed.
//
keywords	
	:ABSENT							
	|ACTIVE							
	|ACTIVATION
	|ACCENT_SENSITIVITY
//	|KADD
	|ADDRESS				
	|AFTER
	|ALGORITHM						
//	|ALL								
	|ALLOW_ROW_LOCKS
	|ALLOW_PAGE_LOCKS
	|ALLOW_SNAPSHOT_ISOLATION		
	|ALL_RESULTS						
//	|ALTER							
	|ANONYMOUS
	|ANSI_NULL_DEFAULT 				
	|ANSI_NULLS						
	|ANSI_PADDING					
	|ANSI_WARNINGS					
//	|ANY								
	|APPLICATION						
	|APPLY							
	|ARITHABORT
    |AT
//	|AS								
//	|ASC								
	|ASSEMBLY						
	|ASYMMETRIC						
	|AUTHENTICATION					
//	|AUTHORIZATION					
	|AUTH_REALM						
	|AUTO							
	|AUTO_CLOSE 						
	|AUTO_CREATE_STATISTICS 			
	|AUTO_UPDATE_STATISTICS_ASYNC	
	|AUTO_UPDATE_STATISTICS			
	|AVG								
	|BASE64							
	|BASIC							
	|BATCHES	
	|BATCHSIZE
//	|BEGIN
	|BEGIN_DIALOG					
//	|BETWEEN							
	|BINARY							
	|BINDING							
	|BLOCKSIZE
//	|BREAK
	|BROKER_INSTANCE
//	|BROWSE							
//	|BULK	
	|BUFFERCOUNT						
	|BULK_LOGGED						
//	|BY		
	|CASCADE						
	|CATALOG							
	|CATCH
	|CERTIFICATE						
	|CHANGE_TRACKING
	|CHARACTER_SET		
//	|CHECK		
	|CHECK_EXPIRATION	
	|CHECK_CONSTRAINTS
	|CHECK_POLICY
	|CHECKSUM_AGG					
	|CHECKSUM
    |CLEANUP
	|CLEAR							
	|CLEAR_PORT	
//	|CLUSTERED
	|CODEPAGE						
//	|COLLATE							
	|COLLECTION
	|COLUMNS
	|COMPRESSION						
//	|COMPUTE							
	|CONCAT							
//	|CONCAT_NULL_YIELDS_KNULL
//	|CONTAINS						
//	|CONTAINSTABLE
//	|CONTINUE
	|CONTINUE_AFTER_ERROR	
	|CONTENT				
	|CONTRACT
    |CONTROL
	|CONVERSATION
//	|CONSTRAINT
    |COOKIE
	|COPY					
	|COUNT_BIG						
	|COUNT							
	|COUNTER							
	|CREDENTIAL						
//	|CROSS							
	|CUBE							
	|CURSOR_CLOSE_ON_COMMIT			
	|CURSOR_DEFAULT
    |CURRENT
	//|DATABASE						
	|DATABASE_MIRRORING
    |DATABASE_SNAPSHOT
	|DATA		
	|DATAFILETYPE					
	|DATE_CORRELATION_OPTIMIZATION	
	|DB_CHAINING						
	|DECRYPTION						
//	|DEFAULT
	|DEFAULT_DATABASE
	|DEFAULT_LANGUAGE	
	|DEFAULT_LOGON_DOMAIN			
	|DEFAULT_SCHEMA
    |DEFINITION
//	|KDELETE
	|DENSE_RANK
	|DESCRIPTION
//	|DESC		
	|DIALOG					
	|DIFFERENTIAL
	|DIGEST							
	|DISABLE_BROKER
//	|DISABLE
	|DISABLED	
	|DISTRIBUTED					
	|DISK
//	|DISTINCT	
	|DOCUMENT					
//	|DROP							
	|ELEMENTS						
	|EMERGENCY						
//	|ENABLE
	|ENABLE_BROKER			    	
	|ENABLED							
	|ENCRYPTION				
//	|END
	|ENDPOINT		
	|EMPTY
    |ERROR
	|ERROR_BROKER_CONVERSATIONS		
	|ERRORFILE						
//	|ESCAPE							
//	|EXCEPT
    |EVENT
    |EVENTDATA
	|EXPAND
	|EXPIREDATE
	|EXPLICIT				
	|EXTERNAL		
	|EXTERNAL_ACCESS					
	|FAILOVER			    		
	|FAST							
	|FASTFIRSTROW					
//	|KFILE
	|FIELDTERMINATOR			
	|FILLFACTOR
	|FILEGROUP						
	|FILEGROWTH						
	|FILENAME		
	|FIRE_TRIGGERS	    		
	|FIRSTROW
	|FOREIGN						
	|FORCED			    			
	|FORCE							
	|FORCE_SERVICE_ALLOW_DATA_LOSS	
//	|FOR								
	|FORMATFILE						
	|FORMAT
//  |FREE
//	|FREETEXT						
//	|FREETEXTTABLE					
//	|FROM							
//	|FULL			    			
	|FULLTEXT						
//	|FUNCTION						
	|GB								
	|GLOBAL			    			
//	|GO								
//	|GROUP							
	|GROUPING			
	|HASHED			
//	|HASH
//	|HAVING							
	|HEADER_LIMIT					
//	|HOLDLOCK
    |HIGH
	|HTTP							
//	|IDENTITY
	|IGNORE_CONSTRAINTS				
	|IGNORE_DUP_KEY
	|IDENTITY_INSERT
	|IGNORE_TRIGGERS					
	|IMMEDIATE
    |IMPERSONATE
//	|INNER
	|INCREMENT	
	|INIT
//	|INSERT
	|INSTEAD						
	|INTEGRATED						
//	|INTERSECT						
//	|INTO
    |IO
    |JOB
//	|IS								
//	|JOIN							
//	|KAND							
	|KB								
	|KEEPDEFAULTS					
	|KEEPFIXED						
	|KEEPIDENTITY					
	|KEEP							
	|KEEPNULLS
	|KERBEROS	
	|KEYS					
//	|KEY		
	|KILOBYTES_PER_BATCH
//	|KINDEX							
//	|KIN								
//	|KNOT							
//	|KNULL							
//	|KOR								
	|LANGUAGE						
	|LASTROW
//    |LEFT
    |LEVEL
	|LIFETIME
//	|LIKE							
	|LISTENER_IP					
	|LOB_COMPACTION	
	|LOCAL			    			
	|LOGON
	|LOGIN							
	|LOGIN_TYPE						
	|LOG
    |LOW
	//|LOOP
	|MACHINE
	|MANUAL				
	|KMARK
	|MASTER							
	|MAXDOP							
	|MAXERRORS						
	|KMAX
	|MAXRECURSION		
	|MAXTRANSFERSIZE
	|MAX_QUEUE_READERS			
	|MAXSIZE							
	|MB								
	|MEDIADESCRIPTION
	|MEDIAPASSWORD
	|MEDIANAME
//	|MERGE
	|MESSAGE_FORWARDING				
	|MESSAGE_FORWARD_SIZE			
	|MESSAGE							
	|KMIN
	|MIRROR
	|MIRROR_ADDRESS							
	|MIXED							
	|MODIFY		
//	|MOVE
	|MULTI_USE						
	|MULTI_USER						
	|MUST_CHANGE
	|NAME							
	|NAMESPACE						
	|NEGOTIATE	
	|NEW_ACCOUNT					
	|NEW_BROKER	
	|NEW_PASSWORD					
	|NEWNAME			
//	|NEXT
	|NO	
	|NO_LOG
	|NOACTION
	|NO_CHECKSUM
//	|NOCHECK		
	|NOINIT
	|NOUNLOAD
	|NODE							
	|NOEXPAND						
	|NOFORMAT
	|NOLOCK							
	|NONE							
//	|NONCLUSTERED
	|NOREWIND
	|NOSKIP
	|NO_TRUNCATE
	|NO_WAIT
	|NORECOVERY							
	|NOWAIT							
	|NTILE
	|NTLM							
	|OBJECT
	|OF						
	|OFFLINE			    			
//	|OFF			
	|OLD_ACCOUNT
	|OLD_PASSWORD					
	|ONLINE
	|ONLY			    			
//	|ON								
//	|OPENDATASOURCE					
//	|OPENQUERY						
//	|OPENROWSET						
//	|OPENXML							
	|OPTIMIZE						
//	|OPTION							
//	|ORDER		
	|KOUT
//	|OUTPUT
//	|OUTER							
//	|OVER
    |OVERRIDE
	|OWNER
    |OWNERSHIP
	|PAD_INDEX					
	|PAGE_VERIFY						
	|PAGLOCK							
	|PARAMETERIZATION				
	|PARTITION						
	|PARTNER			    			
	|PASSWORD						
	|PATH
	|PAUSE							
//	|PERCENT							
	|PERMISSION_SET					
	|PERSISTED
//	|PIVOT							
//	|PLAN					
	|POPULATION		
	|PORTS							
	|PRIVATE		
	|PRIMARY		
	|PROCEDURE_NAME			
//	|PROCEDURE
    |PROFILE
    |KQUERY
	|QUEUE							
	|QUOTED_IDENTIFIER
	|RANGE		
	|RANK
	|RAW								
//	|RC4
	|READCOMMITTEDLOCK				
	|READCOMMITTED					
	|READ_COMMITTED_SNAPSHOT			
	|READ_ONLY						
	|READPAST						
	|READUNCOMMITTED					
	|READ_WRITE						
	|READ_WRITE_FILEGROUPS
	|REBUILD
	|RECOMPILE						
	|RECOVERY
    |RECONFIGURE
	|RECURSIVE_TRIGGERS			
//	|REFERENCES
	|REGENERATE	
	|RELATED_CONVERSATION
	|RELATED_CONVERSATION_GROUP
//	|REMOTE
	|REMOVE				
	|REORGANIZE			
	|REPEATABLEREAD					
	|REPEATABLE						
	|REPLICATION
	|REQUIRED			
	|RESTART			
	|RESTRICTED_USE			    	
	|RESTRICTED_USER					
	|RESUME		
	|RETAINDAYS
	|RETENTION
//	|RETURN
	|RETURNS
	|KREWIND	    			
//	|RIGHT							
	|ROBUST							
	|ROLE							
//	|ROLLBACK						
	|ROLLUP							
	|ROOT							
	|ROUTE		
//	|ROWGUIDCOL
    |ROWCOUNT
	|ROWLOCK		
	|ROWTERMINATOR					
    |ROW_NUMBER
	|ROWSETS_ONLY					
	|ROWS_PER_BATCH					
	|ROWS							
	|SAFE							
	|SAFETY		
	|SCHEME	    			
//	|SCHEMA		
	|SCHEMABINDING					
	|SECONDS							
	|SECRET							
//	|SELECT		
	|SELF					
	|SERIALIZABLE
	|SERVER
	|SERVICE_BROKER					
	|SERVICE			
	|SERVICE_NAME				
	|SESSIONS						
	|SESSION_TIMEOUT					
//	|SET
	|SIGNATURE						
	|SIMPLE			    			
	|SINGLE_BLOB						
	|SINGLE_CLOB						
	|SINGLE_NCLOB					
	|SINGLE_USER						
	|SINGLE_USE						
	|SITE							
	|SIZE	
	|KSKIP
    |SHOWPLAN
	|SOAP			
	|SORT_IN_TEMPDB
    |SOURCE
	|SPLIT
//	|SOME							
	|SQL								
	|SSL_PORT						
	|SSL								
	|STANDARD
	|STANDBY						
	|START
    |START_DATE
	|STARTED							
	|STATE	
	|STATS
	|KSTATUS
    |STATUSONLY
	|STATISTICS_NORECOMPUTE				
	|STDEVP							
	|STDEV	
	|STOP
	|STOP_ON_ERROR						
	|STOPPED
    |SUBJECT
    |SUBSCRIPTION
	|SUM								
	|SUPPORTED						
	|SUSPEND			    
	|SWITCH			
	|SYMMETRIC
	|SYS
	|SYSTEM							
//	|TABLESAMPLE						
//	|TABLE							
	|TABLOCK							
	|TABLOCKX						
	|TAPE
    |TARGET
    |TAKE
	|TB								
	|TCP								
	|TIES
    
	|TIMER						
	|TIMEOUT			    			
//	|TOP								
	|TORN_PAGE_DETECTION				
///	|TO		
	|TRANSACTION			
	|TRANSFER			
//	|TRIGGER	
	|TRUNCATE_ONLY						
	|TRUSTWORTHY						
	|TRY
    |TSQL
	|TYPE							
	|UNCHECKED	
//	|UNIQUE
//	|UNION							
	|UNLIMITED
	|UNLOAD	
	|UNLOCK									
//	|UNPIVOT							
	|UNSAFE							
	|UPDLOCK			
	|USED				
	|USER							
//	|USE			
	|VALID_XML
	|VALIDATION
	|VALUE
	|VALUES					
	|VARP							
	|VAR				
	|VARYING				
	|VIEWS							
	|VIEW		
	|VIEW_METADATA					
	|VISIBILITY						
	|WEBMETHOD						
	|WELL_FORMED_XML
//	|WHERE							
	|WINDOWS							
//	|WITH							
	|WITNESS			    			
	|WSDL							
	|XLOCK							
	|XMLDATA							
	|XMLSCHEMA						
	|XML								
	|XSINIL
    | FILELISTONLY
    | HEADERONLY
    | LABELONLY
    | REWINDONLY
    | VERIFYONLY
    | CHECKALLOC
    | CHECKCATALOG
    | CHECK_CONSTRAINTS
    | CHECKDB
    | CHECKFILEGROUP
    | CHECKIDENT
    | CHECKTABLE
    | CLEANTABLE
    | CONCURRENCYVIOLATION
    | DBREINDEX
    | DBREPAIR
    | DROPCLEANBUFFERS
    | FREEPROCCACHE
    | FREESESSIONCACHE
    | FREESYSTEMCACHE
    | HELP
    | INDEXDEFRAG
    | INPUTBUFFER
    | OPENTRAN
    | OUTPUTBUFFER
    | PINTABLE
    | PROCCACHE
    | SHOW_STATISTICS
    | SHOWCONTIG
    | SHRINKDATABASE
    | SHRINKFILE
    | SQLPERF
    | TRACEOFF
    | TRACEON
    | TRACESTATUS
    | UNPINTABLE
    | UPDATEUSAGE
    | USEROPTIONS

    | FIRST
    | LAST
    | RELATIVE
    | ABSOLUTE
    | NEXT
    | PRIOR
	;

	
