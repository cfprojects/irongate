<cfif val(url.shown)>
	<cfcookie name="resPerPage" value="#url.shown#" expires="never">
</cfif>
<cfset shown		= cookie.resPerPage>
<cfset thispage 	= url.page>
<cfset total 		= master.recordCount>

<cfset getlist	= ''>
<cfset endpage	= thispage*shown>
<cfset stpage	= endpage-shown+1>
<cfif endpage gt total>
	<cfset endpage = total>
</cfif>

<cfloop from="#stpage#" to="#endpage#" index="i"> 
    <cfset getlist	= ListAppend(getlist, listgetat(searchlist,i))>
</cfloop>
<cfset searchlist = getlist>