<cfparam name="url.action" default="">
<cfset irongate.table	= 'irongate'>
<cfset irongate.version	= '1'>

<cfinclude template="header.cfm">

<cfset settingfile = "#ExpandPath('..\')#irongate.cfm">

<cfswitch expression="#url.action#">
	<cfcase value="7">
		<cfinclude template="page_7.cfm">
	</cfcase>
	<cfcase value="6">
		<cfinclude template="page_6.cfm">
	</cfcase>
	<cfcase value="5">
		<cfinclude template="page_5.cfm">
	</cfcase>
	<cfcase value="4">
		<cfinclude template="page_4.cfm">
	</cfcase>
	<cfcase value="3">
		<cfinclude template="page_3.cfm">
	</cfcase>
	<cfcase value="2">
		<cfinclude template="page_2.cfm">
	</cfcase>
	<cfcase value="1">
		<cfinclude template="page_1.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="view_license.cfm">
	</cfdefaultcase>
</cfswitch>
<cfinclude template="footer.cfm">