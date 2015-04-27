<cfsilent>
<cfquery name="this.q" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select * from #irongate.table# where bugid = #url.id#
</cfquery>
<cfwddx action="cfml2wddx" input="#this.q#" output="irongateq">

<cfif FileExists("#irongate.LogFolder#/variables/#this.q.Code#.cfm")>
	<cffile action="read" file="#irongate.LogFolder#/variables/#this.q.Code#.cfm" variable="irongateFile" />
	<cfset irongatev = ungzip(trim( replacenocase(irongateFile,'<cfabort />','') ),irongate.compress,this.q.code)>
</cfif>

<cfif FileExists("#irongate.LogFolder#/pages/#this.q.Code#.cfm")>
	<cffile action="read" file="#irongate.LogFolder#/pages/#this.q.Code#.cfm" variable="code">
	<cfset irongatecode	= ungzip(trim( replacenocase(code,'<cfabort />','') ),irongate.compress,this.q.Code)>
</cfif>
<cfoutput>
<cfsavecontent variable="irongateexport"><irongate>
<query><![CDATA[#tostring(irongateq)#]]></query>
<vari><![CDATA[#tostring(irongatev)#]]></vari>
<code><![CDATA[#tostring(irongatecode)#]]></code>
</irongate></cfsavecontent>
</cfoutput>

<cffile
	action 	= "write"
	file 	= "#irongate.LogFolder#/variables/irongate_#url.id#.xml"
	output 	= "#trim(irongateexport)#">
</cfsilent>
<cfheader name="Content-Disposition" value="attachment; filename=irongate_#url.id#.xml">
<cfcontent file="#irongate.LogFolder#/variables/irongate_#url.id#.xml" type="application/x-unknown" deletefile="yes"> 