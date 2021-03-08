/* Populate fct screenerUtiilzation */
truncate table fct_screenerUtilization

update fct_screenerUtilization
set screeningsCompleted = arg.screeningsCompleted,
	utilizationRate = arg.utilizationRate
from 
	(SELECT distinct [screenerId]
		  ,[dateID]
		  ,screeningsCompleted 
		  ,(CAST(screeningsCompleted as decimal(9,2))/4) as utilizationRate
	 from(
		  select screenerId, dateid, count(screenerID) as screeningsCompleted from fct_Screening
			group by screenerID, dateID
		) as result) as arg
where 
	fct_screenerUtilization.screenerID = arg.screenerID and
	fct_ScreenerUtilization.dateID = arg.dateID
