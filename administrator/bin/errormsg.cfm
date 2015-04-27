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
<cftry>
<div style="FONT: 13pt/15pt verdana">#replace(irongateXML.vari.irongateLog.Message,'<','&lt;','all')#</div> 
<cfif StructKeyExists(irongateXML.vari.irongateLog,'detail') and len(trim(irongateXML.vari.irongateLog.detail))><br/>#irongateXML.vari.irongateLog.detail#<br></cfif>
	<br />The error occurred in <b>#irongateXML.vari.irongateLog.Template#:  Line #irongateXML.vari.irongateLog.line#</b> 
<cfif StructKeyExists(irongateXML.vari.irongateLog,'CalledFrom') and len(trim(irongateXML.vari.irongateLog.CalledFrom))>#irongateXML.vari.irongateLog.CalledFrom#</cfif>

<cfif StructKeyExists(irongateXML.vari.irongateLog,'errorCodeLines')><br /><br />#irongateXML.vari.irongateLog.errorCodeLines#</cfif>
<br /><hr color="##C0C0C0" noshade />

<cfif StructKeyExists(irongateXML.vari.irongateLog,'NativeErrorCode')>
	<div style="width:150px; float:left">VENDORERRORCODE</div><div style="float:left">#irongateXML.vari.irongateLog.NativeErrorCode#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateXML.vari.irongateLog,'ErrorCode') and StructKeyExists(irongateXML.vari.irongateLog,'Sql')>
	<div style="width:150px; float:left">SQLSTATE</div><div style="float:left">#irongateXML.vari.irongateLog.ErrorCode#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateXML.vari.irongateLog,'Sql')>
	<div style="width:150px; float:left">SQL</div><div style="float:left">#irongateXML.vari.irongateLog.Sql#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateXML.vari.irongateLog,'where') and len(irongateXML.vari.irongateLog.where)>   
	<div style="width:150px; float:left">SQL Params</div><div style="margin-left: 150px;">#irongateXML.vari.irongateLog.where#</div><div style="clear:both; padding-bottom: 5px;"></div>
	<div style="width:150px; float:left">Generated SQL</div><div style="margin-left: 150px;">#irongate_formatSQL(irongateXML.vari.irongateLog.Sql,irongateXML.vari.irongateLog.where)#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>
<cfif StructKeyExists(irongateXML.vari.irongateLog,'DataSource')>
	<div style="width:150px; float:left">DATASOURCE</div><div style="float:left">#irongateXML.vari.irongateLog.DataSource#</div><div style="clear:both; padding-bottom: 5px;"></div>
</cfif>

Resources:<br />
<ul style=" list-style-position: inside; list-style-type: disc;">
<li>Check the <a href='http://www.macromedia.com/go/proddoc_getdoc' target="new">ColdFusion documentation</a> to verify that you are using the correct syntax.</li>
<li>Search the <a href='http://www.macromedia.com/support/coldfusion/' target="new">Knowledge Base</a> to find a solution to your problem.</li>
</ul>

<div style="float:left; clear:left; width:100px">Browser</div><div style="float:left;"><cfif StructKeyExists(irongateXML.vari.irongateLog,'Browser')>#irongateXML.vari.irongateLog.Browser#</cfif></div><br />
<div style="float:left; clear:left; width:100px">Remote Address</div><div style="float:left;"><cfif StructKeyExists(irongateXML.vari.irongateLog,'RemoteAddress')>#irongateXML.vari.irongateLog.RemoteAddress#</cfif></div><br />
<div style="float:left; clear:left; width:100px">Referrer</div><div style="float:left;"><cfif StructKeyExists(irongateXML.vari.irongateLog,'HTTPReferer')>#irongateXML.vari.irongateLog.HTTPReferer#</cfif></div><br />
<div style="float:left; clear:left; width:100px">Date/Time</div><div style="float:left;"><cfif StructKeyExists(irongateXML.vari.irongateLog,'DateTime')>#dateformat(irongateXML.vari.irongateLog.DateTime,'dd-mmm-yy')# #timeformat(irongateXML.vari.irongateLog.DateTime,'hh:mm:ss tt')#</cfif></div>
<div style="clear:both"></div><br />
<cfif len(irongateXML.vari.irongateLog.StackTrace)>
	<a href="javascript:showHide('stackbox')">Stack Trace (click to expand)</a>
	<div id="stackbox" style="display:none">
	<pre style="white-space: -moz-pre-wrap; white-space: -pre-wrap;white-space: -o-pre-wrap;white-space: pre-wrap;word-wrap: break-word;">#irongateXML.vari.irongateLog.StackTrace#</pre>
	</div> 
</cfif>
	<cfcatch></div></cfcatch>
</cftry>
</cfoutput>
&nbsp;
</div></div></div>

<!--- takes the sql statement and the cfqueryparams and generates a sql statement that can be cut and pasted into a query editor.(Credit: Lamp, Ed) --->
<cffunction name="irongate_formatSQL"   returntype = "string"  hint= "I take a sql queru and params and merge the 2"   output= "NO">
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