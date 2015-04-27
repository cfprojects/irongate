<cfif FileExists(settingfile)>
	<!--- *********************************************************** --->
	<!--- save settings to irongate file                                --->
	<!--- *********************************************************** --->
	<cffile action="read" file="#settingfile#" variable="set" charset="utf-8">
	<cfset set	= replace(set,chr(10),' #chr(10)#','all')> <!--- add space at the end to solve empty line problem --->
	<cfset newset 	= ArrayNew(1)>
	<cfset line 	= 1>
	<cfloop list="#set#" delimiters="#chr(10)#" index="i">
		<cfset i = rtrim(i)>
		<cfif right(i,1) eq ' '>
			<!--- remove the space added to the end of the line - we dont need it any more --->
			<cfset i	= left(i,len(i)-1)>
		</cfif> 
		<cfif StructKeyExists(form,'filed_#line#')>
			<cfset string = left(i,find('= "',i)+2)>
			<cfset ArrayAppend(newset,trim('#string##replace(Evaluate('form.filed_#line#'),'"','""','all')#">'))>
		<cfelse>
			<cfset ArrayAppend(newset,i)>
		</cfif>
		<cfset line = 1+line>
	</cfloop>
	
	<cffile
		action 		= "write"
		file 		= "#settingfile#"
		output 		= "#ArrayToList(newset,chr(10))#"
		addnewline 	= "No" 
		charset 	= "utf-8" >

	<!--- *********************************************************** --->
	<!--- save basic settings for administrator use                   --->
	<!--- *********************************************************** --->
	<cfset newset 	= ArrayNew(1)>
	<cfset line 	= 1>
	<cfloop list="#set#" delimiters="#chr(10)#" index="i">
		<cfset i = rtrim(i)>
		<cfif StructKeyExists(form,'filed_#line#')>
			<cfset string = left(i,find('= "',i)+2)>
			<cfset ArrayAppend(newset,trim('#string##replace(Evaluate('form.filed_#line#'),'"','""','all')#">'))>
		<cfelse>
			<cfset ArrayAppend(newset,i)>
		</cfif>
		<cfif line gte 13>
			<cfbreak>
		</cfif>
		<cfset line = 1+line>
	</cfloop>
	<cfset ArrayAppend(newset,'<cfset irongate.table		= "#irongate.table#">')>
	<cfset ArrayAppend(newset,'<cfset irongate.version		= "#irongate.version#">')>

	<cffile
		action 		= "write"
		file 		= "#ExpandPath('..\administrator\')#settings.cfm"
		output 		= "#ArrayToList(newset,chr(10))#"
		addnewline 	= "No" 
		charset 	= "utf-8" >
	<!--- *********************************************************** --->
	<!--- Create Log folder                                           --->
	<!--- *********************************************************** --->
	<cfinclude template="../administrator/settings.cfm">

	<cfif not DirectoryExists("#irongate.LogFolder#\pages")>
		<cfdirectory action="create" directory="#irongate.LogFolder#\pages">
	</cfif>
	<cfif not DirectoryExists("#irongate.LogFolder#\variables")>
		<cfdirectory action="create" directory="#irongate.LogFolder#\variables">
	</cfif>

	<cflocation addtoken="no" url="index.cfm?action=3&d=#cfusion_encrypt(form.filed_4,settingfile)#&u=#cfusion_encrypt(form.filed_6,settingfile)#&p=#cfusion_encrypt(form.filed_8,settingfile)#">
<cfelse>
	<strong>Installation filed.</strong>
	<br /><br />file not found <cfoutput>#settingfile#</cfoutput>
</cfif>