<cfif not StructKeyExists(cookie,'irongate_login')>
	<cfset session.m	= "Session Expired! Please Login.">
	<cflocation addtoken="no" url="login.cfm">
</cfif>