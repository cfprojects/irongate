<cfprocessingdirective pageencoding="utf-8">

<!--- Data Source Name (Valid and Working DSN Required.)             --->
<cfset irongate.datasource		= "">
<!--- Data Source User Name (Leave Blank if not applicable)          --->
<cfset irongate.username		= "">
<!--- Data Source Password (Leave Blank if not applicable)           --->
<cfset irongate.password		= "">
<!--- Log file storage folder (Required)                             --->
<cfset irongate.LogFolder		= "">
<!--- Compress Log Files (If Your Hosting Provider does not support CFOBJECT tag, set this to 'No') [Yes,No] --->
<cfset irongate.compress		= "Yes">

<!--- Send to Email Addresses on error (Leave Blank to disable mail notification.) --->
<cfset irongate.MailTo			= "">
<!--- From Email Address                                             --->
<cfset irongate.MailForm		= "">
<!--- Mail Subject                                                   --->
<cfset irongate.MailSubject		= "Web Site Need Your Attention">
<!--- Mail Server Address                                            --->
<cfset irongate.MailServer		= "">
<!--- Mail Server User Name                                          --->
<cfset irongate.MailUser		= "">
<!--- Mail Server Password                                           --->
<cfset irongate.MailPassword	= "">
<!--- SMTP Port                                                      --->
<cfset irongate.MailPort		= "25">
<!--- Send Mail on [All Exceptions,Fresh Exceptions]                 --->
<cfset irongate.mailon			= "Fresh Exceptions">

<!--- Irongate Admin URL                                               --->
<cfset irongate.AdminURL		= "">
<!--- Debug IP Address list (Separated By Comma. These IP address will see the Robust Exception Information and others friendly error page.) --->
<cfset irongate.homeip			= "">
<!--- Take a Snapshot of the Error Page Code [Yes,No]                --->
<cfset irongate.LogPage	 		= "Yes">

<!--- Headline of the Custom Error Message                           --->
<cfset irongate.title			= "Something just went wrong.">
<!--- Description of the Custom Error Message                        --->
<cfset irongate.desc			= "Everything was working fine, then this happened. Don't worry though. We're working on getting this fixed as soon as possible.">
<!--- Error Page Status Code [500-Server Error,200-OK]               --->
<cfset irongate.StatusCode		= "200">
<!--- List of Variables to Ignore (Separated by comma)               --->
<cfset irongate.ignoreVariables	= "fb_">
<!--- Number of Query Records to Log (Leave Blank to Log All)        --->
<cfset irongate.QueryRecNum		= "10">
<!--- Log Server Memory States [Yes,No]                              --->
<cfset irongate.memorystat		= "Yes">
<!--- Log Server Metric Data [Yes,No]                                --->
<cfset irongate.metricData		= "Yes">









<!--- Above Blank space reserved for future use.                     --->

<!--- ************************************************************** --->
<!--- Fix Settings - Edit With Care                                  --->
<!--- ************************************************************** --->
<cfset irongate.LogVariables	= 'Yes'>
<cfset irongate.table			= 'irongate'>
<cfset irongate.version			= '1.00'>
<cfset irongate.ignoreVariables	= "irongateLog,irongate_formatSQL,irongate_wddxsafe,irongateBox,error,cferror,irongate.wddx,cfcatch,irongateBox.vari,irongate,irongate_serialize,cfquery,cfquery.executiontime,irongate_gzip,#irongate.ignoreVariables#">
<cfset irongate.Code			= CreateUUID()>
<cfset irongate.serVer			= listfirst(server.coldfusion.productversion)>
<cfif not StructKeyExists(variables,'cferror') and not StructKeyExists(variables,'cfcatch')>
	<cfabort>
</cfif>
<!--- ************************************************************** --->
<!--- Handle Error Variables                                         --->
<!--- ************************************************************** --->
<cfset irongateLog				= StructNew()>
<cfsetting requesttimeout="2">

<!--- check for cfcatch or cf error and set to a neautral variable --->
<cfif StructKeyExists(variables,'cferror')>
	<cfset irongate.RootCause = cferror.RootCause >
<cfelse>
	<cfset irongate.RootCause = cfcatch >
