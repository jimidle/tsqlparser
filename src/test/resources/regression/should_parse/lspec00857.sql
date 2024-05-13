RECEIVE * FROM ExpenseQueue ;
RECEIVE conversation_handle, message_type_name, message_body
FROM ExpenseQueue ;
RECEIVE TOP (1) * FROM ExpenseQueue ;
DECLARE @conversation_handle UNIQUEIDENTIFIER ;

SET @conversation_handle = @jim;

RECEIVE *
FROM ExpenseQueue
WHERE conversation_handle = @conversation_handle ;
DECLARE @conversation_group_id UNIQUEIDENTIFIER ;

SET @conversation_group_id = @jim;

RECEIVE *
FROM ExpenseQueue
WHERE conversation_group_id = @conversation_group_id ;
DECLARE @conversation_group_id UNIQUEIDENTIFIER ;

DECLARE @procTable TABLE(
	     service_instance_id UNIQUEIDENTIFIER,
	     handle UNIQUEIDENTIFIER,
	     message_sequence_number BIGINT,
	     service_name NVARCHAR(512),
	     service_contract_name NVARCHAR(256),
	     message_type_name NVARCHAR(256),
	     validation NCHAR,
	     message_body VARBINARY(MAX)) ;

SET @conversation_group_id = @jim;

RECEIVE TOP (1)
    conversation_group_id,
    conversation_handle,
    message_sequence_number,
    service_name,
    service_contract_name,
    message_type_name,
    validation,
    message_body
FROM ExpenseQueue
INTO @procTable
WHERE conversation_group_id = @conversation_group_id ;

