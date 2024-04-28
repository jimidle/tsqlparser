		SELECT 			C.UNIQUE_ID, 
						'BRS',
						getdate(),
						I.CODE,
						VT.VALUE_ID,
						SUBSTRING(I.IDENTIFIER,1,LEN(I.IDENTIFIER)-5),
						I.IDENTIFIER,
						C.ASOF_DATE,
						'S',
						'System Generated - dbo.usp_BRSCPCusipReuseProcess'					
		FROM 			dbo.T_BRS_SEC_ID AS I
		JOIN			#CPCUSIP as C
		ON				I.CUSIP = C.CUSIP
		JOIN			dbo.V_ODS_VALUE_TRANSLATE_COMPLETE as VT
		ON				I.CODE COLLATE Latin1_General_CS_AS = VT.SYS_VALUE
		AND				VT.CODE_SET_ID = 9
		AND				VT.SYS_ID = 'BRS'
		WHERE			I.BRS_CODE_VALUE_ID IN (1295,1296,1247,1249,1306,1009)