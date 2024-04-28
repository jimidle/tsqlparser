	SELECT
			 d.m_actor_c_name AS document_server_name,
			 a.batch_id as job_id,
			 b.m_doc_c_name AS document_name,
			 c.m_actor_c_name AS submitted_by,
			 CONVERT(DATETIME, '15-DEC-1970') + (a.submit_datetime / CONVERT(FLOAT, (60 * 60 * 24))) AS submit_date,
			 CONVERT(DATETIME, '15-DEC-1970') + (a.begin_time / CONVERT(FLOAT, (60 * 60 * 24))) AS begin_time,
			 CONVERT(DATETIME, '15-DEC-1970') + (a.begin_date / CONVERT(FLOAT, (60 * 60 * 24))) AS begin_date,
			 CONVERT(DATETIME, '15-DEC-1970') + (a.start_datetime / CONVERT(FLOAT, (60 * 60 * 24))) AS start_datetime,
			 CONVERT(DATETIME, '15-DEC-1970') + (a.start_datetime / CONVERT(FLOAT, (60 * 60 * 24))) AS end_datetime,
			 
			CASE a.priority 
				WHEN 1 THEN 'Low' 
				WHEN 2 THEN 'Normal' 
				WHEN 3 THEN 'High' 
			END AS priority,
			 NULL AS frequency,
			 NULL AS run_schedule,
			 
			CASE a.job_status 
				WHEN 0 THEN 'Success' 
				WHEN 1 THEN 'Failure' 
				WHEN 2 THEN 'Waiting' 
				WHEN 3 THEN 'Running' 
				WHEN 1001 THEN 'Retrying(1)' 
				WHEN 1002 THEN 'Retrying(2)' 
				WHEN 1003 THEN 'Retrying(3)' 
				WHEN 1004 THEN 'Retrying(4)' 
				WHEN 1005 THEN 'Retrying(5)' 
				WHEN 1006 THEN 'Expired' 
			END AS status,
			 a.error_text,
			 NULL AS job_commands,
			 a.job_desc AS short_description,
			 a.version,
			 a.ip_address,
			 NULL AS in_name_of
	FROM  ds_pending_job a  LEFT OUTER JOIN  obj_m_documents b  ON  a.document_id  = b.m_doc_n_id   LEFT OUTER JOIN  obj_m_actor c  ON  a.user_submit_id  = c.m_actor_n_id   LEFT OUTER JOIN  obj_m_actor d  ON  a.docserver_id  = d.m_actor_n_id  
	
	