</cfif>

<cftry>
<cfset irongateLog.Template		= irongate.RootCause.TagContext[1].Template>
<cfset irongateLog.Line			= irongate.RootCause.TagContext[1].Line>
	<cfif StructKeyExists(variables,'cferror')>
		<cfset irongateLog.Type	= irongate.RootCause.TagContext[1].Type>
	<cfelse>
		<cfset irongateLog.Type	= "(#irongate.RootCause.TagContext[1].Type#)">
	</cfif>
	<cfcatch>
	<cfset irongateLog.Template	= 'Unknown'>
	<cfset irongateLog.Line		= 0>
	<cfset irongateLog.Type		= 'Error'>
	</cfcatch>
</cftry>

<cfif StructKeyExists(irongate.RootCause,'NativeErrorCode')>
	<cfset irongateLog.NativeErrorCode	= irongate.RootCause.NativeErrorCode>
</cfif>
<cfif StructKeyExists(irongate.RootCause,'ErrorCode')>
	<cfset irongateLog.ErrorCode	= irongate.RootCause.ErrorCode>
</cfif>
<cfif StructKeyExists(irongate.RootCause,'Sql')>
	<cfset irongateLog.Sql			= irongate.RootCause.Sql>
</cfif>
<cfif StructKeyExists(irongate.RootCause,'where')>
	<cfset irongateLog.where		= irongate.RootCause.where>
</cfif>
<cfif StructKeyExists(irongate.RootCause,'DataSource')>
	<cfset irongateLog.DataSource	= irongate.RootCause.DataSource>
</cfif>

<cfif StructKeyExists(irongate.RootCause,'Message')>
	<cfset irongateLog.Message		= irongate.RootCause.Message>
	<cfset irongateLog.Detail		= irongate.RootCause.Detail>
	<cfset irongateLog.StackTrace	= irongate.RootCause.StackTrace>
<cfelse>
	<cfset irongateLog.Message		= 'Unknown Error'>
	<cfset irongateLog.Detail		= 'Error Handling Page Triggered without further details.'>
	<cfset irongateLog.StackTrace	= ''>
</cfif>

<cfset irongateLog.DateTime			= now()>
<cfset irongateLog.RemoteAddress	= cgi.Remote_Addr>
<cfset irongateLog.HTTPReferer		= cgi.HTTP_REFERER>
<cfset irongateLog.Browser			= cgi.HTTP_USER_AGENT>

<cftry>
	<cfif ArrayLen(irongate.RootCause.TagContext) gt 1>
		<cfset irongateLog.CalledFrom	= ArrayNew(1)>
		<cfloop from="2" to="#val(ArrayLen(irongate.RootCause.TagContext))#" index="irongateLog.i">
			<cfset ArrayAppend(irongateLog.CalledFrom,"<b>Called from</b> #irongate.RootCause.TagContext[irongateLog.i].Template#: line #irongate.RootCause.TagContext[irongateLog.i].Line#")>
		</cfloop>
		<cfset irongateLog.CalledFrom	= ArrayToList(irongateLog.CalledFrom,'<br />')>
	<cfelse>
		<cfset irongateLog.CalledFrom	= "">
	</cfif>
<cfcatch>
	<cfset irongateLog.CalledFrom		= "">
</cfcatch>
</cftry>

<cftry>
<cfset irongateLog.Code	= ''>
<cfif FileExists('#irongateLog.template#')>
	<cffile action = "read" file = "#irongateLog.template#" variable = "irongateLog.Code">
</cfif>
<cfif len(trim(irongateLog.Code))>
	<!--- converet page code in to array --->
	<cfset irongateLog.Code	= replace(irongateLog.Code,chr(10),'#chr(10)# ','all')>
	<cfset irongateLog.temp	= ArrayNew(1)>
	<cfloop list="#irongateLog.Code#" delimiters="#chr(10)#" index="irongateLog.i">
		<cfset ArrayAppend(irongateLog.temp,irongateLog.i)>
	</cfloop>
	<cfset irongateLog.Code	= irongateLog.temp>
	<cfset StructDelete(irongateLog,'temp')>
<cfelse>
	<cfset irongateLog.Code	= ArrayNew(1)>
