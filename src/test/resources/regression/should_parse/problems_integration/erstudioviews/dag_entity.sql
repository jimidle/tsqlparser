SELECT ctl_obj_rel_ver.ctl_obj_rel_ver_id, entity_ver.NAME AS entity_name,
          model_ver.model_type, model_ver.NAME AS model_name, entity.model_id,
          dbo.dag_mainmodelid (entity.model_id
                          ) AS mainmodel_id,
          entity_ver.entity_id, entity_ver.table_name,
          entity_ver.entity_ver_id,
          entity_ver.version_guid AS entity_version_guid,
          entity_ver.note AS entity_note, entity_ver.owner,
          entity_ver.definition AS entity_definition,
          CASE entity_ver.flags when 0 then 'N'when 1 then 'Y'end AS log_phy_only_flag,
          model.diagram_id, ctl_obj_rel_ver.release_id
     FROM ctl_obj_rel_ver,
          ctl_object_ver,
          entity,
          entity_ver,
          model,
          model_ver
    WHERE entity.entity_id = entity_ver.entity_id
      AND ctl_object_ver.version_guid = entity_ver.version_guid
      AND ctl_obj_rel_ver.ctl_object_ver_id = ctl_object_ver.ctl_object_ver_id
      AND ctl_obj_rel_ver.release_id = (
                                         SELECT MAX (r.release_id)
                                           FROM release r
                                          WHERE r.diagram_id =
                                                              model.diagram_id AND r.is_deleted = 0)
      AND entity.model_id = model.model_id
      AND model.latest_version_id = model_ver.model_ver_id;