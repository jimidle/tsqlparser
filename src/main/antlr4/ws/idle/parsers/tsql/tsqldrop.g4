// MIT License
//
// Copyright (c) 2004-2024 Jim Idle
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/**
 * This grammar contains all the syntax for parsing DROP statements
 */
parser grammar tsqldrop;

///////////////////////////////////////////////////////////
// All forms of the DROP statement
//
drop_statement
    : DROP

        (
              dropCommon        // Things that are the same syntax with a different keyword
            | dropCommonList    // Things that are list of things to drop but otherwise the same
            | dropAssembly
            | dropEvent
            | dropFullText
            | dropIndex
            | dropMasterKey
            | dropPartition
            | dropSignature
            | dropTrigger
        )
    ;
// End: DROP statement
///////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////
// Common form of DROP statement DROP KEYWORD name
//
dropCommon
    : dropElements keyw_id

        SEMI?
    ;

dropElements
    : AGGREGATE
    | APPLICATION ROLE
    | (SYMMETRIC | ASYMMETRIC) KEY
    | CERTIFICATE
    | CONTRACT
    | CREDENTIAL
    | ENDPOINT
    | LOGIN
    | MESSAGE TYPE
    | QUEUE
    | REMOTE SERVICE BINDING
    | ROLE
    | ROUTE
    | SCHEMA
    | SERVICE
    | SYNONYM
    | TYPE
    | USER
    | XML SCHEMA COLLECTION
;

// End: Common DROP format
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// Common form of dropping a list of things
//
dropCommonList
    : dropListElements keyw_id_list

        SEMI?
    ;

dropListElements
    : DATABASE
    | DEFAULT
    | FUNCTION
    | PROCEDURE
    | RULE
    | STATISTICS
    | TABLE
    | VIEW
    ;
// End:
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
//
//
dropAssembly
    : ASSEMBLY keyw_id_list

        (WITH NO DEPENDENTS)?

        SEMI?
    ;

// End:
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DROP EVENT
//
dropEvent
    : EVENT NOTIFICATION keyw_id_list

        dropEventOn

        SEMI?
    ;

dropEventOn
    : ON
        (
              SERVER
            | DATABASE
            | QUEUE keyw_id
        )
    ;
    
// End:
///////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////
// DROP FULLTEXT
//
dropFullText
    : FULLTEXT (CATALOG | KINDEX ON) keyw_id

        SEMI?
    ;

// End: DROP FULLTEXT
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DROP INDEX
//
dropIndex
    : KINDEX

        (COMMA? dropIndexOnWith)+

        SEMI?
    ;

dropIndexOnWith
    : keyw_id (ON keyw_id column_list? dropIndexWith? )?
    ;

dropIndexWith
    : WITH
        LPAREN (dropClusteredIndexOption COMMA?)+ RPAREN
    ;

dropClusteredIndexOption
    : MAXDOP OPEQ INTEGER
    | ONLINE OPEQ (ON|OFF)
    | MOVE TO
        (
              keyw_id (LPAREN keyw_id RPAREN)?
        )
    | FILESTREAM_ON (keyw_id | DEFAULT)
    ;
// End: DROP INDEX
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DROP MASTER KEY
//
dropMasterKey
    : MASTER KEY
    ;
// End: DROP MASTER KEY
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DROP PARTITION
//
dropPartition
    : PARTITION (FUNCTION|SCHEME) keyw_id

        SEMI?
    ;
// End:
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DROP SIGNATURE
//
dropSignature
    : COUNTER? SIGNATURE FROM keyw_id
        dropSignatureCrypto

        SEMI?
    ;

dropSignatureCrypto
    : BY cryptoList
    ;

cryptoList
    : c+=crypto (COMMA c+=crypto)*


    ;

crypto
    : CERTIFICATE keyw_id
    | ASYMMETRIC KEY keyw_id
    ;

// End: DROP SIGNATURE
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DROP TRIGGER
//
dropTrigger
    : TRIGGER keyw_id_list

        dropTriggerOn?
    ;

dropTriggerOn
    : ON

        (
              DATABASE
            | ALL SERVER
        )
    ;
// End:
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
//
//

// End:
///////////////////////////////////////////////////////////


