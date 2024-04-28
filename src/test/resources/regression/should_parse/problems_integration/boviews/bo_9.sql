	SELECT
			 od.OBJECT_ID,
			 od.UNIVERSE_ID,
			 od.OBJ_DATATYPE,
			 od.OBJ_SLICE,
			 od.OBJ_DATAVALUE,
			 t.table_id,
			 t.table_name,
			 t.alias_table_name,
			 case od.OBJ_DATATYPE when 'S' then case CHARINDEX(t.table_name + '.', od.OBJ_DATAVALUE) when 1 then replace(od.OBJ_DATAVALUE, t.table_name + '.', '') end end as column_name
	FROM  	UNV_OBJECT_DATA od, unv_obj_tab ot, DAG_V_TABLES_30 t
	where 	od.universe_id = ot.universe_id and od.object_id = ot.object_id
	and		ot.table_id = t.table_id and ot.universe_id = t.universe_id
	UNION
	SELECT
			 B.OBJECT_ID,
			 B.UNIVERSE_ID,
			 od.OBJ_DATATYPE,
			 od.OBJ_SLICE,
			 od.OBJ_DATAVALUE,
			 t.table_id,
			 t.table_name,
			 t.alias_table_name,
			 case od.OBJ_DATATYPE when 'S' then case CHARINDEX(t.table_name + '.', od.OBJ_DATAVALUE) when 1 then replace(od.OBJ_DATAVALUE, t.table_name + '.', '') end end as column_name
	FROM  UNV_OBJECT_DATA od,
		 UNV_OBJECT B, unv_obj_tab ot, DAG_V_TABLES_30 t 
	WHERE	B.OBJECT_ID  > 65536
	 AND	B.OBJECT_ID  = (od.OBJECT_ID + (od.UNIVERSE_ID * 65536))
	and 	od.universe_id = ot.universe_id and od.object_id = ot.object_id
	and 	ot.table_id = t.table_id and ot.universe_id = t.universe_id
	 