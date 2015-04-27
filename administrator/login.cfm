<cfimport 
	taglib =	"system/ct"  
	prefix =	"ct">
<!--- ************************************************************ --->
<!--- Login/logout Page. Completly seperate from the rest.         --->
<!--- ************************************************************ --->
<cfinclude template="system/defaults.cfm">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css"/>
<style type="text/css">
body							{font-size:11px; color:#333333; font-family:Verdana, Geneva, sans-serif; font-size:11px}
#errmsg							{display:inline-block; background-image:url(images/rdbg.gif); margin-bottom:10px; color:#FFF; font-weight:bold; height:30px; background-color:#ED1E1E;}
.form-horizontal input			{font-size:12px; height:20px; line-height:normal}
.form-horizontal				{padding-top:10px; padding-bottom:10px;}
.form-horizontal .control-group	{margin-bottom:5px}
.control-group .control-label, .control-group .checkbox	{text-align:left; padding-left:10px; font-size:12px}
.control-group .checkbox		{padding-left:20px}
.form-horizontal .control-label	{width:140px}
.form-horizontal .controls		{margin-left:160px}
</style>
<title>Irongate : Please Login</title>
</head><body>

<cfparam name="form.username" 	default="">
<cfparam name="form.password" 	default="">
<cfparam name="url.path"		default="">
<cfparam name="url.r"			default="">

<!--- ************************************************************ --->
<!--- Logout                                                       --->
<!--- ************************************************************ --->
<cfswitch expression="#url.path#">
	<cfcase value="logout">
		<cfcookie expires="now" name="Irongate_login">
	</cfcase>
</cfswitch>

<cfif len(form.username) and len(form.password)>
<!--- ************************************************************ --->
<!--- Login Action                                                 --->
<!--- ************************************************************ --->
	
	<!--- Feel free to replace authentication with your own login function --->
	<cfinclude template="login_details.cfm">

	<cfif trim(form.username) eq trim(irongate.username) and trim(form.password) eq trim(irongate.password)>
		<cfcookie value="#hash(irongate.username)##hash(irongate.password)#" name="irongate_login" />
		<cfset session.login_fail 		= 0>
		
		<cfif len(url.r)>
			 <cfheader statuscode="302" statustext="Object Temporarily Moved">
			 <cfheader name="location" value="index.cfm?#cfusion_decrypt(url.r,'Irongate')#">
		<cfelse>
			 <cfheader statuscode="302" statustext="Object Temporarily Moved">
			 <cfheader name="location" value="index.cfm">
		</cfif>
		
	<cfelse>
		<cfparam name="session.login_fail" default="0">
		<cfif val(session.login_fail) gte 10>
			<cfset session.error	= "Maximum retry limit exceeded. Session Locked.">
		<cfelse>
			<cfset session.login_fail = session.login_fail + 1>
			<cfif val(session.login_fail)>
				<cfset session.error	= "Username or Password is wrong. [#session.login_fail# of 10 Retry]">
			</cfif>
		</cfif>	
	</cfif>
</cfif>

<!--- ************************************************************ --->
<!--- Login Form                                                   --->
<!--- ************************************************************ --->

<div style="vertical-align:middle; height:100%; width:100%;" align="center">
<div style="position: absolute; left:0px; width:100%; top: 30%; vertical-align: middle; ">
<ct:msg>
<div style="background-color:#F0F0F0; border-bottom:1px solid #CCC; background-image:url(images/loginlinebg.png); background-repeat:repeat-x; background-position:0px 43px">

<div style="text-align:right"><a href="http://www.cflove.org"><img src="images/cflove.png" title="Help" style="float:right" align="absmiddle" border="0" /></a></div>
<div style="background-color:#CCC"><div style="width:330px; text-align:left; margin-left:auto; margin-right:auto;"><img src="images/login_irongate.png" align="absmiddle" /></div></div>
<div style="width:350px; padding:5px; text-align:left; margin-left:auto; margin-right:auto;">
<cfform class="form-horizontal" action="login.cfm?r=#url.r#" method="post">
	<div class="control-group">
		<label class="control-label">User Name</label>
		<div class="controls">
		<cfinput type="text" name="UserName" class="input-large" value="#form.UserName#" required="yes" message="Please Enter User name">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Password</label>
		<div class="controls">
		<cfinput type="password" name="Password" class="input-large" value="#form.Password#" required="yes" message="Please Enter Password">
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
		<button class="btn btn-inverse btn-small" type="submit">Login</button>
		</div>
	</div>
</cfform>
</div>

</div>
<div style="background:url(images/loginbgline.png); background-repeat:repeat-x; background-position:top"><img src="images/sdow_btm_lft.png" align="left" /><img src="images/sdow_btm_rite.png" align="right" /><div style="clear:both"></div></div>
</div>
</div>
</body>
</html>