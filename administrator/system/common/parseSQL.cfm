<!--- takes the sql statement and the cfqueryparams  and generates a sql statement that can be cut and pasted into a query editor  --->
<cffunction name="formatSQL"   returntype	= "string"  hint= "I take a sql query and params and merge the 2"   output= "NO">
	<cfargument name="SQL"		required="Yes" 	type="string" default="">   
	<cfargument name="Params" 	required="Yes" 	type="string" default=""> 
    <cfset count= 1>
    <cfset localSQL = arguments.Sql>
    <!--- loop over params - treat as a list --->
    <cfloop list="#arguments.Params#" index="j" delimiters="]">
    	<!--- find the value --->
        <cfset st= ReFindNoCase("value=\'([^\']*)\'",j, 1, "True")>
        <!--- make sure the regex found a value --->
        <cfif st.Pos[1] NEQ 0>
        	<!--- grab the value --->
            <cfset val= mid(j,st.Pos[2],st.len[2])>
            <!--- if not a number than put single quotes arount it --->
            <cfif not IsNumeric(val)>
            	<cfset val= "'" & val & "'">
            </cfif>
            <!--- replace the placeholder in the sql statement with the actual value --->
        	<cfset localSQL = replacenoCase(localSQL, "(param #count#)", val )>
        </cfif>
        <cfset count= count + 1>
    </cfloop>

	<cfreturn localSQL >
</cffunction>