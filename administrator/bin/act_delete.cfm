<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>
<!--- ****************************************** --->
<!--- Delete Records                             --->
<!--- ****************************************** --->
<cfquery name="ThisE" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select code from #irongate.table# where 
	<cfif not StructKeyExists(url,'bugid')>
		errorid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.errorid#" list="yes">)
	<cfelse>
		bugid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.bugid#" list="yes">)
	</cfif>
</cfquery>

<cfloop query="ThisE">
	<cfif FileExists("#irongate.LogFolder#/variables/#ThisE.code#.cfm")>
		<cffile action="delete" file="#irongate.LogFolder#/variables/#ThisE.code#.cfm" />
	</cfif>
	<cfif FileExists("#irongate.LogFolder#/pages/#ThisE.code#.cfm")>
		<cffile action="delete" file="#irongate.LogFolder#/pages/#ThisE.code#.cfm" />
	</cfif>
</cfloop>

<cfquery name="delete" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	delete from #irongate.table# where
	<cfif not StructKeyExists(url,'bugid')>
		errorid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.errorid#" list="yes">)
	<cfelse>
		bugid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.bugid#" list="yes">)
	</cfif>
</cfquery>

<cfif StructKeyExists(url,'bugid')>
	<cflocation addtoken="no" url="index.cfm?errorid=#url.errorid#&action=incidence" />
<cfelse>
	<cflocation addtoken="no" url="index.cfm?page=#url.page#" />
</cfif>