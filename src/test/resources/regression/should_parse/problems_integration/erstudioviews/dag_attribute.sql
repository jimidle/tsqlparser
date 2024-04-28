SELECT ctl_obj_rel_ver.ctl_obj_rel_ver_id,
          attribute_ver.NAME AS attribute_name,
          attribute_ver.attribute_ver_id, ATTRIBUTE.attribute_id,
          attribute_ver.version_guid, attribute_ver.logical_role_name,
          attribute_ver.column_name,
          dbo.dag_data_type_str (attribute_ver.data_type,
                             attribute_ver.LENGTH,
                             attribute_ver.scale
                            ) AS data_type,
          attribute_ver.data_type AS data_type_str_val, attribute_ver.LENGTH,
          attribute_ver.scale,
          case attribute_ver.is_nullable
          when 0 then 'No'
          when 1 then 'Yes' end AS nullability, attribute_ver.default_data,
          attribute_ver.sequence_number, model_ver.model_type,
          model_ver.NAME AS model_name, attribute_ver.definition,
          attribute_ver.notes,
          dbo.dag_mainmodelid (entity.model_id) AS mainmodel_id,
          ATTRIBUTE.entity_id,
          case attribute_ver.flags 
            when 0 then 'N' when 128 then 'N'
            when 1 then 'Y' when 129 then 'Y' when 130 then 'Y' 
            else cast(attribute_ver.flags as varchar) 
          end AS log_phy_only_flag,
          attribute_ver.role_name, model.diagram_id,
          ctl_obj_rel_ver.release_id
     FROM ctl_obj_rel_ver,
          ctl_object_ver,
          ATTRIBUTE,
          attribute_ver,
          entity,
          model,
          model_ver
    WHERE ATTRIBUTE.attribute_id = attribute_ver.attribute_id
      AND ctl_object_ver.version_guid = attribute_ver.version_guid
      AND ctl_obj_rel_ver.ctl_object_ver_id = ctl_object_ver.ctl_object_ver_id
      AND ctl_obj_rel_ver.release_id = (
                                         SELECT MAX (r.release_id)
                                           FROM release r
                                          WHERE r.diagram_id =
                                                              model.diagram_id AND r.is_deleted = 0)
      AND ATTRIBUTE.entity_id = entity.entity_id
      AND entity.model_id = model.model_id
      AND model.latest_version_id = model_ver.model_ver_id;