</cfif>
	<cfcatch>
		<cfset irongateLog.Code	= ArrayNew(1)>
	</cfcatch>
</cftry>

<cfif val(irongateLog.line) and ArrayLen(irongateLog.Code)>
	<cfset irongateLog.StLine = val(irongateLog.line)-2>
	<cfif irongateLog.StLine lt 1>
		<cfset irongateLog.StLine = 1>
	</cfif>
	<cfset irongateLog.EdLine = irongateLog.line + 2>
	<cfif irongateLog.EdLine gt ArrayLen(irongateLog.Code)>
		<cfset irongateLog.EdLine = ArrayLen(irongateLog.Code)>
	</cfif>
	<cfoutput><cfsavecontent variable="irongateLog.errorCodeLines"><cfloop from="#irongateLog.StLine#" to="#irongateLog.EdLine#" index="irongateLog.i"><pre style="white-space:-moz-pre-wrap; white-space:-pre-wrap; font-family:Verdana; white-space:-o-pre-wrap; white-space:pre-wrap; word-wrap:break-word; padding:0px; margin:0px; font-size:11px">#irongateLog.i# : <cfif irongateLog.i eq irongateLog.line><b>#HTMLEditFormat(irongateLog.Code[irongateLog.i])#</b><cfelse>#HTMLEditFormat(irongateLog.Code[irongateLog.i])#</cfif></pre></cfloop></cfsavecontent></cfoutput>
</cfif>

<!--- ************************************************************** --->
<!--- insert basic error details to the database                     --->
<!--- (If not from developers IP)                                    --->
<!--- ************************************************************** --->
<cfif not len(irongate.homeip) or (len(irongate.homeip) and not listfind(irongate.homeip,cgi.remote_addr))>
<cftry>
	<cftransaction>
	<!--- create error id   --->
	<cfquery name="irongate.i" maxrows="1" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
		select errorid from #irongate.table# where message =
		<cfqueryparam
			value="#left(trim(irongateLog.Message),500)#"
			cfsqltype="CF_SQL_VARCHAR"
			maxlength="500">
		and template = <cfqueryparam
			value="#left(trim(irongateLog.template),200)#"
			cfsqltype="CF_SQL_VARCHAR"
			maxlength="200"> and line = #val(irongateLog.Line)#
	</cfquery>

	<cfif val(irongate.i.errorid)>
		<cfset irongate.Errorid	= val(irongate.i.errorid)>
		<cfswitch expression="#irongate.mailon#">
			<cfcase value="Fresh Exceptions">
				<cfset irongate.MailTo	= ''> <!--- do not mail on repeating errors  --->
			</cfcase>
		</cfswitch>
	<cfelse>
		<cfquery name="irongate.i" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
			select max(errorid)+1 as mxerrorid from #irongate.table#
		</cfquery>
		<cfset irongate.Errorid	= val(irongate.i.mxerrorid)+1>
	</cfif>

	<!--- insert the record --->
	<cfquery datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#" name="irongate.add">
		insert into #irongate.table#
		(line, etime, errorid, code, template,message,type)
		values
		(#val(irongateLog.Line)#,#createODBCdateTime(irongateLog.DateTime)#,#val(irongate.Errorid)#,
		<cfqueryparam
			value="#irongate.Code#"
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
			value="#irongateLog.Type#"
			cfsqltype="CF_SQL_VARCHAR"
			maxlength="20">
			)
	</cfquery>
	</cftransaction>
	<cfcatch></cfcatch>
</cftry>
</cfif>

<cftry>
<cfif len(irongate.homeip) and listfind(irongate.homeip,cgi.remote_addr)>

