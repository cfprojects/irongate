<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>
<cfparam name="form.file" default="">
<cfif len(form.file)>
	<cffile
		action 			= "upload"
		filefield 		= "form.file" 
		nameconflict	= "makeunique"
		destination 	= "#irongate.LogFolder#\variables">
		<cfset filename = file.serverFile>
		<cfif not ListFindNoCase('xml',file.clientFileExt)>
			<cfset session.error	= "Import failed. Not XML file.">
			<cffile action = "delete" file = "#irongate.LogFolder#\variables\#filename#">
		<cfelse>
			<cffile action="read" file="#irongate.LogFolder#\variables\#filename#" variable="irongateFile" />
			<cfif not IsXML(irongateFile)>
				<cffile action = "delete" file = "#irongate.LogFolder#\variables\#filename#">
				<cfset session.error	= "Import failed. Not valid XML file.">
			<cfelse>
				<cfset irongateFile = XMLParse(irongateFile)>
				<cfif not StructKeyExists(irongateFile,'irongate')>
					<cffile action = "delete" file = "#irongate.LogFolder#\variables\#filename#">
					<cfset session.error	= "Import failed. Not valid import file.">
				<cfelse>
					<cfif not IsWDDX(irongateFile.irongate.query.XmlText)>
						<cffile action 	= "delete" file 	= "#irongate.LogFolder#\variables\#filename#">
						<cfset session.error	= "Import failed. Not valid import file.">
					<cfelse>
						<cftransaction>
						<cfdump var="#irongateFile#">
						<cfwddx action="wddx2cfml" input="#irongateFile.irongate.query.XmlText#" output="irongateLog">
						<!--- create error id   --->
						<cfquery name="irongate.i" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
							select max(errorid)+1 as mxerrorid from #irongate.table#
						</cfquery>
						
						<cfset Errorid	= val(irongate.i.mxerrorid)+1>
						<cfset Code		= CreateUUID()>
						<!--- insert the record --->
						<cfquery datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#" name="irongate.add">
							insert into #irongate.table#
							(line, etime, errorid, code, template,message,type)
							values
							(#val(irongateLog.Line)#,#CreateODBCDateTime(now())#,#val(Errorid)#,
							<cfqueryparam
								value="#Code#"
								cfsqltype="CF_SQL_VARCHAR"
								maxlength="35">,
							<cfqueryparam
								value="#left(trim(irongateLog.template),200)#"
								cfsqltype="CF_SQL_VARCHAR"
								maxlength="200">,
							<cfqueryparam
								value="#left(trim(irongateLog.Message),500)#"
								cfsqltype="CF_SQL_VARCHAR"
								maxlength="500">,
							<cfqueryparam
								value="i.#irongateLog.Type#"
								cfsqltype="CF_SQL_VARCHAR"
								maxlength="20">
								)
						</cfquery>
						
						<cftry>
							<cffile
								action 		= "write"
								file 		= "#irongate.LogFolder#/variables/#Code#.cfm"
								output 		= "<cfabort />#irongateFile.irongate.vari.XmlText#">
							<cfcatch></cfcatch>
						</cftry>
						
						<cftry>
							<cffile
								action 		= "write"
								file 		= "#irongate.LogFolder#/pages/#Code#.cfm"
								output 		= "<cfabort />#irongateFile.irongate.code.XmlText#">
							<cfcatch></cfcatch>
						</cftry>
						
						<cffile action = "delete" file = "#irongate.LogFolder#\variables\#filename#">
						<cfset session.msg	= "Import Successful">
						</cftransaction>
					</cfif>
				</cfif>
			</cfif>			
		</cfif>
</cfif>