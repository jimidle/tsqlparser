SELECT relationship.relationship_id, relationship.child_entity_id,
          ctl_obj_rel_ver.ctl_obj_rel_ver_id, relationship.parent_entity_id,
          relationship_ver.relationship_ver_id,
          case relationship_ver.relationshiptypeid
                  when 'I' then 'Identifying'
                  when 'N' then 'Non-Identifying'
                  else 'Non-Specific'
          end AS rel_type,
          relationship_ver.childoptionalityid,
          relationship_ver.verbphraseid AS verb_phrase,
          relationship_ver.inversephraseid AS inverse_verb_phrase,
          case relationship_ver.flags  when 0 then 'N'when 1 then 'Y'end AS log_phy_only_flag,
          case relationship_ver.parentoptionalityid
                  when 'M' then 'Mandatory'
                  when 'O' then 'Optional'
                  else relationship_ver.parentoptionalityid
          end AS existense,
          relationship_ver.logicalname AS business_name,

         replace( ','+   ISNULL (relationship_ver.parentinsertid, '#')
          + ','
          + ISNULL (relationship_ver.childinsertid, '#')
          + ','
          + ISNULL (relationship_ver.parentupdateid, '#')
          + ','
          + ISNULL (relationship_ver.childupdateid, '#')
          + ','
          + ISNULL (relationship_ver.parentdeleteid, '#')
          + ','
          + ISNULL (relationship_ver.childdeleteid, '#') +',',
          ',,',',#,') as trigger_val,
          relationship_ver.NAME AS relationship_name, model_ver.model_type,
          dbo.dag_mainmodelid (relationship.model_id) AS mainmodel_id,
          model.diagram_id, model_ver.NAME AS model_name,
          ctl_obj_rel_ver.release_id
     FROM ctl_obj_rel_ver,
          ctl_object_ver,
          relationship,
          relationship_ver,
          model,
          model_ver
    WHERE relationship.relationship_id = relationship_ver.relationship_id
      AND ctl_object_ver.version_guid = relationship_ver.version_guid
      AND ctl_obj_rel_ver.ctl_object_ver_id = ctl_object_ver.ctl_object_ver_id
      AND ctl_obj_rel_ver.release_id = (
                                         SELECT MAX (r.release_id)
                                           FROM release r
                                          WHERE r.diagram_id =
                                                              model.diagram_id AND r.is_deleted = 0)
      AND relationship.model_id = model.model_id
      AND model.latest_version_id = model_ver.model_ver_id;