<!--- ************************************************************** --->
<!--- Mimic ColdFusion Error for Debug IP address                    --->
<!--- ************************************************************** --->
<cfif IsDefined('error.GeneratedContent')><cfoutput>#error.GeneratedContent#</cfoutput></cfif>
<!-- " ---></TD></TD></TD></TH></TH></TH></TR></TR></TR></TABLE></TABLE></TABLE></A></ABBREV></ACRONYM></ADDRESS></APPLET></AU></B></BANNER></BIG></BLINK></BLOCKQUOTE></BQ></CAPTION></CENTER></CITE></CODE></COMMENT></DEL></DFN></DIR></DIV></DL></EM></FIG></FN></FONT></FORM></FRAME></FRAMESET></H1></H2></H3></H4></H5></H6></HEAD></I></INS></KBD></LISTING></MAP></MARQUEE></MENU></MULTICOL></NOBR></NOFRAMES></NOSCRIPT></NOTE></OL></P></PARAM></PERSON></PLAINTEXT></PRE></Q></S></SAMP></SCRIPT></SELECT></SMALL></STRIKE></STRONG></SUB></SUP></TABLE></TD></TEXTAREA></TH></TITLE></TR></TT></U></UL></VAR></WBR></XMP>
<font face="arial"></font><html><head><title>Error Occurred While Processing Request</title></head><body>
<script language="JavaScript">
function showHide(targetName) {
	if( document.getElementById ) { // NS6+
		target = document.getElementById(targetName);
	} else if( document.all ) { // IE4+
		target = document.all[targetName];
	}

	if( target ) {
		if( target.style.display == "none" ) {
			target.style.display = "inline";
		} else {
			target.style.display = "none";
		}
	}
}
</script>
<font style="COLOR: black; FONT: 16pt/18pt verdana">The web site you are accessing has experienced an unexpected error.<br>Please contact the website administrator.</font><br><br>
<div style="COLOR: black; FONT: 8pt/11pt verdana">
<div style="padding:3px; background-color:#E7E7E7; border:1px solid #000808">
<div style="COLOR: white; FONT: 11pt/13pt verdana; padding:4px; background-color:#000066">The following information is meant for the website developer for debugging purposes.</div>
<div style="COLOR: white; FONT: 11pt/13pt verdana; padding:3px; margin-top:4px; margin-bottom:3px; background-color:#4646EE; border:1px solid #000808">Error Occurred While Processing Request</div>
<div style="border:1px solid #000808; padding:3px">
<cfoutput>
<div style="FONT: 13pt/15pt verdana">#replace(irongateLog.Message,'<','&lt;','all')#</div>
<cfif StructKeyExists(irongateLog,'detail') and len(trim(irongateLog.detail))><br/>#irongateLog.detail#<br></cfif>
	<br />The error occurred in <b>#irongateLog.Template#:  Line #irongateLog.line#</b>
<cfif StructKeyExists(irongateLog,'CalledFrom') and len(trim(irongateLog.CalledFrom))>#irongateLog.CalledFrom#</cfif>

<br /><br />#irongateLog.errorCodeLines#
<br /><hr color="##C0C0C0" noshade />

<cfif StructKeyExists(irongateLog,'NativeErrorCode')>
	<div style="width:150px; float:left">VENDORERRORCODE</div><div style="float:left">#irongateLog.NativeErrorCode#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateLog,'ErrorCode') and StructKeyExists(irongateLog,'Sql')>
	<div style="width:150px; float:left">SQLSTATE</div><div style="float:left">#irongateLog.ErrorCode#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateLog,'Sql')>
	<div style="width:150px; float:left">SQL</div><div style="margin-left: 150px;">#irongateLog.Sql#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateLog,'where') and len(irongateLog.where)>
	<div style="width:150px; float:left">SQL Params</div><div style="margin-left: 150px;">#irongateLog.where#</div><div style="clear:both; padding-bottom: 5px;"></div>
	<div style="width:150px; float:left">Generated SQL</div><div style="margin-left: 150px;">#irongate_formatSQL(irongateLog.Sql,irongateLog.where)#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateLog,'DataSource')>
	<div style="width:150px; float:left">DATASOURCE</div><div style="float:left">#irongateLog.DataSource#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
