CREATE SPATIAL INDEX SIndx_SpatialTable_geometry_col2
   ON SpatialTable(geometry_col)
   USING GEOMETRY_GRID
   WITH (
	    BOUNDING_BOX = ( xmin=0, ymin=0, xmax=500, ymax=200 ),
		    GRIDS = (LOW, LOW, MEDIUM, HIGH),
			    CELLS_PER_OBJECT = 64,
				    PAD_INDEX  = ON );

