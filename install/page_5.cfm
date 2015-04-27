<div class="bluebox">
<div class="formblock">
<div class="accordinghead">Page 3 of 3</div>
<br />
If you are using  <b>Application.cfm</b> file, Please add following code to Application.cfm file

<pre style="background: #FFFFFF;  -moz-border-radius: 10px;-webkit-border-radius:5px; border-radius:5px; -khtml-border-radius: 5px; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -o-pre-wrap; border:1px solid #FFFFFF; padding:5px; margin:5px; font-family:'Courier New', Courier, monospace; font-size:12px">
&lt;cferror type="exception" template="irongate/irongate.cfm">
</pre>

<br /><br />
If you are using the <b>Application.cfc</b> file, Please add following code to  Application.cfc file.<br />
(If you have an onError() function declared in your application currently, please disable it.)
<pre style="background: #FFFFFF; -moz-border-radius: 10px;-webkit-border-radius:5px; border-radius:5px; -khtml-border-radius: 5px; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -o-pre-wrap; border:1px solid #FFFFFF; padding:5px; margin:5px; font-family:'Courier New', Courier, monospace; font-size:12px">&lt;cffunction name=&quot;OnRequestStart&quot; output=&quot;no&quot;&gt;<br />	&lt;cferror type=&quot;exception&quot; template=&quot;irongate/irongate.cfm&quot;&gt;<br />&lt;/cffunction&gt;</pre>

<br /><br />
Also irongate can be used inside <a href="http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=Tags_t_12.html" target="_blank">&lt;cftry>&lt;cfcatch> block</a>
<pre style="background: #FFFFFF;  -moz-border-radius: 10px;-webkit-border-radius:5px; border-radius:5px; -khtml-border-radius: 5px; white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -o-pre-wrap; border:1px solid #FFFFFF; padding:5px; margin:5px; font-family:'Courier New', Courier, monospace; font-size:12px">&lt;cftry><br /><br />  &nbsp; &lt;cfcatch><br />&nbsp; &nbsp; &nbsp; &lt;cfinclude template="irongate/irongate.cfm"><br /> &nbsp; &lt;/cfcatch><br />&lt;/cftry></pre>

Not only that, You can set irongate.cfm as the site-wide error handler via ColdFusion Administrator.<br />
<br />
<cfif server.OS.Name eq 'Unix'>
	<div align="center"><input title="Set Up Complete." class="btn btn-inverse btn-small" type="button" value="Set Up Complete." name="submit" onclick="alert('Please Remove (/install) Folder'); window.location='../administrator/'" /><br /><br /><b>Don't Forget to Remove Installation Folder</b></div>
<cfelse>
	<div align="center"><input title="Set Up Complete - Delete Installation Files." class="btn btn-inverse btn-small" type="button" value="Set Up Complete - Let's Delete Installation Files." name="submit" onclick="window.location='index.cfm?action=6'" /></div>
</cfif>
</div></div>