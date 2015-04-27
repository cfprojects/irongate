<cfcomponent displayname="Color">

<!--- http://code.fraser.id.au/colorcode/colorcode.cfm --->
<cffunction name="colorString" output="false" returnType="string" access="public">
    <cfargument name="dataString" 	type="string" 	required="true" />
    <cfargument name="lineNumbers" 	type="boolean" 	default="true" />
    <cfargument name="mark" 		type="boolean" 	default="0" />
    
    <cfset var local = StructNew() />

    <cfset local.data = arguments.dataString />		
    <cfset local.eof = false >

    <!--- replace 4 spaces with tab --->
    <cfset local.data = replace(local.data, "    ", chr(9), "all") />
    
    <!--- replace 3 spaces with tab --->
    <cfset local.data = replace(local.data, "   ", chr(9), "all") />
    
    <!--- Convert all quoted values to blue --->
    <cfset local.data = REReplaceNoCase(local.data, """([^""]*)""", "«span style=""color: ##0000ff""»""\1""«/span»", "all") />

    <!--- Convert all multi-line script comments to yellow background --->
    <cfset local.data = REReplaceNoCase(local.data, "(<!---(.*?)--->)", "«span style=""color: ##000000; background-color: ##FFFF99""»\1«/span»", "all") />
        
    <!--- Convert all single-line script comments to gray --->
    <cfset local.data = REReplaceNoCase(local.data, "(\/\/[^#chr(13)#]*)", "«span style=""color: ##9a9a9a""»«em»\1«/em»«/span»", "all") />

    <!--- Convert special characters so they do not get interpreted literally /> italicize and boldface --->
    <cfset local.data = REReplaceNoCase(local.data, "&([[:alpha:]]{2,}) />", "«strong»«em»&amp;\1 />«/em»«/strong»", "all") />

    <!--- Convert many standalone (not within quotes) numbers to blue, ie. myValue = 0 --->
    <cfset local.data = REReplaceNoCase(local.data, "(gt|lt|eq|is|,|\(|\))([[:space:]]?[0-9]{1,})", "\1«span style=""color: ##0000ff""»\2«/span»", "all") />

    <!--- Convert normal tags to navy blue --->
    <cfset local.data = REReplaceNoCase(local.data, "<(/?)((!d|b|c(e|i|od|om)|d|e|f(r|o)|h|i|k|l|m|n|o|p|q|r|s|t(e|i|t)|u|v|w|x)[^>]*)>", "«span style=""color: ##000080""»<\1\2>«/span»", "all") />

    <!--- Convert all table-related tags to teal --->
    <cfset local.data = REReplaceNoCase(local.data, "<(/?)(t(a|r|d|b|f|h)([^>]*)|c(ap|ol)([^>]*))>", "«span style=""color: ##008080""»<\1\2>«/span»", "all") />

    <!--- Convert all form-related tags to orange --->
    <cfset local.data = REReplaceNoCase(local.data, "<(/?)((bu|f(i|or)|i(n|s)|l(a|e)|se|op|te)([^>]*))>", "«span style=""color: ##ff8000""»<\1\2>«/span»", "all") />

    <!--- Convert all tags starting with "a" to green, since the others aren't used much and we get a speed gain --->
    <cfset local.data = REReplaceNoCase(local.data, "<(/?)(a[^>]*)>", "«span style=""color: ##008000""»<\1\2>«/span»", "all") />

    <!--- Convert all image and style tags to purple --->
    <cfset local.data = REReplaceNoCase(local.data, "<(/?)((im[^>]*)|(sty[^>]*))>", "«span style=""color: ##800080""»<\1\2>«/span»", "all") />

    <!--- Convert all ColdFusion, SCRIPT and WDDX tags to maroon --->
    <cfset local.data = REReplaceNoCase(local.data, "<(/?)((cf[^>]*)|(sc[^>]*)|(wddx[^>]*))>", "«span style=""color: ##800000""»<\1\2>«/span»", "all") />

    <!--- Convert all multi-line script comments to gray --->
    <cfset local.data = REReplaceNoCase(local.data, "(\/\*[^\*]*\*\/)", "«span style=""color: ##808080""»«em»\1«/em»«/span»", "all") />

    <!--- Convert left containers to their ASCII equivalent --->
    <cfset local.data = REReplaceNoCase(local.data, "<", "&lt;", "all") />

    <!--- Convert right containers to their ASCII equivalent --->
    <cfset local.data = REReplaceNoCase(local.data, ">", "&gt;", "all") />

    <!--- Line Numbers --->
    <cfif arguments.lineNumbers>
        <cfset local.data = replace(local.data,chr(9),"&nbsp;&nbsp;&nbsp;&nbsp;","all") />
        <cfset local.tempData = "" />
  
        <cfset local.count 	= 1>
<!--- few shared hosting seems to have trouble with java.io	
		<cfset local.reader = createObject("java","java.io.StringReader").init(local.data)>
        <cfset local.buffer = createObject("java","java.io.BufferedReader").init(local.reader)>
        <cfset local.line	= local.buffer.readLine()>--->

        <cfloop list="#local.data#" delimiters="#chr(10)#" index="local.line">
			<cfif local.count eq mark>
            	<cfset lingbg	= 'C5465C'>
            <cfelse>
            	<cfset lingbg	= '3D91D0'>
            </cfif>
            <!--- <cfset local.tempData = "#local.tempData# #local.line# <br>"> --->
           <cfset local.tempData = local.tempData & "«div style=""color: ##FFF; float:left; width:40px; background-color: ###lingbg#""»#repeatString("&nbsp;", 4-len(local.count))##local.count#:«/div»«div style=""""»«span style=""background-color: ##FFFFFF;""»&nbsp;</span>#local.line#«/div»«div style=""clear:both;""»«/div»" />
		<!---<cfset local.line=local.buffer.readLine()>--->
        <cfset local.count = 1+local.count>
        <cfif local.count gt 10000>
        	<cfbreak>
        </cfif>
        </cfloop>
        <cfset local.data = local.tempData />
    <cfelse>
        <cfset local.data = "<pre>#local.data#</pre>" />
    </cfif>

    <!--- Revert all pseudo-containers back to their real values to be interpreted literally (revised) --->
    <cfset local.data = REReplaceNoCase(local.data, "«([^»]*)»", "<\1>", "all") />

    <cfreturn local.data>
</cffunction>

</cfcomponent>