<!--- ************************************************************** --->
<!--- update the index page and set it administrator                 --->
<!--- ************************************************************** --->
<cftry>
<cfoutput>
<cfsavecontent variable="pageContent">
[cflocation addtoken="no" url="administrator" />
</cfsavecontent>
</cfoutput>

<cfset pageContent = trim(replace(pageContent,'[cf','<cf','all'))>

<cffile 
	action			= "write"  
	nameconflict	= "overwrite" 
	charset			= "utf-8"
	file			= "#ExpandPath('..\')#index.cfm"
	output			= "#pageContent#">
	<cfcatch></cfcatch>
</cftry>
<cflocation addtoken="no" url="index.cfm?action=7">