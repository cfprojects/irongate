<cfswitch expression="#url.action#">
	<cfcase value="updateSettings">
		<cfinclude template="act_settings.cfm">
	</cfcase>
	<cfcase value="settings">
		<cfinclude template="dsp_settings.cfm">
	</cfcase>
	<cfcase value="incidence">
		<cfinclude template="inc_.cfm">
		<cfinclude template="qry_markAsRead.cfm">
		<cfinclude template="dsp_incidence.cfm">
		<cfinclude template="js.cfm">
		<cfif val(url.id)>
			<cfinclude template="dsp_this.cfm">
		</cfif>
	</cfcase>
	<cfcase value="import">
		<cfinclude template="act_import.cfm">
		<cflocation addtoken="no" url="index.cfm">
	</cfcase>
	<cfcase value="export">
		<cfinclude template="inc_.cfm">
		<cfinclude template="act_export.cfm">
	</cfcase>
	<cfcase value="delete">
		<cfinclude template="act_delete.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="qry_markAsRead.cfm">
		<cfinclude template="dsp_list.cfm">
		<cfinclude template="js.cfm">
		<cfif val(url.id)>
			<cfinclude template="inc_.cfm">
			<cfinclude template="dsp_this.cfm">
		</cfif>
	</cfdefaultcase>
</cfswitch>