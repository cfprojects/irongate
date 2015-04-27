<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>

<!--- *************************************************** --->
<!--- get the id list of all the records to memory        --->
<!--- *************************************************** --->
<cfquery name="master" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select bugid from #irongate.table#
	where errorid = #val(url.errorid)#
	<cfif len(url.srch)>
		and template like '%#trim(url.srch)#%' or message like '%#trim(url.srch)#%'
	</cfif>
	order by
    <cfswitch expression="#url.order#">
        <cfcase value="viewed">		viewed	</cfcase>
		<cfcase value="status">		status	</cfcase>
        <cfcase value="template">	template</cfcase>
        <cfcase value="line">		line	</cfcase>
        <cfcase value="message">	message	</cfcase>
        <cfcase value="type">		type	</cfcase>
		<cfdefaultcase>				etime	</cfdefaultcase>
    </cfswitch>
    <cfswitch expression="#url.dir#">
        <cfcase value="0">
            asc
        </cfcase>
        <cfdefaultcase>
            desc
        </cfdefaultcase>
    </cfswitch>
</cfquery>

<cfsilent>
<cfset searchlist	= valuelist(master.bugid)>
<cfinclude template="../system/common/grid_calc.cfm">
<!--- *************************************************** --->
<!--- get full details for current page records           --->
<!--- *************************************************** --->
<cfquery name="get" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select bugid as id, errorid, template,line,message, type
	from #irongate.table#
	where <cfif listlen(searchlist)>bugid in (#searchlist#)<cfelse>errorid = 0</cfif>
	order by
    <cfswitch expression="#url.order#">
        <cfcase value="viewed">		viewed	</cfcase>
		<cfcase value="status">		status	</cfcase>
        <cfcase value="template">	template</cfcase>
        <cfcase value="line">		line	</cfcase>
        <cfcase value="message">	message	</cfcase>
        <cfcase value="type">		type	</cfcase>
		<cfdefaultcase>				etime	</cfdefaultcase>
    </cfswitch>
    <cfswitch expression="#url.dir#">
        <cfcase value="0">
            asc
        </cfcase>
        <cfdefaultcase>
            desc
        </cfdefaultcase>
    </cfswitch>
</cfquery>
</cfsilent>

<div id="breadcrumb"><a href="index.cfm">Home</a> \ <cfoutput>#get.message#</cfoutput></div>

<!--- *************************************************** --->
<!--- Show Error Grid                                     --->
<!--- *************************************************** --->
<cfset titlelist = "&nbsp;|status,Template|template,Line|line,Message|message,Type|type,Time|etime,<img src='images/delete.png' class='deletebtn' style='cursor:pointer' />">
<cfinclude template="../system/common/grid_header.cfm">
<cfoutput query="get">

<cfquery name="thisQ" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select viewed,status,etime from #irongate.table# where bugid = #get.id#
</cfquery>

<tr id="#id#" <cfif val(thisQ.viewed)><cfif not currentrow mod 2>class="zibrablk"<cfelse>class="zibrawhite"</cfif><cfelse>class="highlight"</cfif> >
	<td><img src="images/#val(thisQ.status)#_stat.png" class="statbtn" /></td>
	<td class="linkme tip" title="#template#"><cfif len(template) gt 40 and listlen(template,'\/') gt 2>#listfirst(template,'\/')#\..\#listlast(template,'\/')#<cfelse>#template#&nbsp;</cfif></td>
	<td class="linkme">#line#</td>
	<td class="linkme">#message#</td>
	<td class="linkme">#lcase(type)#</td>
	<td class="linkme">#dateformat(thisQ.etime,'ddd mm/dd/yy')# #timeformat(thisQ.etime,'hh:mm tt')#</td>
	<td width="20"><input type="checkbox" class="deletechk" value="#get.id#" /></td>
</tr>
</cfoutput>
</table>
<cfinclude template="../system/common/grid_navi.cfm">

<script type="text/javascript">
$(document).ready(function(e) {
	$('.deletebtn').click(function(e) {
		if ( $('.deletechk:checked').length ) {
			var list = []
			$('.deletechk:checked').each(function(i, e) { list.push($(this).val()) });
			if ( $('.deletechk:checked').length > 1 ) {
				var r=confirm('Are you sure you want to delete '+$('.deletechk:checked').length+' records?');
			} else {
				var r=confirm('Are you sure you want to delete this record?');
			}
			if (r==true){
				window.location='index.cfm?action=delete&errorid=<cfoutput>#url.errorid#&page=#url.page#</cfoutput>&bugid='+list.toString()
			}
		}
	});
});
</script>