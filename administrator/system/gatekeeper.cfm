<cfinclude template="../login_details.cfm">
<cfsilent>
<cfif StructKeyExists(cookie,'irongate_login') and compare(cookie.irongate_login,"#hash(irongate.username)##hash(irongate.password)#")>
	<cfif len(cgi.QUERY_STRING)>
		<cfset session.msg	= "Session Expired. Please Login.">
	</cfif>
	<cflocation addtoken="no" url="login.cfm?r=#cfusion_encrypt(cgi.QUERY_STRING,'irongate')#">
</cfif>
</cfsilent>
