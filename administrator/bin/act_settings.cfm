<cfimport 
	taglib =	"../system/ct"  
	prefix =	"ct">
<ct:quickCheck>
<cfset settingfile = "#ExpandPath('..\')#irongate.cfm">

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
			<cfset ArrayAppend(newset,'#string##replace(form['filed_#line#'],'"','""','all')#">')>
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
			<cfset ArrayAppend(newset,'#string##replace(form['filed_#line#'],'"','""','all')#">')>
		<cfelse>
			<cfset ArrayAppend(newset,i)>
		</cfif>
		<cfif line gte 13>
			<cfbreak>
		</cfif>
		<cfset line = 1+line>
	</cfloop>
	<cfset ArrayAppend(newset,'<cfset irongate.table			= "#irongate.table#">')>
	<cfset ArrayAppend(newset,'<cfset irongate.version		= "#irongate.version#">')>

	<cffile
		action 		= "write"
		file 		= "#ExpandPath('..\administrator\')#settings.cfm"
		output 		= "#ArrayToList(newset,chr(10))#"
		addnewline 	= "No" 
		charset 	= "utf-8" >

	<cfset session.msg	= "Settings Updated">
	<cflocation addtoken="no" url="index.cfm?action=settings">
<cfelse>
	<strong>Installation unsuccessful.</strong>
	<br /><br />file not found <cfoutput>#settingfile#</cfoutput>
</cfif>