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
 * This parser covers the syntax for DDL statements that affect permissions, such as GRANT and REVOKE
 */

parser grammar tsqlpermissions;

///////////////////////////////////////////////////////////
// DDL statements that affect permissions
//
permissions_ddl
    : grant_statement
    | revoke_statement
    | deny_statement
    ;
// End: permissions_ddl
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// GRANT permissions
//
grant_statement
    : GRANT
        (
              ALL PRIVILEDGES?
            | permission_set
              permission_on?
              permission_to
              (WITH GRANT OPTION)?
              (AS keyw_id)?
        )

        SEMI?
    ;
// End: GRANT
///////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////
// REVOKE permissions
//
revoke_statement
    : REVOKE

        (GRANT OPTION FOR)?
        permission_body
        
        SEMI?
    ;

// End:
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// DENY permissions
//
deny_statement
    : DENY

        permission_body
        SEMI?
    ;

// End: DENY
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// Common permission syntax
//

permission_body
    : ALL PRIVILEDGES?
    | permission_set
      permission_on?
      permission_to
      CASCADE?
      (AS keyw_id)?
    ;

permission_on
    : ON
        permission_object (COLON COLON keyw_id)?
    ;

permission_object
    : (ASYMMETRIC|SYMMETRIC) KEY
    | USER
    | APPLICATION? ROLE
    | FULLTEXT CATALOG
    | OBJECT COLON COLON keyw_id (LPAREN keyw_id_list RPAREN)
    | SCHEMA
    | MESSAGE TYPE
    | REMOTE SERVICE BINDING
    | SYS DOT keyw_id
    | XML SCHEMA COLLECTION
    | keyw_id
    ;

permission_to
    : (TO|FROM) keyw_id_list
    ;

permission_set
    : psl+=permission_set_element (COMMA psl+=permission_set_element)*


    ;

permission_set_element
    : permission_name (LPAREN keyw_id_list RPAREN)?


    ;

permission_name
    : permission_spec

    ;

permission_spec
    : ADMINISTER BULK OPERATIONS
    | ALTER (
                ANY (
                          APPLICATION ROLE 
                        | ASSEMBLY
                        | (ASYMMETRIC|SYMMETRIC) KEY
                        | CERTIFICATE
                        | CONNECTION
                        | CONTRACT
                        | CREDENTIAL
                        | DATABASE (DDL TRIGGER | EVENT NOTIFICATION)?
                        | DATASPACE
                        | ENDPOINT
                        | EVENT NOTIFICATION
                        | FULLTEXT CATALOG
                        | LINKED SERVER
                        | LOGIN
                        | MESSAGE TYPE
                        | REMOTE SERVICE BINDING
                        | ROLE
                        | ROUTE
                        | SCHEMA
                        | SERVICE
                        | USER

                    )
                | RESOURCES
                | SERVER STATE
                | SETTINGS
                | TRACE
            )?
    | AUTHENTICATE SERVER?
    | BACKUP (DATABASE | LOG)
    | CHECKPOINT
    | CONNECT (REPLICATION |SERVER | SQL)?
    | CONTROL SERVER?
    | CREATE
            (
                 (
                     ANY
                     (
                         DATABASE
                     )
                 )
                |  AGGREGATE
                | ASSEMBLY
                | (ASYMMETRIC|SYMMETRIC) KEY
                | CERTIFICATE
                | CONTRACT
                | DATABASE (DDL EVENT NOTIFICATION)?
                | DDL EVENT NOTIFICATION
                | DEFAULT
                | ENDPOINT
                | FULLTEXT CATALOG
                | FUNCTION
                | MESSAGE TYPE
                | PROCEDURE
                | QUEUE
                | REMOTE SERVICE BINDING
                | ROLE
                | ROUTE
                | RULE
                | SCHEMA
                | SERVICE
                | SYNONYM
                | TABLE
                | TRACE EVENT NOTIFICATION
                | VIEW
                | XML SCHEMA COLLECTION
            )
    | KDELETE
    | EXECUTE
    | EXTERNAL ACCESS ASSEMBLY
    | IMPERSONATE
    | INSERT
    | RECEIVE
    | REFERENCES
    | SELECT
    | SEND
    | SHOWPLAN
    | SHUTDOWN
    | SUBSCRIBE KQUERY NOTIFICATIONS
    | TAKE OWNERSHIP
    | UNSAFE ASSEMBLY
    | UPDATE
    | VIEW  (
                  ANY
                  (
                        DATABASE
                      | DEFINITION
                  )
                | DATABASE STATE
                | DEFINITION
                | SERVER STATE
            )
    ;

// End:
///////////////////////////////////////////////////////////
