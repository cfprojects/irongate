<cfif IsDefined('session.error')>
	<div id="errmsg"><img src="images/rdleft.gif" align="absmiddle" />&nbsp; <cfoutput>#session.error#</cfoutput>&nbsp; <img src="images/rdrite.gif" align="absmiddle" /></div>
	<cfset StructDelete(session, "error")>
</cfif>
<cfif IsDefined('session.msg')>
	<div id="msg"><img src="images/blulft.gif" align="absmiddle" />&nbsp; <cfoutput>#session.msg#</cfoutput>&nbsp; <img src="images/blurite.gif" align="absmiddle" /></div>
	<cfset StructDelete(session, "msg")>
</cfif>