</cfoutput>

	Resources:<br />
	<ul style=" list-style-position: inside; list-style-type: disc;">
	<li>Check the <a href='http://www.macromedia.com/go/proddoc_getdoc' target="new">ColdFusion documentation</a> to verify that you are using the correct syntax.</li>
	<li>Search the <a href='http://www.macromedia.com/support/coldfusion/' target="new">Knowledge Base</a> to find a solution to your problem.</li>
	</ul>
	<cfoutput>
	<div style="float:left; clear:left; width:100px">Browser</div><div style="float:left;"><cfif StructKeyExists(irongateLog,'Browser')>#irongateLog.Browser#</cfif></div><br />
	<div style="float:left; clear:left; width:100px">Remote Address</div><div style="float:left;"><cfif StructKeyExists(irongateLog,'RemoteAddress')>#irongateLog.RemoteAddress#</cfif></div><br />
	<div style="float:left; clear:left; width:100px">Referrer</div><div style="float:left;"><cfif StructKeyExists(irongateLog,'HTTPReferer')>#irongateLog.HTTPReferer#</cfif></div><br />
	<div style="float:left; clear:left; width:100px">Date/Time</div><div style="float:left;"><cfif StructKeyExists(irongateLog,'DateTime')>#dateformat(irongateLog.DateTime,'dd-mmm-yy')# #timeformat(irongateLog.DateTime,'hh:mm:ss tt')#</cfif></div>
	<div style="clear:both"></div><br />
	<cfif len(irongateLog.StackTrace)>
		<a href="javascript:showHide('stackbox')">Stack Trace (click to expand)</a>
		<div id="stackbox" style="display:none">
		<pre style="white-space: -moz-pre-wrap; white-space: -pre-wrap;white-space: -o-pre-wrap;white-space: pre-wrap;word-wrap: break-word;">#irongateLog.StackTrace#</pre>
		</div>
	</cfif>
	&nbsp;
	</div></div></div>
	</cfoutput>
	<font style="font-size:11px; color:#999; font-family:Verdana, Geneva, sans-serif">irongate</font>
<cfelse>
<!--- ************************************************************** --->
<!--- Public see the friendly error message.                         --->
<!--- ************************************************************** --->
	<cfif StructKeyExists(variables,'cferror')>  <!--- don't show if cfcatch --->
		<cfheader statuscode="#irongate.StatusCode#" statustext="#irongateLog.Message#">
		<div id="irongatemsg" style="margin-top:50px; width:600; font-family:Verdana, Geneva, sans-serif; margin-right:auto; margin-left:auto; ">
			<div align="center" style="background:#f1ceab; padding:10px; font-size:16px; color:#dd5600; font-weight:bold; text-shadow: 0px -1px 1px rgba(255, 255, 255, 0.66); -moz-border-top-left-radius: 6px; -webkit-border-top-left-radius: 6px; -khtml-border-top-left-radius: 6px; border-top-left-radius: 6px; -moz-border-top-right-radius: 6px; -webkit-border-top-right-radius: 6px; -khtml-border-top-right-radius: 6px; border-top-right-radius: 6px;">
			<cfoutput>#irongate.title#</cfoutput>
			</div>
			<div style="background-color:#f26522; color:#FFF; padding:20px; font-size:14px; text-align:center; text-shadow: 0px -1px 1px rgba(66, 66, 66, 0.46); -moz-border-bottom-right-radius: 6px; -webkit-border-bottom-right-radius: 6px; -khtml-border-bottom-right-radius: 6px; border-bottom-right-radius: 6px; -moz-border-bottom-left-radius: 6px; -webkit-border-bottom-left-radius: 6px; -khtml-border-bottom-left-radius: 6px; border-bottom-left-radius: 6px;">
			<cfoutput>#irongate.desc#</cfoutput>
			</div>
		</div>
		<script type="text/javascript">
		document.getElementById("irongatemsg").style.marginTop= (window.innerHeight/2) - document.getElementById('irongatemsg').offsetHeight;
		</script>
	</cfif>

