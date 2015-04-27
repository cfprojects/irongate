<div class="bluebox">

<div class="formblock">

<cfform id="formfield" action="index.cfm?action=2" method="post">
<cfif FileExists(settingfile)>
<cffile action="read" file="#settingfile#" variable="set" charset="utf-8">
<cfset set	= replace(set,chr(10),' #chr(10)#','all')>

<div class="accordinghead">Page 1 of 3</div>

<!--- aditional information for Unix Users --->
<cfif server.OS.Name eq 'Unix'>
	<div class="alert alert-block" style="margin-top:10px;">
	<strong>Following files and folders required Read and Write Access:</strong> (<a href="http://en.wikipedia.org/wiki/Chmod" target="_blank">chomd 666</a>) <br /><br />
		Files:<br />
		- Irongate.cfm<br />
		- index.cfm<br />
		- administrator/settings.cfm<br />
		- administrator/login_details.cfm<br /><br />

		Folders:<br />
		- logs/pages<br />
		- logs/variables<br /><br />

		Please provided required access permission before continue.
	</div>
</cfif>

<cfset box 	= 0>
<cfset line = 1>
<cfloop from="1" to="60" index="c">
<cfset i = trim(listgetat(set,c,chr(10)))>
	<cfoutput>
	<cfif left(i,2) eq '<!'>
		<!--- hint from the comment line ---->
		<div class="settingitem">
		#rereplace(listfirst(i,'['),'<!---|--->',"",'all')#
		<cfif listlen(i,'[]') gt 2>
			<cfset options = listgetat(i,2,'[]')>
		<cfelse>
			<cfset options = "">
		</cfif>
	<cfelseif left(i,7) eq '<cfset '>
		<!--- value form cfset tag --->
			<cfset value = trim ( right(i, len(i) - (find('= "',i)+2) ) )>
			<cfif len(value) gt 2>
				<cfset value = left(value,len(value)-2)>
			<cfelse>
				<cfset value = ''>			
			</cfif>
			<cfset value = replace(value,'""','"','all')>
			<div style="padding-left:20px; padding-top:5px">
			<cfif listlen(options)>
				<cfif listlen(options) lte 3>
					<cfset ocount = 1>
					<cfloop list="#options#" index="o">
						<input type="radio" name="filed_#line#" <cfif value eq listfirst(o,'-')>checked="checked"</cfif> value="#listfirst(o,'-')#" id="filed_#line##ocount#_f" /> <label class="inline radio" for="filed_#line##ocount#_f">#listlast(o,'-')#</label>
						<cfset ocount = 1+ocount>
					</cfloop>
				<cfelse>
					<select id="filed_#line#" name="filed_#line#" class="input">
					<cfloop list="#options#" index="o"><option <cfif value eq listfirst(o,'-')>selected="selected"</cfif> value="#listfirst(o,'-')#">#listlast(o,'-')#</option></cfloop>
					</select>
				</cfif>
			<cfelse>
				<cfinput type="text" class="text" onKeyUp="textSize(this.id)" value="#value#" style="width:500px" name="filed_#line#" id="filed_#line#" /><br />
			</cfif>
		</div></div>
	</cfif>
	</cfoutput>
<cfset line = 1+line>
</cfloop>

<cfelse>
	<strong>Installation failed.</strong>
	<br /><br />file not found <cfoutput>#settingfile#</cfoutput>
</cfif>

	<div style="padding-left:100px; padding-top:10px">
		<input title="Click Here to Save" class="btn btn-inverse btn-small" type="submit" value="Continue" name="submit" />
	</div>
</div>
</cfform>
</div><br />
<br />

<script type="text/javascript">
function textSize(i) {
	var l = $('#'+i).val().length
	if (l < 100) {
		if ( $('#'+i).attr('type') !== 'text' ) {
			$('#'+i).parent().html('<input type="text" class="text" onKeyUp="textSize(this.id)" value="'+$('#'+i).val()+'" name="'+i+'" id="'+i+'" />')	
		}
	}
	
	if (l < 5) {
		$('#'+i).animate({'width':'60px','min-width':'60px'}, 500 )
	} else if (l < 20) {
		$('#'+i).animate({'width':'250px','min-width':'250px'}, 500 )
	} else if (l < 100) {
		$('#'+i).animate({'width':'500px','min-width':'500px'}, 500 )
	} else {
		if ( $('#'+i).attr('type') == 'text' ) {
			$('#'+i).parent().html('<textarea class="text" style="width:99%; height:70px" name="'+i+'" id="'+i+'" onKeyUp="textSize(this.id)">'+$('#'+i).val()+'</textarea>')
		}
	}
}
$("document").ready(function() {
	/////////////////////////////
	var logfile = $('.settingitem:contains("Log file storage folder")').children().children('input')
	if ( !$(logfile).val()) {
		$(logfile).val("<cfoutput>#JSStringFormat(ExpandPath('..\logs'))#</cfoutput>")
	}
	/////////////////////////////
	var ipaddress = $('.settingitem:contains("Debug IP Address list")').children().children('input')
	if ( !$(ipaddress).val()) {
		$(ipaddress).val("<cfoutput>#JSStringFormat(cgi.REMOTE_ADDR)#</cfoutput>")
	}
	/////////////////////////////
	<cftry>
	<cfif StructKeyExists(application,'ds')>
		<cfset temp_dsn = Application.ds>
	<cfelseif StructKeyExists(application,'dsn')>
		<cfset temp_dsn = Application.dsn>
	<cfelseif StructKeyExists(application,'datasource')>
		<cfset temp_dsn = Application.datasource>
	</cfif>
	<cfif StructKeyExists(variables,'temp_dsn')>
	var dsn = $('.settingitem:contains("Data Source Name ")').children().children('input')
	if ( !$(dsn).val()) {
		$(dsn).val("<cfoutput>#JSStringFormat(temp_dsn)#</cfoutput>")
	}
	</cfif>
		<cfcatch></cfcatch>
	</cftry>	
	/////////////////////////////
	<cftry>
	<cfset adminpath 	= "http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#">
	<cfset adminpath	= ListDeleteAt(adminpath,listlen(adminpath,'\/'),'\/')>
	<cfset adminpath	= ListDeleteAt(adminpath,listlen(adminpath,'\/'),'\/')>
	<cfset adminpath	= "#adminpath#/administrator">
	var adminurl = $('.settingitem:contains("Admin URL")').children().children('input')
	if ( !$(adminurl).val()) {
		$(adminurl).val("<cfoutput>#JSStringFormat(adminpath)#</cfoutput>")
	}
		<cfcatch></cfcatch>
	</cftry>
	<cfif FindNoCase('railo',server.ColdFusion.ProductName)>
	$('.settingitem:contains("Log Server Metric Data")').css('display','none').children().children('input[value="No"]').attr("checked","checked")
	</cfif>
	<cftry>
		<cfset CreateObject("java","java.lang.Runtime").getRuntime()>
		<cfcatch>
		$('.settingitem:contains("Log Server Memory States")').css('display','none').children().children('input[value="No"]').attr("checked","checked")
		</cfcatch>
	</cftry>
	$("input[type=text]").trigger('keyup');
	// form submit validation
	$('#formfield').submit(function() {
		////////////////////////////
		var Datasource = $('.settingitem:contains("Data Source Name")').children().children('input')
		if (!$(Datasource).val() ) {
			alert('Datasource Name is Required')
			return false	
		}
		///////////////////////////
		if (!$(logfile).val() ) {
			alert('Log file Path is required')
			return false	
		}
	})
})
</script>