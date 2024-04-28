--Warnings
--ALTER VIEW [dbo].[DAG_V_SESSION_INST_MD] ( WORKFLOW_ID, 
--INSTANCE_ID, INSTANCE_NAME, SESSION_ID, SESSION_NAME, 
--IS_REUSABLE, IS_VALID, IS_ENABLED, TASK_FAILS, TASK_NO_RUN, AND_OR, LAST_SAVED, 
--DESCRIPTION, SESSION_LOG_FILE_NAME, SESSION_LOG_DIR, PARAM_FILE_NAME, 
--ENABLE_TEST_LOAD, NUM_OF_ROWS_TO_TEST, SRC_CONN_VALUE, TARGET_CONN_VALUE, 
--TREAT_SRC_ROWS_AS, COMMIT_TYPE, COMMIT_INTERVAL, DTM_BUFFER_SIZE, 
--COLLECT_PERF_DATA, INCREMENTAL_AGGR, REINITILIALIZE_AGGR_CACHE, ENABLE_HIGH_PRECISION, 
--RETRY_ON_DEADLOCK ) AS 
SELECT DISTINCT a.workflow_id,
	   			a.instance_id,
/* This view returns all session instances within a workflow/ worklet */
				a.instance_name,
				g.task_id AS session_id,
				g.task_name AS session_name,
				case g.is_reusable
                                     when 0 then 'NO'
                                     when 1 then 'YES' end AS is_reusable,
				case a.is_valid
                                     when 0 then 'NO'
                                     when 1 then 'YES' end AS is_valid,
				case a.is_enabled
                                     when 0 then 'NO'
                                     when 1 then 'YES' end AS is_enabled,
				case a.BIT_OPTIONS when 1 then 'NO' when 2 then 'NO' when 33 then 'NO' when 34 then 'NO' else 'YES' end as task_fails,
				case a.BIT_OPTIONS when 1 then 'NO' when 17 then 'NO' when 2 then 'NO' when 18 then 'NO' else 'YES' end as task_no_run,
				case a.BIT_OPTIONS when 1 then 'AND' when 17 then 'AND' when 33 then 'AND' when 49 then 'AND' else 'OR'end  as and_or,
				convert(datetime,g.last_saved) AS last_saved,
				convert(varchar,a.comments)AS description,
				isnull(i1.session_log_file_name, b1.session_log_file_name) as session_log_file_name,
				isnull(i2.session_log_dir, b2.session_log_dir) as session_log_dir,
				isnull(i3.param_file_name, b3.param_file_name) as param_file_name,
				isnull(i4.enable_test_load, b4.enable_test_load) as enable_test_load,
				isnull(i5.num_of_rows_to_test, b5.num_of_rows_to_test) as num_of_rows_to_test,
				isnull(i6.src_conn_value, b6.src_conn_value) as src_conn_value,
				isnull(i7.target_conn_value, b7.target_conn_value) as target_conn_value,
				isnull(i8.treat_src_rows_as, b8.treat_src_rows_as) as treat_src_rows_as,
				isnull(i9.commit_type, b9.commit_type) as commit_type,
				isnull(i10.commit_interval, b10.commit_interval) as commit_interval,
				isnull(i11.dtm_buffer_size, b11.dtm_buffer_size) as dtm_buffer_size,
				isnull(i12.collect_perf_data, b12.collect_perf_data) as collect_perf_data,
				isnull(i13.incremental_aggr, b13.incremental_aggr) as incremental_aggr,
				isnull(i14.reinitilialize_aggr_cache, b14.reinitilialize_aggr_cache) as reinitilialize_aggr_cache,
				isnull(i15.enable_high_precision, b15.enable_high_precision) as enable_high_precision,
				isnull(i16.retry_on_deadlock, b16.retry_on_deadlock) as retry_on_deadlock
FROM opb_task g,opb_task_inst a left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS session_log_file_name
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 2) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b1 on 
      a.task_id = b1.task_id
left join
	 (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,convert(varchar,i.attr_value) AS session_log_file_name
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 2) AND
			(i.line_no = 1)) i1 on (a.workflow_id = i1.workflow_id) AND (a.instance_id = i1.instance_id) 
left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS session_log_dir
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 3) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b2 on (a.task_id = b2.task_id) 
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,convert(varchar,i.attr_value) AS session_log_dir
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 3) AND
			(i.line_no = 1)) i2 on (a.workflow_id = i2.workflow_id) AND (a.instance_id = i2.instance_id)
left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS param_file_name
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 4) AND
			 (c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b3 on (a.task_id = b3.task_id) 
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,convert(varchar,i.attr_value) AS param_file_name
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 4) AND
			(i.line_no = 1)) i3 on 	  (a.workflow_id = i3.workflow_id) AND (a.instance_id = i3.instance_id) 
left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '1' then 'YES'
                                        when '0' then 'NO' end AS enable_test_load
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 5) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b4 on 	  (a.task_id = b4.task_id) 
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,case convert(varchar,i.attr_value)
                                                                           when '1' then 'YES'
                                                                           when '0' then 'NO' end AS enable_test_load
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 5) AND
			(i.line_no = 1)) i4 on 	  (a.workflow_id = i4.workflow_id) AND (a.instance_id = i4.instance_id)
