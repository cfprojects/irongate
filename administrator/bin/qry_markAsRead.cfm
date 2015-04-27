<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>
<!--- *************************************************** --->
<!--- Mark Record as Viewed                               --->
<!--- *************************************************** --->
<cfif val(url.id)>
	<cfquery name="update" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
		update #irongate.table# set viewed = <cfqueryPARAM value = "1" CFSQLType = "CF_SQL_BIT"> 
		where bugid = <cfqueryPARAM value = "#val(url.id)#" CFSQLType = "CF_SQL_INTEGER">
	</cfquery>
</cfif>