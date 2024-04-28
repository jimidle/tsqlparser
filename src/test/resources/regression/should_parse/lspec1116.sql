CREATE SPATIAL INDEX SIndx_SpatialTable_geography_col2
   ON SpatialTable2(object)
   USING GEOGRAPHY_GRID
   WITH (
	    GRIDS = (MEDIUM, LOW, MEDIUM, HIGH ),
		    CELLS_PER_OBJECT = 64,
			    PAD_INDEX  = ON );