<!--- ************************************************************** --->
<!--- Send Email Notification                                        --->
<!--- ************************************************************** --->
	<cftry>
	<cfif len(irongate.MailTo)>
		<cfif len(irongate.MailServer)>
			<cfmail
				to		= "#irongate.MailTo#"
				from	= "#irongate.MailForm#"
				subject	= "#irongate.MailSubject#"
				type	= "html"
				server	= "#irongate.MailServer#"
				username= "#irongate.MailUser#"
				password= "#irongate.MailPassword#"
				port	= "#irongate.MailPort#">
				<br /><a href="#irongate.AdminURL#/index.cfm?action=incidence&errorid=#irongate.Errorid#">Irongate noticed an exception in your website.</a><br /><br />
				<cfif StructKeyExists(irongateLog,'Message')>Message : <font face="Courier New, Courier, monospace">#irongateLog.Message#</font><br /></cfif>
				<cfif StructKeyExists(irongateLog,'Template')>Template : <font face="Courier New, Courier, monospace">#irongateLog.Template#<br /></font></cfif>
				<cfif StructKeyExists(irongateLog,'DateTime')>Time : <font face="Courier New, Courier, monospace">#dateformat(irongateLog.DateTime,'dddd, mmmm dd yyyy')# #timeformat(irongateLog.DateTime,'hh:mm ss l TT')#</font><br /></cfif>
				<cfif StructKeyExists(irongateLog,'Detail') and len(irongateLog.Detail)>Detail : <font face="Courier New, Courier, monospace">#irongateLog.Detail#<br /></font></cfif>
			</cfmail>
		<cfelse>
			<cfmail
				to		= "#irongate.MailTo#"
				from	= "#irongate.MailForm#"
				subject	= "#irongate.MailSubject#"
				type	= "html">
				<br /><a href="#irongate.AdminURL#/index.cfm?action=incidence&errorid=#irongate.Errorid#">Irongate noticed an exception in your website.</a><br /><br />
				<cfif StructKeyExists(irongateLog,'Message')>Message : <font face="Courier New, Courier, monospace">#irongateLog.Message#</font><br /></cfif>
				<cfif StructKeyExists(irongateLog,'Template')>Template : <font face="Courier New, Courier, monospace">#irongateLog.Template#<br /></font></cfif>
				<cfif StructKeyExists(irongateLog,'DateTime')>Time : <font face="Courier New, Courier, monospace">#dateformat(irongateLog.DateTime,'dddd, mmmm dd yyyy')# #timeformat(irongateLog.DateTime,'hh:mm ss l TT')#</font><br /></cfif>
				<cfif StructKeyExists(irongateLog,'Detail') and len(irongateLog.Detail)>Detail : <font face="Courier New, Courier, monospace">#irongateLog.Detail#<br /></font></cfif>
			</cfmail>
		</cfif>
	</cfif>
		<cfcatch></cfcatch>
	</cftry>

</cfif>
	<cfcatch></cfcatch>
</cftry>

<!--- ************************************************************** --->
<!--- Take Snapshot of the code                                      --->
<!--- ************************************************************** --->
<cfif YesNoFormat(irongate.LogPage)>
	<cftry>
		<cffile
			action 	= "write"
			file 	= "#irongate.LogFolder#/pages/#irongate.Code#.cfm"
			output 	= "<cfabort />#irongate_gzip(ArrayToList(irongateLog.Code,chr(10)) )#">
		<cfcatch></cfcatch>
	</cftry>
	<cfset StructDelete(irongateLog,'Code')>
</cfif>

