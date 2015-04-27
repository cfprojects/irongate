<cfprocessingdirective pageencoding="utf-8">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="css/style.css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<script type='text/javascript' src='js/jquery/jquery.js'></script>
<script type='text/javascript' src='js/jquery/jquery.tipsy.js'></script>
<script type='text/javascript' src='js/ork.js'></script>
<title>irongate : control</title>
</head><body>
<div id="alertbox"><table onclick="hidealertbox()" cellpadding="0" cellspacing="0" border="0"><tr><td width="5"><img src="images/alrtlft.gif" /></td><td class="alertboxmsg"></td><td width="5"><img src="images/alrtrite.gif" /></td></tr></table></div>
<cfif StructKeyExists(session,'msg') and not StructKeyExists(session,'error')>
<script type="text/javascript">
	$("document").ready(function() { setTimeout('showmsg("<cfoutput>#session.msg#</cfoutput>")', 1000);  })
	<cfset StructDelete(session, "msg")>
</script>
</cfif>

<cfif StructKeyExists(session,'error')>
<script type="text/javascript">
	$("document").ready(function() { setTimeout('showerror("<cfoutput>#session.error#</cfoutput>")', 1000) })
	<cfset StructDelete(session, "error")>
</script>
</cfif>

<div id="fullbox">
<cfif YesNoFormat(url.header)>
	<cfset headerdislpay = "block">
<cfelse>
	<cfset headerdislpay = "none">
</cfif>

<div id="header" style="display:<cfoutput>#headerdislpay#</cfoutput>"><a href="index.cfm"><img src="images/irongate.png" style="float:left" title="irongate : control" border="0" /></a>

<div class="header">
	<a id="implink" href="javascript:">import</a>
	<a href="index.cfm?action=settings">settings</a>
	<a href="login.cfm?path=logout">logout</a>
</div>
<div style="clear:both"></div>
</div>

<!--- import --->
<div id="imp">
<img src="images/close_box.gif" align="right" id="impclose" style="cursor:pointer" />
<form style="clear:both; padding-left:10px" enctype="multipart/form-data" action="index.cfm?action=import" method="post">
<input type="file" size="10" name="file" class="text" /> <input type="submit" style="margin-left:20px" class="btn btn-mini" value="Import" />
</form>
</div>
<script type="text/javascript">
$(document).ready(function(e) {
	$('#impclose').click(function(e) {
		$('#imp').slideUp('fast')
	});
	$('#implink').click(function(e) {
		$('#imp').slideDown('slow')
	});
});
</script>