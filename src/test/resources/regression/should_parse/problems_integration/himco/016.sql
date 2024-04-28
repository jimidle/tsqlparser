		SELECT  
			  @MeAsofDt 
			  ,[FundCd]
			  ,[LocalSecId]
			  ,[OraOdsTrdId]
			  ,[SysId]
			  ,[CurrencyCd]
			  ,[ParAmount]
			  ,[AccruedInterest]
			  ,[MarketValue]
			  ,[AccrualAmtOut]
			  ,[AccrualAmtIn]
			  ,[AccrualAmt]
			  ,[TrdPrincipal]
			  ,[SysTradeLotId]
			  ,[PriceWithAI]
			  ,[PriceWithoutAI]
			  ,'RollMEndPositionLoad'
			  ,getdate()
			  ,'RollMEndPositionLoad'
			  ,getdate()
		FROM [Pws].[T_Position] as pos
		WHERE 1=1 
		AND  SysId = 'BRS' 
		AND  AsofDt =  @AsofDt  