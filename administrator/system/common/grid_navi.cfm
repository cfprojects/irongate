<cfif not val(total)>
	<div style="padding:10px; font-weight:bold">No Records Found</div>
</cfif>
<div class="navi">
	<cfset pagecount	= Ceiling(total/shown)>
    <cfif total gt 10>

    	<cfoutput>
        <div id="gnavbttnbox" class="gnavbttnbox">
            <select class="gselector input-mini" id="gselector" name="gselector" onchange="window.location='index.cfm?shown='+$('##gselector').val()">
            	<option value="10">10</option>
                <cfloop from="20" to="100" step="20" index="i"><cfif i lt total><option <cfif shown eq i>selected="selected"</cfif> value="#i#">#i#</option></cfif></cfloop>
            </select>
            <cfif thispage gt 1>
            	<a href="index.cfm?action=#url.action#&errorid=#url.errorid#&page=#val(thispage-1)#"><img src="images/gbck.gif" align="absmiddle" border="0" width="14" height="14" /></a>
            </cfif>
            
            <!--- limit button set calculation : Start --->
            <cfset Start = (Ceiling(thispage/10)*10)-9>
            <cfset end	 = (Ceiling(thispage/10)*10)>
            <cfif end gt pagecount>
            	<cfset end = pagecount>
            </cfif>
            <!--- limit button set calculation : Ends  --->
            
            <cfloop from="#Start#" to="#end#" index="i">
                <cfif thispage eq i> <u>#i#</u><cfelse> <a href="index.cfm?action=#url.action#&errorid=#url.errorid#&page=#i#">#i#</a></cfif>
            </cfloop>
            <cfif pagecount gt thispage>
            	 <a href="index.cfm?action=#url.action#&errorid=#url.errorid#&page=#val(thispage+1)#"><img src="images/gnxt.gif" align="absmiddle" border="0" width="14" height="14" /></a> 
            </cfif>
            Page <input type="text" id="gpagejump" class="gpagejump input-mini" onkeypress="{if (event.keyCode==13) window.location='index.cfm?action=#url.action#&errorid=#url.errorid#&page='+$('##gpagejump').val()}"  name="gpagejump" value="#url.page#" /> of #pagecount#
            (#total# Records)
        &nbsp;
		<a href="javascript:" id="hidetable">Fold</a>
		</div>
    </cfoutput>
    </cfif>
    <div id="gnavsrchbox" class="gnavsrchbox input-append">
    <input type="text" class="gsearch input-small" id="gsearch" placeholder="Keyword" <cfoutput>value="#url.srch#"</cfoutput> name="gsearch" onkeypress="{if (event.keyCode==13) window.location='index.cfm?fs=1&srch='+$('#gsearch').val()}" />
    <button onclick="window.location='index.cfm?fs=1&srch='+$('#gsearch').val()" class="btn btn-mini" type="button">Search</button>
	<cfif len(url.srch)> <button onclick="window.location='index.cfm?fs=1'" class="btn btn-mini" type="button">x</button></cfif>
    </div>
</div></div>