<!--- ************************************************************** --->
<!--- Save Variables                                                 --->
<!--- ************************************************************** --->
<cfif YesNoFormat(irongate.LogVariables)>
	<cfset irongateBox 						= StructNew()>
	<cfset irongateBox.vari.irongateLog  	= irongateLog>

	<!--- Variable Tracking --->
	<cfloop collection="#variables#" item="irongate.i">
	<cftry>
		<cfif not listfindnocase(irongate.ignoreVariables,irongate.i)>
			<cfif IsQuery(variables[irongate.i])>
				<cfif val(irongate.QueryRecNum)>
					<cfquery name="irongateBox.query.variables.#irongate.i#" dbtype="query" maxrows="#irongate.QueryRecNum#">
						select * from #irongate.i#
					</cfquery>
				<cfelse>
					<cfset SetVariable("irongateBox.query.variables.#irongate.i#",variables[irongate.i])>
				</cfif>
				<cfset SetVariable("irongateBox.vari.#irongate.i#",'[Query]')>
			<cfelse>
				<cfset SetVariable("irongateBox.vari.#irongate.i#",variables[irongate.i])>
			</cfif>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
	</cfloop>
	<!--- Session Tracking --->
	<cftry>
		<cfloop collection="#session#" item="irongate.i">
			<cfif not listfindnocase(irongate.ignoreVariables,irongate.i)>
				<cfset SetVariable("irongateBox.session.#irongate.i#",duplicate(session[irongate.i]))>
			</cfif>
		</cfloop>
		<cfcatch></cfcatch>
	</cftry>
	<!--- Request Tracking --->
	<cfloop collection="#request#" item="irongate.i">
	<cftry>
		<cfif not listfindnocase(irongate.ignoreVariables,irongate.i)>
			<cfif IsQuery(variables[irongate.i])>
				<cfif val(irongate.QueryRecNum)>
					<cfquery name="irongateBox.query.request.#irongate.i#" dbtype="query" maxrows="#irongate.QueryRecNum#">
						select * from #irongate.i#
					</cfquery>
				<cfelse>
					<cfset SetVariable("irongateBox.query.request.#irongate.i#",request[irongate.i])>
				</cfif>
				<cfset SetVariable("irongateBox.request.#irongate.i#",'[Query]')>
			<cfelse>
				<cfset SetVariable("irongateBox.request.#irongate.i#",request[irongate.i])>
			</cfif>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
	</cfloop>

	<cftry>
		<cfif IsDefined('CGI')>
			<cfset irongateBox.cgi	= cgi>
		</cfif>
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfif IsDefined('URL')>
			<cfset irongateBox.url	= url>
		</cfif>
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfif IsDefined('form')>
			<cfset irongateBox.form	= form>
		</cfif>
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfif IsDefined('cookie')>
			<cfset irongateBox.cookie	= duplicate(cookie)>
		</cfif>
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfif YesNoFormat(irongate.metricData)>
			<cfset irongateBox.ServerData.metricData	= GetMetricData('perf_monitor')>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
	<cftry>
		<cfif YesNoFormat(irongate.memorystat)>
			<cfset irongate.mData						= CreateObject("java","java.lang.Runtime").getRuntime()>
			<cfset irongateBox.ServerData.memory.free	= irongate.mData.freeMemory()>
			<cfset irongateBox.ServerData.memory.total	= irongate.mData.totalMemory()>
			<cfset irongateBox.ServerData.memory.maxm	= irongate.mData.maxMemory()>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
	<cfloop collection="#irongateBox#" item="irongate.i">
		<cfset irongate_wddxsafe('irongateBox',irongate.i,irongateBox[irongate.i])>
	</cfloop>
	<cfwddx action="cfml2wddx" input="#irongateBox#" output="irongate.wddx">
	<cftry>
		<cffile
			action 		= "write"
			file 		= "#irongate.LogFolder#/variables/#irongate.Code#.cfm"
			output 		= "<cfabort />#irongate_gzip(irongate.wddx)#">
		<cfcatch></cfcatch>
	</cftry>
</cfif>

<!--- ************************************************************** --->
<!--- Helpers                                                        --->
<!--- ************************************************************** --->

<!--- http://www.cflib.org/udf/gzip --->
<cffunction name="irongate_gzip"
    returntype	="any"
    displayname	="gzip"
    hint		="compresses a string using the gzip algorithm; returns binary or string(base64|hex|uu)"
    output		="no">
	<cfargument name="string" 	required="no" 	type="string" default="">
	<cfargument name="encode" 	required="no" 	type="string" default="base64">

	<cfif YesNoFormat(irongate.compress)>
		<cftry>
			<cfset local					= StructNew()>
			<cfset local.text				= createObject("java","java.lang.String").init(arguments.string)>
			<cfset local.dataStream			= createObject("java","java.io.ByteArrayOutputStream").init()>
			<cfset local.compressDataStream	= createObject("java","java.util.zip.GZIPOutputStream").init(local.dataStream)>
			<cfset local.compressDataStream.write(local.text.getBytes())>
			<cfset local.compressDataStream.finish()>
			<cfset local.compressDataStream.close()>
			<cfset irongate.i				= local.dataStream.toByteArray()>
			<cfset StructDelete(variables,'local')>
			<cfreturn binaryEncode(irongate.i,arguments.encode)>
			<cfcatch>
				<cfreturn arguments.string>
			</cfcatch>
		</cftry>
	<cfelse>
		<cfreturn cfusion_encrypt(arguments.string,irongate.Code)>
	</cfif>
