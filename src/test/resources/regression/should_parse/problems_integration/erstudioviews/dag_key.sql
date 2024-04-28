SELECT repo_key.repo_key_id, repo_key_ver.NAME AS key_name,
          repo_key_ver.repo_key_ver_id, ctl_obj_rel_ver.ctl_obj_rel_ver_id,
          repo_key.entity_id,
          case repo_key_ver.keytype
                  when 'P'then 'Primary Key'
                  when 'A'then 'Alternate Key'
                  when 'I'then 'Inversion Entry'
          end AS keytype,
          model_ver.model_type,
          dbo.dag_mainmodelid (entity.model_id ) AS mainmodel_id,
          model.diagram_id, model_ver.NAME AS model_name,
          ctl_obj_rel_ver.release_id
     FROM ctl_obj_rel_ver,
          ctl_object_ver,
          repo_key_ver,
          repo_key,
          entity,
          model,
          model_ver
    WHERE repo_key.repo_key_id = repo_key_ver.repo_key_id
      AND ctl_object_ver.version_guid = repo_key_ver.version_guid
      AND ctl_obj_rel_ver.ctl_object_ver_id = ctl_object_ver.ctl_object_ver_id
      AND ctl_obj_rel_ver.release_id = (
                                         SELECT MAX (r.release_id)
                                           FROM release r
                                          WHERE r.diagram_id =
                                                              model.diagram_id AND r.is_deleted = 0)
      AND repo_key.entity_id = entity.entity_id
      AND entity.model_id = model.model_id
      AND model.latest_version_id = model_ver.model_ver_id
      AND repo_key.repo_key_id IN (SELECT DISTINCT repo_key_id
                                              FROM key_attribute);