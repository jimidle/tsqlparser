CREATE TABLE SpatialTable(id int primary key, geometry_col geometry);
-- Commented out for now as lots of syntax to support here
-- CREATE SPATIAL INDEX SIndx_SpatialTable_geometry_col1
--   ON SpatialTable(geometry_col)
--   WITH ( BOUNDING_BOX = ( 0, 0, 500, 200 ) );

