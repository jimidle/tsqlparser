CREATE SPATIAL INDEX SIndx_SpatialTable_geography_col3
   ON SpatialTable2(object)
   WITH ( GRIDS = ( LEVEL_3 = HIGH, LEVEL_2 = HIGH ) );

