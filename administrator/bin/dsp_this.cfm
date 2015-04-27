<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>

<cfquery name="thisE" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select code,errorid,template,message from #irongate.table# where bugid = #url.id#
</cfquery>

<div style="padding-left:10px; padding-right:10px;">
<cfif FileExists("#irongate.LogFolder#/variables/#thisE.Code#.cfm")>
	<!--- ****************************************** --->
	<!--- Read the log file and convert to variables --->
	<!--- ****************************************** --->
	<cffile action="read" file="#irongate.LogFolder#/variables/#thisE.Code#.cfm" variable="irongateFile" />
	<cfset irongateFile = ungzip(trim( replacenocase(irongateFile,'<cfabort />','') ),irongate.compress,ThisE.code)>

	<cfwddx action="wddx2cfml" input="#irongateFile#" output="irongateXML">

	<cfset StructDelete(variables,'irongateFile')>
	<!--- ****************************************** --->
	<!--- Tabs                                       --->
	<!--- ****************************************** --->
	<div class="tabline">
		<div>Message</div>
		<cfif StructKeyExists(irongateXML,'session')	and not StructIsEmpty(irongateXML.session)><div id="session_tab">Session</div></cfif>
		<cfif StructKeyExists(irongateXML,'request')	and not StructIsEmpty(irongateXML.request)><div id="request_tab">Request</div></cfif>
		<cfif StructKeyExists(irongateXML,'cgi')		and not StructIsEmpty(irongateXML.cgi)><div id="cgi_tab">CGI</div></cfif>
		<cfif StructKeyExists(irongateXML,'cookie')	and not StructIsEmpty(irongateXML.cookie)><div id="cookie_tab">Cookie</div></cfif>
		<cfif StructKeyExists(irongateXML,'url')		and not StructIsEmpty(irongateXML.url)><div id="url_tab">URL</div></cfif>
		<cfif StructKeyExists(irongateXML,'form')		and not StructIsEmpty(irongateXML.form)><div id="form_tab">Form</div></cfif>
		<cfif StructKeyExists(irongateXML,'query')		and not StructIsEmpty(irongateXML.query)><div id="query_tab">Query</div></cfif>
		<cfif StructKeyExists(irongateXML,'vari')		and not StructIsEmpty(irongateXML.vari)><div id="variables_tab">Variables</cfif></div>
		<cfif StructKeyExists(irongateXML,'ServerData')	and not StructIsEmpty(irongateXML.vari)><div id="server_tab">Server</cfif></div>
		<cfif FileExists("#irongate.LogFolder#/pages/#thisE.Code#.cfm")>
			<cffile action="read" file="#irongate.LogFolder#/pages/#thisE.Code#.cfm" variable="code">
			<cfset code	= ungzip(trim( replacenocase(code,'<cfabort />','') ),irongate.compress,ThisE.code)>
			<cfif IsDefined("irongateXML.vari.irongateLog.line")>
				<cfset line	= irongateXML.vari.irongateLog.line>
			<cfelse>
				<cfset line	= 0>
			</cfif>
			<div>Code</div>
		</cfif>
		<div>Action</div>
	</div>

	<!--- ****************************************** --->
	<!--- Tab Boxes                                  --->
	<!--- ****************************************** --->
	<div class="tabboxes">
		<div class="box"><cfinclude template="errormsg.cfm"></div>
		<cfif StructKeyExists(irongateXML,'session') and not StructIsEmpty(irongateXML.session)>
			<div class="box"><cfdump var="#irongateXML.session#"></div>
		</cfif>
		<cfif StructKeyExists(irongateXML,'request') and not StructIsEmpty(irongateXML.request)>
			<div class="box"><cfdump var="#irongateXML.request#"></div>
		</cfif>

		<cfoutput>
		<cfif StructKeyExists(irongateXML,'cgi') and not StructIsEmpty(irongateXML.cgi)>
		<div class="box">
		<table class="vartbl" cellpadding="0" cellspacing="0" border="0">
			<cfloop collection="#irongateXML.cgi#" item = "i">
				<tr><td class="vname" valign="top">#i#</td>
				<td class="vdata" valign="top">#irongateXML.cgi[i]#</td></tr>
			</cfloop>
		</table>
		</div>
		</cfif>

		<cfif StructKeyExists(irongateXML,'cookie') and not StructIsEmpty(irongateXML.cookie)>
			<div class="box">
				<table class="vartbl" cellpadding="0" cellspacing="0" border="0">
					<cfloop collection="#irongateXML.cookie#" item = "i">
						<tr><td class="vname" valign="top">#i#</td>
						<td class="vdata" valign="top">#irongateXML.cookie[i]#</td></tr>
					</cfloop>
				</table>
			</div>
		</cfif>

		<cfif StructKeyExists(irongateXML,'url') and not StructIsEmpty(irongateXML.url)>
			<div class="box">
				<table class="vartbl" cellpadding="0" cellspacing="0" border="0">
					<cfloop collection="#irongateXML.url#" item = "i">
						<tr><td class="vname" valign="top">#i#</td>
						<td class="vdata" valign="top">#irongateXML.url[i]#</td></tr>
					</cfloop>
				</table>
			</div>
		</cfif>

		<cfif StructKeyExists(irongateXML,'form') and not StructIsEmpty(irongateXML.form)>
			<div class="box">
				<table class="vartbl" cellpadding="0" cellspacing="0" border="0">
					<cfloop collection="#irongateXML.form#" item = "i">
						<tr><td class="vname" valign="top">#i#</td>
						<td class="vdata" valign="top"><cfif isSimpleValue(irongateXML.form[i])>
							#irongateXML.form[i]#
						<cfelse>
							<cfdump var = "#irongateXML.form[i]#" />
						</cfif></td></tr>
					</cfloop>
				</table>
			</div>
		</cfif>

		<cfflush>

		<cfif StructKeyExists(irongateXML,'query') and not StructIsEmpty(irongateXML.query)>
		<div class="box">
			<cfdump var="#irongateXML.query#">
		</div>
		</cfif>

		<cfflush>
		<cfif StructKeyExists(irongateXML,'vari') and not StructIsEmpty(irongateXML.vari)>
		<div class="box">
			<cfif StructKeyExists(irongateXML.vari,'irongateLog')>
				<cfset StructDelete(irongateXML.vari,'irongateLog')>
			</cfif>
			<cfdump var="#irongateXML.vari#">
		</div>
		</cfif>

		<cfflush>
		<cfif StructKeyExists(irongateXML,'ServerData') and not StructIsEmpty(irongateXML.ServerData)>
		<div class="box">
		<table class="vartbl" cellpadding="0" cellspacing="0" border="0">
		<cfif StructKeyExists(irongateXML.ServerData,'memory')>
			<cfset memory.freeMemory	= irongateXML.ServerData.memory.free/1024^2>
			<cfset memory.totalMemory	= irongateXML.ServerData.memory.total/1024^2>
			<cfset memory.maxMemory		= irongateXML.ServerData.memory.maxm/1024^2>
			<cfset memory.used 			= memory.totalMemory - memory.freeMemory>
			<cfset memory.pTotalMemory	= (memory.totalMemory / memory.maxMemory) * 100>
			<cfset memory.UsedMax 		= (memory.used / memory.maxMemory) * 100>	
			<tr><td class="vname" valign="top">Maximum Memory</td><td class="vdata" valign="top">#NumberFormat(memory.maxMemory, '_.999')# MB</td></tr>
			<tr><td class="vname" valign="top">Memory Allocated</td><td class="vdata" valign="top">#NumberFormat(memory.totalMemory, '_.999')# MB <div class="progress progress" style="width:200px; height:15px; border:1px solid ##CCC"><div class="bar tip" style="height:15px; width:#Round(memory.pTotalMemory*2)#px" original-title="#NumberFormat(memory.pTotalMemory, '_.99')#%"></div></div></td></tr>
			<tr><td class="vname" valign="top">Memory Used</td><td class="vdata" valign="top">#NumberFormat(memory.used, '_.999')# MB <div class="progress progress" style="width:200px; height:15px; border:1px solid ##CCC"><div class="bar tip" style="height:15px; width:#Round(memory.UsedMax*2)#px" original-title="#NumberFormat(memory.UsedMax, '_.99')#%"></div></div></td></tr>
		</cfif>
		<cfif StructKeyExists(irongateXML.ServerData,'metricData')>
			<cfloop collection="#irongateXML.ServerData.metricData#" item = "i">
				<tr><td class="vname" valign="top">#i#</td>
				<td class="vdata" valign="top">#irongateXML.ServerData.metricData[i]#</td></tr>
			</cfloop>
		</cfif>
		</table>
		</div>
		</cfif>
		<cfif FileExists("#irongate.LogFolder#/pages/#thisE.Code#.cfm")>
			<cfset Color = CreateObject("Component", "Color")>
			<div class="box"><div style="border:1px solid ##E4E4E4">#Color.colorString(code,true,line)#</div></div>
		</cfif>
		</cfoutput>
		
		<div class="box">
			<cfquery name="thisdetail" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
				select  min(etime) as etime, max(status) as status, count(errorid) as ecount from #irongate.table# where errorid = #thisE.errorid#
			</cfquery>
			<cfoutput>
			<br />
			<cfif thisdetail.ecount gt 1>
				This Error Occurred <a href="index.cfm?action=incidence&errorid=#thisE.errorid#&id=#url.id#">#thisdetail.ecount# times</a> since #dateformat(thisdetail.etime,'ddd mm/dd/yy')# #timeformat(thisdetail.etime,'hh:mm tt')#. <a href="javascript:conf('Delete Record','Are You sure You want to delete these records?','index.cfm?action=delete&errorid=#thisE.errorid#&page=#url.page#')"><img src="images/bin.png" border="0" align="absmiddle" /> Delete These Reccords.</a>
			<cfelse>
				This Error Occurred at #dateformat(thisdetail.etime,'ddd mm/dd/yy')# #timeformat(thisdetail.etime,'hh:mm tt')#. <a href="javascript:var r=confirm('Are You sure You want to delete this record?'); if (r==true){window.location='index.cfm?action=delete&errorid=#thisE.errorid#&page=#url.page#'}"><img src="images/bin.png" border="0" align="absmiddle" /> Delete This Record.</a>
			</cfif>
			<a href="index.cfm?action=export&errorid=#thisE.errorid#&id=#url.id#"><img src="images/settingssml.png" title="Export" border="0" align="absmiddle" /> Export This Record</a>
			</cfoutput>
			
			<!--- ******************************************** --->
			<!--- Other errors in the same template            --->
			<!--- ******************************************** --->
			<cfquery name="template" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
				select  max(bugid) as id, message, line, max(status) as status, errorid from #irongate.table# 
				where template = '#thisE.template#' and errorid <> #val(thisE.errorid)#
				group by errorid,message, line
				order by id desc 
			</cfquery>
	
			<cfif template.recordCount>
			<div style="padding:3px; margin-top:20px; clear:both; border-bottom:1px dotted #CCC; font-weight:bold;">Other Errors Occurred in This Template</div>
				<cfoutput query="template">
				<div style="padding:2px"><img src="images/#val(template.status)#_stat.png" /> <a href="index.cfm?action=incidence&errorid=#template.errorid#&id=#template.id#">#template.message# Line #template.line#</a></div>
				</cfoutput>
			</cfif>

			<!--- ******************************************** --->
			<!--- same message in other templates              --->
			<!--- ******************************************** --->
			<cfquery name="other" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
				select max(bugid) as id, template, line, max(status) as status , errorid
				from #irongate.table# where message = '#thisE.message#' and errorid <> #val(thisE.errorid)# 
				group by errorid, template, line
				order by id desc 
			</cfquery>
			<cfif other.recordCount>
			<div style="padding:3px; margin-top:20px; clear:both; border-bottom:1px dotted #CCC; font-weight:bold;">"<cfoutput>#thisE.message#</cfoutput>" in Other Templates: </div>
			<cfoutput query="other">
				<div style="padding:2px"><img src="images/#val(other.status)#_stat.png" /> <a href="index.cfm?action=incidence&errorid=#other.errorid#&id=#other.id#">#other.template# Line #other.line#</a></div>
			</cfoutput>
			</cfif>
		</div>
	</div>
<cfelse>
	<cfset session.msg	= "No Error Log Available.">
	<br /><ct:msg><br /><br />
	<cfoutput><a href="javascript:var r=confirm('Are You sure You want to delete this record?'); if (r==true){window.location='index.cfm?action=delete&errorid=#thisE.errorid#&page=#url.page#'}"><img src="images/bin.png" border="0" align="absmiddle" /> Delete This Record.</a></cfoutput>
</cfif>
</div><br />