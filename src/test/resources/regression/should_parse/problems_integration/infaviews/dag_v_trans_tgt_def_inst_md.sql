--Warnings
--ALTER VIEW [dbo].[DAG_V_TRANS_TGT_DEF_INST_MD] ( MAPPING_ID, 
--INSTANCE_ID, INSTANCE_NAME, WIDGET_TYPE, INSTANCE_COMMENTS, 
--TARGET_VERSION_ID, TARGET_ID, TARGET_NAME, LAST_SAVED, 
--TARGET_DESC, REJECT_TRUNCATED_OVERFLOW, UPDATE_OVERRIDE, TABLENAME_PREFIX, 
--PRE_SQL, POST_SQL ) AS 
SELECT DISTINCT	a.mapping_id,
				a.instance_id,
				a.instance_name,
				a.widget_type,
				convert(varchar,a.comments) AS instance_comments,
				z.subj_id AS target_version_id,
				z.target_id,
				z.target_name,
				convert(datetime,z.last_saved) AS last_saved,
				convert(varchar,z.target_desc),
 				isnull(i1.reject_truncated_overflow,'NO') AS reject_truncated_overflow,
 				isnull(i2.update_override,NULL) AS update_override,  -- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 				isnull(i3.tablename_prefix,NULL) AS tablename_prefix, -- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 				isnull(i6.pre_sql,NULL) AS pre_sql, -- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 				isnull(i7.post_sql,NULL) AS post_sql			-- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 FROM  opb_targ z,opb_mapping y,opb_widget_inst a
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	          case convert(varchar,c.attr_value)
                       when '1' then 'YES'
                       when '0' then 'NO' end AS reject_truncated_overflow
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 1) AND
			 (c.line_no = 1)) i1
 on a.mapping_id = i1.mapping_id and a.instance_id = i1.instance_id
 left join 
      (SELECT c.mapping_id,
	  		  c.instance_id,
	          convert(varchar,c.attr_value) AS update_override
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 2) AND
			 (c.line_no = 1)) i2
 on a.mapping_id = i2.mapping_id and a.instance_id = i2.instance_id
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	     	  convert(varchar,c.attr_value) AS tablename_prefix
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 3) AND
			 (c.line_no = 1)) i3
 on a.mapping_id = i3.mapping_id and a.instance_id = i3.instance_id
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	     	  convert(varchar,c.attr_value) AS pre_sql
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 6) AND
			 (c.line_no = 1)) i6
 on a.mapping_id = i6.mapping_id and a.instance_id = i6.instance_id
 left join 
      (SELECT c.mapping_id,
	  		  c.instance_id,
	     	  convert(varchar,c.attr_value) AS post_sql
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 7) AND
			 (c.line_no = 1)) i7
 on a.mapping_id = i7.mapping_id and a.instance_id = i7.instance_id
 WHERE 
   	   (a.mapping_id = y.mapping_id) AND -- need this join as widget_id cannot be joined directly with source_id
	   (y.subject_id = z.subj_id) AND
	   (y.version_id = z.versionid) AND
	   (a.widget_id = z.target_id) AND
	   (a.widget_type = 2) AND
	    z.is_visible = 1 AND
	    y.is_visible = 1
UNION   -- Since Target Definition Transform Instance can refer to a Target or a Shortcut Target
SELECT DISTINCT	a.mapping_id,
				a.instance_id,
				a.instance_name,
				a.widget_type,
				convert(varchar,a.comments) AS instance_comments,
				z.subject_id AS target_version_id,
				z.object_id AS target_id,
				z.shortcut_name AS target_name,
				convert(datetime,z.creation_time) AS last_saved,
				convert(varchar,z.comments) AS target_desc,
 				isnull(i1.reject_truncated_overflow,'NO') AS reject_truncated_overflow,
 				isnull(i2.update_override,NULL) AS update_override,  -- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 				isnull(i3.tablename_prefix,NULL) AS tablename_prefix, -- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 				isnull(i6.pre_sql,NULL) AS pre_sql, -- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 				isnull(i7.post_sql,NULL) AS post_sql			-- Since there is no base value for this object type , hence it ti NULL if no instance value is specified
 FROM  opb_shortcut z,opb_mapping y,opb_widget_inst a
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	          case convert(varchar,c.attr_value)
                       when '1' then 'YES'
                       when '0' then 'NO' end  AS reject_truncated_overflow
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 1) AND
			 (c.line_no = 1)) i1
 on a.mapping_id = i1.mapping_id  and a.instance_id = i1.instance_id
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	          convert(varchar,c.attr_value) AS update_override
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 2) AND
			 (c.line_no = 1)) i2
 on a.mapping_id = i2.mapping_id and a.instance_id = i2.instance_id
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	     	  convert(varchar,c.attr_value) AS tablename_prefix
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 3) AND
			 (c.line_no = 1)) i3
 on a.mapping_id = i3.mapping_id and a.instance_id = i3.instance_id
 left join 
      (SELECT c.mapping_id,
	  		  c.instance_id,
	     	  convert(varchar,c.attr_value) AS pre_sql
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 6) AND
			 (c.line_no = 1)) i6
 on a.mapping_id = i6.mapping_id  and a.instance_id = i6.instance_id
 left join
      (SELECT c.mapping_id,
	  		  c.instance_id,
	     	  convert(varchar,c.attr_value) AS post_sql
       FROM opb_widget_inst b, opb_widget_attr c
	   WHERE (b.mapping_id = c.mapping_id) AND
	  	     (b.instance_id = c.instance_id) AND
			 (c.widget_type = 2) AND
			 (c.attr_id = 7) AND
			 (c.line_no = 1)) i7
 on a.mapping_id = i7.mapping_id  and a.instance_id = i7.instance_id
 WHERE     (a.mapping_id = y.mapping_id) AND -- need this join as widget_id cannot be joined directly with source_id
	   (y.subject_id = z.subject_id) AND
	   (y.version_id = z.version_id) AND
	   (a.widget_id = z.object_id) AND
	   (a.widget_type = 2) AND (z.object_type=24) AND
	    z.is_visible = 1 AND
	    y.is_visible = 1