</cffunction>

<!--- cfwddx does not work same across all server versions   --->
<cffunction name= "irongate_wddxsafe"
    returntype	= "any"
    hint		= "Remove CFWDDX unsafe data from data structure"
    output		= "Yes">
	<cfargument name="root"		required="Yes" 	type="any" default="">
	<cfargument name="name" 	required="Yes" 	type="any" default="">
	<cfargument name="value" 	required="Yes" 	type="any" default="">

	<cfset local = StructNew()>
	<cftry>
		<!--- isXML() fail on a structure / workaround needed--->
		<cfset local.thisxml	= isXML(value)>
		<cfcatch><cfset local.thisxml	= 'No'></cfcatch>
	</cftry>
	<cfif YesNoFormat(local.thisxml)>
		<cfset SetVariable("#arguments.root#.#arguments.name#",ToString(arguments.value))>
	<cfelseif StructKeyExists(GetFunctionList(),'IsImage') and IsImage(arguments.value)>
		<cfset SetVariable("#arguments.root#.#arguments.name#",ImageInfo(arguments.value))>
	<cfelseif StructKeyExists(GetFunctionList(),'IsPDFObject') and IsPDFObject(arguments.value)>
		<cftry>
		<cfset SetVariable("#arguments.root#.#arguments.name#",getMetaData(arguments.value))>
			<cfcatch>
				<cfset SetVariable("#arguments.root#.#arguments.name#",'[PDF Object]')>
			</cfcatch>
		</cftry>
	<cfelseif IsObject(arguments.value) or IsCustomFunction(arguments.value)>
		<cfset SetVariable("#arguments.root#.#arguments.name#",getMetaData(arguments.value))>
	<cfelseif IsBinary(arguments.value)>
		<cfset SetVariable("#arguments.root#.#arguments.name#",'[Binary Object]')>
	<cfelseif IsStruct(arguments.value) and val(StructCount(arguments.value))>
		<!--- go in the next level and validate variables --->
		<cfloop collection="#arguments.value#" item="local.i">
			<cfset irongate_wddxsafe('#arguments.root#.#arguments.name#',local.i,arguments.value[local.i])>
		</cfloop>
	</cfif>
	<cfset StructDelete(variables,'local')>
</cffunction>

<!--- takes the sql statement and the cfqueryparams and generates a sql statement that can be cut and pasted into a query editor.(Credit: Lamp, Ed) --->
<cffunction name="irongate_formatSQL"   returntype	= "string"  hint= "I take a sql queru and params and merge the 2"   output= "NO">
	<cfargument name="SQL"		required="Yes" 	type="string" default="">
	<cfargument name="Params" 	required="Yes" 	type="string" default="">
    <cfset local.count= 1>
    <cfset local.localSQL 	= arguments.Sql>
    <!--- loop over params - treat as a list --->
    <cfloop list="#arguments.Params#" index="local.j" delimiters="]">
    	<!--- find the value --->
        <cfset local.st		= ReFindNoCase("value=\'([^\']*)\'",local.j, 1, "True")>
        <!--- make sure the regex found a value --->
        <cfif local.st.Pos[1] NEQ 0>
        	<!--- grab the value --->
            <cfset local.val		= mid(local.j,local.st.Pos[2],local.st.len[2])>
            <!--- if not a number than put single quotes arount it --->
            <cfif not IsNumeric(local.val)>
            	<cfset local.val	= "'#local.val#'">
            </cfif>
            <!--- replace the placeholder in the sql statement with the actual value --->
        	<cfset local.localSQL 	= replacenoCase(local.localSQL, "(param #local.count#)", local.val )>
        </cfif>
        <cfset local.count	= local.count + 1>
    </cfloop>

	<cfreturn local.localSQL >
	<cfset StructDelete(variables,'local')>
</cffunction>

<cfset StructDelete(variables,'irongate_formatSQL')>
<cfset StructDelete(variables,'irongate_wddxsafe')>
<cfset StructDelete(variables,'irongate_gzip')>