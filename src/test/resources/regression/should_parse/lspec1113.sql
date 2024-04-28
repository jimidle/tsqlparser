CREATE SPATIAL INDEX SIndx_SpatialTable_geometry_col3
   ON SpatialTable(geometry_col)
   WITH (
	    BOUNDING_BOX = ( 0, 0, 500, 200 ),
		    GRIDS = ( LEVEL_4 = HIGH, LEVEL_3 = MEDIUM ) );

