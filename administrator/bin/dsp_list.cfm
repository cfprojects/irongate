<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>

<cfsilent>
<!--- *************************************************** --->
<!--- get the id list of all the records to memory        --->
<!--- *************************************************** --->
<cfquery name="master" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select max(errorid) as errorid from #irongate.table#
	<cfif len(url.srch)>
		where template like '%#trim(url.srch)#%' or message like '%#trim(url.srch)#%'
	</cfif>
	group by errorid,template,message, type, line
	order by
    <cfswitch expression="#url.order#">
        <cfcase value="viewed">		viewed			</cfcase>
		<cfcase value="status">		max(status)		</cfcase>
        <cfcase value="template">	template		</cfcase>
        <cfcase value="line">		line			</cfcase>
        <cfcase value="message">	message			</cfcase>
        <cfcase value="ecount">		count(errorid)	</cfcase>
        <cfcase value="type">		type			</cfcase>
		<cfdefaultcase>				max(etime)		</cfdefaultcase>
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

<cfset searchlist	= valuelist(master.errorid)>
<cfinclude template="../system/common/grid_calc.cfm">
<!--- *************************************************** --->
<!--- get full details for current page records           --->
<!--- *************************************************** --->
<cfquery name="get" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select max(bugid) as id, count(errorid) as ecount, max(errorid) as errorid, template,line,message, type
	from #irongate.table#
	where <cfif listlen(searchlist)>errorid in (#searchlist#)<cfelse>errorid = 0</cfif>
	group by errorid,template,message, type, line
	order by
    <cfswitch expression="#url.order#">
        <cfcase value="viewed">		viewed			</cfcase>
		<cfcase value="status">		max(status)		</cfcase>
        <cfcase value="template">	template		</cfcase>
        <cfcase value="line">		line			</cfcase>
        <cfcase value="message">	message			</cfcase>
        <cfcase value="ecount">		count(errorid)	</cfcase>
        <cfcase value="type">		type			</cfcase>
		<cfdefaultcase>				max(etime)		</cfdefaultcase>
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

<!--- *************************************************** --->
<!--- Show Error Grid                                     --->
<!--- *************************************************** --->
<cfset titlelist = "&nbsp;|status,Count|ecount,Template|template,Line|line,Message|message,Type|type,Time|etime,<img src='images/delete.png' class='deletebtn' style='cursor:pointer' />">
<cfinclude template="../system/common/grid_header.cfm">
<cfoutput query="get">

<cfquery name="thisQ" datasource="#irongate.datasource#" username="#irongate.username#" password="#irongate.password#">
	select viewed,status,etime from #irongate.table# where bugid = #get.id#
</cfquery>

<tr id="#id#" class="zibrablk#val(thisQ.viewed)#">
	<td align="center"><img src="images/#val(thisQ.status)#_stat.png" class="statbtn" original-title="<cfswitch expression='#val(thisQ.status)#'><cfcase value='0'>New</cfcase><cfcase value='1'>Attending</cfcase><cfcase value='2'>Ignored</cfcase><cfcase value='3'>Fixed</cfcase></cfswitch>" /></td>
	<td class="ecounts"><cfif ecount gt 1><a href="index.cfm?action=incidence&errorid=#get.errorid#&id=#get.id#"><img original-title="View All Incidences" style="position:relative; vertical-align:middle" src="images/plusicon.gif" width="15" height="15" align="absmiddle" border="0" /></a> #ecount#
	<cfelse>
		<cfswitch expression="#listfirst(type,'.')#">
			<cfcase value="i"><img src="images/settingssml.png" class="tip" original-title="Imported Record" border="0" align="absmiddle" /></cfcase>
		</cfswitch>
	</cfif></td>
	<td class="linkme tip" original-title="#template#"><cfif len(template) gt 40 and listlen(template,'\/') gt 2>#listfirst(template,'\/')#\..\#listlast(template,'\/')#<cfelse>#template#&nbsp;</cfif></td>
	<td class="linkme">#line#</td>
	<td class="linkme">#message#</td>
	<td class="linkme">#lcase(listlast(type,'.'))#</td>
	<td class="linkme">#dateformat(thisQ.etime,'ddd mm/dd/yy')# #timeformat(thisQ.etime,'hh:mm tt')#</td>
	<td width="20"><input type="checkbox" class="deletechk" value="#get.errorid#" /></td>
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
				var r=confirm('Are you sure you want to delete '+$('.deletechk:checked').length+' errors?');
			} else {
				var r=confirm('Are you sure you want to delete this error?');
			}
			if (r==true){
				window.location='index.cfm?action=delete&<cfoutput>page=#url.page#</cfoutput>&errorid='+list.toString()
			}
		}
	});
});
</script>