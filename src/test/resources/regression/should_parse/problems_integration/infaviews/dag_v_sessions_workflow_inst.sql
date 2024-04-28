--Warnings
--ALTER VIEW [dbo].[DAG_V_SESSIONS_WORKFLOW_INST] ( FOLDER_ID, 
--WORKFLOW_ID, INSTANCE_ID, INSTANCE_NAME, SESSION_ID, 
--SESSION_NAME, IS_VALID, IS_ENABLED, LAST_SAVED, 
--DESCRIPTION ) AS 
SELECT DISTINCT convert(varchar, g.subject_id) AS folder_id,		   -- 04/13/2003
	   			convert (varchar, a.workflow_id),
/* This view returns all session instances within a workflow/ worklet */
	   			convert (varchar, a.instance_id),
				convert (varchar, a.instance_name),
				convert (varchar,g.task_id) AS session_id,
				convert(varchar,g.task_name) AS session_name, 
convert (varchar, case a.is_valid
when 0 then  'NO'
when 1 then 'YES'
end) AS is_valid,

convert (varchar, case a.is_enabled
when 0 then  'NO'
when 1 then 'YES'
end) AS is_enabled,
				convert (datetime, g.last_saved) AS last_saved,
				convert (varchar, a.comments) AS description
FROM opb_task_inst a, opb_task g
WHERE (a.task_id = g.task_id) AND
      (a.task_type = 68) AND
      g.is_visible = 1 AND   
	  (a.version_number =
                      (SELECT MAX (b.version_number)
                         FROM opb_task_inst b
                        WHERE b.workflow_id = a.workflow_id
                          AND b.instance_id = a.instance_id))