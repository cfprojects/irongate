<cfparam name="url.d" default="">

<!--- ****************************************************** --->
<!--- Validate DS and Find Database Type                     --->
<!--- ****************************************************** --->
<cfif listfirst(server.coldfusion.productversion) gte 8>
	<cftry>
		<cf_dbinfo datasource="#cfusion_decrypt(url.d,settingfile)#">
		<cfcatch>
			<div style="color:#FFF; margin-left:40px; margin-right:40px; font-weight:bold; margin-top:20px; padding:10px; background-color:#ED1E1E; -moz-border-radius: 10px;-webkit-border-radius: 5px; border-radius:5px; -khtml-border-radius: 5px;"> &nbsp; Hint: <cfoutput>#cfcatch.Message#</cfoutput>&nbsp; </div>
			<cfset dbinfo.DATABASE_PRODUCTNAME	= 'Other'>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset dbinfo.DATABASE_PRODUCTNAME	= ''>
</cfif>

<div class="bluebox">
<div class="formblock">
<cfform id="formfield" action="index.cfm?action=4" method="post">
<div class="accordinghead">Page 2 of 3</div>

<cfif listfirst(server.coldfusion.productversion) gte 10>
	<!--- *********************************************************** --->
	<!--- CF 10 table creation warning                                --->
	<!--- *********************************************************** --->
	<div id="tablewarming" style="padding:10px; display:none; margin:10px; background-color:#E7F4DD; border-radius: 5px; -moz-border-radius: 5px; -webkit-border-radius: 5px;">
		Your server seems to be running on ColdFusion <cfoutput>#listfirst(server.coldfusion.productversion)#</cfoutput> and in this CF version 
		"Create Table" SQL statement is not allowed by default. 
		Irongate really like to get the table ready.<br /><br />
		Could you please allow "Create Table" SQL in your DSN if it not already enabled? You can always set it back once the installation complete.<br /><br />
		You can also <a target="_blank" id="downloadlink" href="">download Create Table SQL scripts here</a> and create tables manually before click on the "Continue" button.
	</div>
	<script type="text/javascript">
		$(document).ready(function(e) {
			$('input:radio[name=dbtype]').click(function(e) {
				$('#tablewarming').slideDown('slow')
				$('#downloadlink').attr('href','./'+$(this).val()+'.txt')
			});
		});
	</script>
</cfif>

<cfif len(url.d)>
	<div class="settingitem">
	Database Type
	<br />
	<cfoutput><input type="hidden" name="d" value="#url.d#" /><input type="hidden" name="u" value="#url.u#" /><input type="hidden" name="p" value="#url.p#" /></cfoutput>
	<div style="padding-left:20px; padding-top:5px">
	<input type="radio" value="mssql" name="dbtype" id="mssql"/>  <label class="inline radio" for="mssql">MS SQL</label> 
	<input type="radio" value="mysql" name="dbtype" id="mysql" />  <label class="inline radio" for="mysql">My SQL</label>
	<input type="radio" value="pssql" name="dbtype" id="pssql" />  <label class="inline radio" for="pssql">PostgreSQL</label>
	<input type="radio" value="skip" name="dbtype" id="skip" />  <label class="inline radio" for="skip">Skip Table Creation</label>
	</div>	
	</div>
	
	<div class="settingitem">
	<strong>Create New Irongate Login</strong>
	<br /><br />
	User Name <input type="text" style="width:100px" name="username" id="username" value="Admin" class="text" />
	Password <input type="text" style="width:100px" name="password" id="password" class="text" />
	</div>
	
	<div style="padding-left:100px; padding-top:10px">
		<input title="Click Here to Save" class="btn btn-inverse btn-small" type="submit" value="Continue" name="submit" />
	</div>
<cfelse>
	<strong>Installation failed.</strong>
	<br /><br />Missing DSN Name
</cfif>
</div>
</cfform>

</div>
<script type="text/javascript">
$('#formfield').submit(function() {
	if ( !$('input:radio[name=dbtype]:checked').length ) {
		alert("Please Select Database Type")
		return false
	}
	if ( !$('#password').val() ) {
		alert("Enter Administrator Login Password")
		return false
	}
})
$(document).ready(function() {
switch('<cfoutput>#dbinfo.DATABASE_PRODUCTNAME#</cfoutput>')
{
case 'Microsoft SQL Server':
  $('input[value=mssql]').not('[checked=checked]').attr('checked','checked').trigger('click')
  break;
case 'PostgreSQL':
  $('input[value=pssql]').not('[checked=checked]').attr('checked','checked').trigger('click')
  break;
case 'MySQL':
  $('input[value=mysql]').not('[checked=checked]').attr('checked','checked').trigger('click')
  break;
case 'Other':
  $('input[value=skip]').not('[checked=checked]').attr('checked','checked').trigger('click')
  break;
}

})
</script>