<cfcomponent displayname ="irongate" >

<cfinclude template="../settings.cfm">

<cffunction name="stat" access="remote" returntype="any">
	<cfargument name="id"	required="yes" type="any" />
	<cfargument name="stat" required="yes" type="any" />
	
	<cfif StructKeyExists(cookie,'irongate_login')>
		<cfquery name="update" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
			update #irongate.table# set
			status		= #val(arguments.stat)#
			where bugid = #val(arguments.id)#
		</cfquery>
	</cfif>
	
	<cfreturn arguments.stat>
</cffunction>

</cfcomponent>