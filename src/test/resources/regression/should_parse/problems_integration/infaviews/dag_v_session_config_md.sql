--Warnings
--ALTER VIEW [dbo].[DAG_V_SESSION_CONFIG_MD] ( FOLDER_ID, 
--SESSION_ID, SESSION_NAME, CONFIG_ID, CONFIG_NAME, 
--CONSTRAINT_BASED_LOAD_ORDERING, CACHE_LOOKUP_FUNCTION, DEFAULT_BUFFER_BLOCK_SIZE, LINE_SEQ_BUFFER_LENGTH, 
--SAVE_SESSION_LOG_BY, SAVE_SESS_LOG_FOR_THESE_RUNS, STOP_ON_ERRORS, OVERRIDE_TRACING, 
--ON_STORED_PROCEDURE_ERROR, ON_PRE_SESS_CMD_TASK_ERR, ON_PRE_POST_SQL_ERR ) AS 
SELECT a.subject_id AS folder_id,
/* This view returns metadata for the session config object */
       a.task_id AS session_id,
       a.task_name AS session_name,
	   v.config_id,
	   v.config_name,
	   case convert(varchar,e3.constraint_based_load_ordering) when 0 then 'NO' when 1 then 'YES' end AS constraint_based_load_ordering,
	   case convert(varchar,e4.cache_lookup_function) when 0 then 'NO' when 1 then 'YES' end  as cache_lookup_function,
       e5.default_buffer_block_size,
       e6.line_seq_buffer_length,
       case convert(varchar,e102.save_session_log_by) when 0 then 'Session Runs' when 1 then 'Session Timestamp' end AS save_session_log_by,
       e103.save_sess_log_for_these_runs,
       e202.stop_on_errors,
       case  convert(varchar,e204.override_tracing) when 0 then 'None' when 1 then 'Terse' when 2 then 'Normal' when 3 then 'Verbose Initiliazation' when 4 then 'Verbose Data' end AS override_tracing,
       case convert(varchar,e205.on_stored_procedure_error) when 0 then 'Stop' when 1 then 'Continue' end AS on_stored_procedure_error,
       case convert(varchar,e206.on_pre_sess_cmd_task_err) when 0 then 'Stop'when 1 then 'Continue' end AS on_pre_sess_cmd_task_err,
       case convert(varchar,e207.on_pre_post_sql_err) when 0 then 'Stop' when 1 then 'Continue' end AS on_pre_post_sql_err
FROM   opb_component u, opb_session_config v, opb_task a left join
     (SELECT b3.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c3.attr_value, d3.attr_value) AS constraint_based_load_ordering
        FROM opb_task b3 left join  opb_cfg_attr c3 on b3.task_id = c3.session_id and c3.workflow_id = 0 and c3.session_inst_id = 0 and  c3.attr_id  = 3,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 3) d3
        WHERE (b3.task_type = 68)) e3 on a.task_id = e3.task_id
left join 
     (SELECT b4.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c4.attr_value, d4.attr_value) AS cache_lookup_function
        FROM opb_task b4 left join  opb_cfg_attr c4  on  b4.task_id = c4.session_id and c4.workflow_id = 0 and c4.session_inst_id = 0 and  c4.attr_id  = 4,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 4) d4
        WHERE (b4.task_type = 68)) e4 on a.task_id = e4.task_id
left join
     (SELECT b5.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c5.attr_value, d5.attr_value) AS default_buffer_block_size
        FROM opb_task b5 left join opb_cfg_attr c5 on b5.task_id = c5.session_id and c5.workflow_id = 0 and c5.session_inst_id = 0 and  c5.attr_id  = 5,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 5) d5
        WHERE (b5.task_type = 68) ) e5 on a.task_id = e5.task_id
left join
     (SELECT b6.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c6.attr_value, d6.attr_value) AS line_seq_buffer_length
        FROM opb_task b6 left join opb_cfg_attr c6 on b6.task_id = c6.session_id and c6.workflow_id = 0 and c6.session_inst_id = 0 and  c6.attr_id  = 6,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 6) d6
        WHERE  (b6.task_type = 68)) e6 on a.task_id = e6.task_id 
left join
     (SELECT b102.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c102.attr_value, d102.attr_value) AS save_session_log_by
        FROM opb_task b102 left join opb_cfg_attr c102 on b102.task_id = c102.session_id and c102.workflow_id = 0 and c102.session_inst_id = 0 and  c102.attr_id  = 102,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 102) d102
        WHERE (b102.task_type = 68)) e102 on  a.task_id = e102.task_id
left join
     (SELECT b103.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c103.attr_value, d103.attr_value) AS save_sess_log_for_these_runs
        FROM opb_task b103 left join  opb_cfg_attr c103 on b103.task_id = c103.session_id and c103.workflow_id = 0 and c103.session_inst_id = 0 and  c103.attr_id  = 103,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 103) d103
        WHERE 
              (b103.task_type = 68)) e103 on a.task_id = e103.task_id 
left join
     (SELECT b202.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c202.attr_value, d202.attr_value) AS stop_on_errors
        FROM opb_task b202 left join opb_cfg_attr c202 on b202.task_id = c202.session_id and c202.workflow_id = 0 and c202.session_inst_id = 0 and  c202.attr_id  = 202,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 202) d202
        WHERE (b202.task_type = 68) ) e202 on   a.task_id = e202.task_id 
left join
     (SELECT b204.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c204.attr_value, d204.attr_value) AS override_tracing
        FROM opb_task b204 left join opb_cfg_attr c204 on b204.task_id = c204.session_id and c204.workflow_id = 0 and c204.session_inst_id = 0 and  c204.attr_id  = 204,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 204) d204
        WHERE (b204.task_type = 68) 
              ) e204 on a.task_id = e204.task_id 
left join
     (SELECT b205.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c205.attr_value, d205.attr_value) AS on_stored_procedure_error
        FROM opb_task b205 left join  opb_cfg_attr c205 on b205.task_id = c205.session_id  and c205.workflow_id = 0 and c205.session_inst_id = 0 and  c205.attr_id  = 205,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 205) d205
        WHERE 
              (b205.task_type = 68)) e205 on a.task_id = e205.task_id
left join
     (SELECT b206.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c206.attr_value, d206.attr_value) AS on_pre_sess_cmd_task_err
        FROM opb_task b206 left join  opb_cfg_attr c206 on  b206.task_id = c206.session_id and c206.workflow_id = 0 and c206.session_inst_id = 0 and  c206.attr_id  = 206,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 206) d206
        WHERE (b206.task_type = 68) ) e206 on   a.task_id = e206.task_id 
left join
     (SELECT b207.task_id,
	 		 -- Return the default value for config, if no user defined value
             isnull(c207.attr_value, d207.attr_value) AS on_pre_post_sql_err
        FROM opb_task b207 left join  opb_cfg_attr c207 on  b207.task_id = c207.session_id and c207.workflow_id = 0 and c207.session_inst_id = 0 and  c207.attr_id  = 207,
		     (SELECT attr_value		-- get the default value for this attribute of session config
			  FROM opb_mmd_cfg_attr
			  WHERE object_type_id = 72 AND
					attr_id = 207) d207
        WHERE (b207.task_type = 68)) e207 on a.task_id = e207.task_id
WHERE (a.task_id = u.task_id)  AND  -- No outer join needed
	  (u.workflow_id = 0) AND
	  (u.task_inst_id = 0) AND
 	  (u.object_type = 72) AND  -- SessionConfig Object Type
	  (u.ref_obj_id = v.config_id) AND
      (a.task_type = 68) AND
      a.is_visible = 1 AND
      v.is_visible = 1