left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS num_of_rows_to_test
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 6) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b5 on (a.task_id = b5.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,convert(varchar,i.attr_value) AS num_of_rows_to_test
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 6) AND
			(i.line_no = 1)) i5 on (a.workflow_id = i5.workflow_id) AND (a.instance_id = i5.instance_id)
left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS src_conn_value
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 7) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b6 on (a.task_id = b6.task_id) 
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,convert(varchar,i.attr_value) AS src_conn_value
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 7) AND
			(i.line_no = 1)) i6 on 	  (a.workflow_id = i6.workflow_id) AND (a.instance_id = i6.instance_id) 
left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS target_conn_value
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 8) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b7 on   (a.task_id = b7.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id,convert(varchar,i.attr_value) AS target_conn_value
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 8) AND
			(i.line_no = 1)) i7 on  (a.workflow_id = i7.workflow_id) AND (a.instance_id = i7.instance_id)
left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'Insert'
                                        when '1' then 'Delete'
                                        when '2' then 'Update'
                                        when '3' then 'Data Driven' end  AS treat_src_rows_as
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 9) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b8 on       (a.task_id = b8.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'Insert'
                                                                            when '1' then 'Delete'
                                                                            when '2' then 'Update'
                                                                            when '3' then 'Data Driven'end AS treat_src_rows_as
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 9) AND
			(i.line_no = 1)) i8 on   (a.workflow_id = i8.workflow_id) AND (a.instance_id = i8.instance_id)
left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'Target'
                                        when '1' then 'Source' end AS commit_type
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 13) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b9 on      (a.task_id = b9.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'Target'
                                                                            when '1' then 'Source' end AS commit_type
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 13) AND
			(i.line_no = 1)) i9 on   (a.workflow_id = i9.workflow_id) AND (a.instance_id = i9.instance_id)
left join 
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS commit_interval
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 14) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b10 on       (a.task_id = b10.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, convert(varchar,i.attr_value) AS commit_interval
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 14) AND
			(i.line_no = 1)) i10 on  (a.workflow_id = i10.workflow_id) AND (a.instance_id = i10.instance_id)
left join
     (SELECT c.task_id as task_id, convert(varchar,c.attr_value) AS dtm_buffer_size
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 101) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b11 on      (a.task_id = b11.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, convert(varchar,i.attr_value) AS dtm_buffer_size
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 101) AND
			(i.line_no = 1)) i11 on  (a.workflow_id = i11.workflow_id) AND (a.instance_id = i11.instance_id)

left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'NO'
                                        when '1' then 'YES' end AS collect_perf_data
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 102) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b12 on       (a.task_id = b12.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'NO'
                                                                            when '1' then 'YES' end AS collect_perf_data
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 102) AND
			(i.line_no = 1)) i12 on   (a.workflow_id = i12.workflow_id) AND (a.instance_id = i12.instance_id)
left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'NO'
                                        when '1' then 'YES' end AS incremental_aggr
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 103) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b13 on       (a.task_id = b13.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'NO'
                                                                            when '1' then 'YES' end AS incremental_aggr
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 103) AND
			(i.line_no = 1)) i13 on   (a.workflow_id = i13.workflow_id) AND (a.instance_id = i13.instance_id)
left join 
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'NO'
                                        when '1' then 'YES' end AS reinitilialize_aggr_cache
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 104) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b14 on (a.task_id = b14.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'NO'
                                                                            when '1' then 'YES' end AS reinitilialize_aggr_cache
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 104) AND
			(i.line_no = 1)) i14 on   (a.workflow_id = i14.workflow_id) AND (a.instance_id = i14.instance_id)
left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'NO'
                                        when '1' then 'YES' end AS enable_high_precision
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 105) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b15 on  (a.task_id = b15.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'NO'
                                                                            when '1' then 'YES' end AS enable_high_precision
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 105) AND
			(i.line_no = 1)) i15 on   (a.workflow_id = i15.workflow_id) AND (a.instance_id = i15.instance_id)
left join
     (SELECT c.task_id as task_id, case convert(varchar,c.attr_value)
                                        when '0' then 'NO'
                                        when '1' then 'YES' end AS retry_on_deadlock
	  FROM opb_task b, opb_task_attr c
	  WHERE (b.task_id = c.task_id) AND
			(b.task_type = 68) AND
			(c.workflow_id = 0) AND
			(c.instance_id = 0) AND
			(c.attr_id = 106) AND
			(c.line_no = 1) and 
			b.is_visible = 1 and
			b.version_number=c.version_number) b16 on  (a.task_id = b16.task_id)
left join
    (SELECT i.workflow_id as workflow_id,i.instance_id as instance_id, case convert(varchar,i.attr_value)
                                                                            when '0' then 'NO'
                                                                            when '1' then 'YES' end AS retry_on_deadlock
 	  FROM opb_task_inst h, opb_task_attr i
 	  WHERE (h.workflow_id = i.workflow_id) AND
 	  		(h.instance_id = i.instance_id) AND
 			(i.task_type = 68) AND
 			(i.attr_id = 106) AND
			(i.line_no = 1)) i16 on   (a.workflow_id = i16.workflow_id) AND (a.instance_id = i16.instance_id)
WHERE 	  (a.task_id = g.task_id) AND
      (a.task_type = 68) AND
      g.is_visible = 1 AND
	  (a.VERSION_NUMBER = (select max(b.version_number) from opb_task_inst b where b.WORKFLOW_ID = a.WORKFLOW_ID and b.INSTANCE_ID = a.INSTANCE_ID))

