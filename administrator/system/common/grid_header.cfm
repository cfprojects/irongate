<cfif val(url.dir)>
	<cfset newdir = 0>
<cfelse>
	<cfset newdir = 1>
</cfif>
<cfsavecontent variable="js">
<script type="text/javascript">
$("document").ready(function() { $(".grid tr:eq(1) td").each(function(i){ $(".grid tr:eq(0) td:eq("+i+")").attr('align',$(this).attr('align')) }) })
</script>
</cfsavecontent>
<cfhtmlhead text="#js#">
<div class="grid">
<table cellpadding="0" class="gridtable" cellspacing="0" border="0">
<tr class="gdtitle">
<cfloop list="#titlelist#" index="i">
	<cfif listlen(i,'|') gt 1>
		<cfset title 	= listfirst(i,'|')>
		<cfset field 	= trim(listlast(i,'|'))>
		<cfoutput><td class="sorttd" <cfif len(field)>onclick="window.location='index.cfm?order=#field#&dir=#newdir#'"<cfelse> style="cursor:default"</cfif>>#title# <cfif field eq url.order><img src="images/1.gif" width="5" /><img src="images/sort#url.dir#.gif" align="absmiddle" /></cfif></td></cfoutput>
	<cfelse>
		<cfoutput><td>#i#</td></cfoutput>
	</cfif>
</cfloop>
</tr>