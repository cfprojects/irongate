<!--- ************************************************************** --->
<!--- Helpers                                                        --->
<!--- ************************************************************** --->

<!--- http://www.cflib.org/udf/ungzip --->
<cffunction name	="ungzip"
    returntype		="any"
    displayname		="ungzip"
    hint			="decompresses a binary|(base64|hex|uu) using the gzip algorithm; returns string"
    output			="no">
	
	<cfargument name="string" 	required="no" 	type="string" default="">
	<cfargument name="compress" required="no" 	type="string" default="Yes">
	<cfargument name="code" 	required="no" 	type="string" default="Yes">
	<cfargument name="encode" 	required="no" 	type="string" default="base64">
	<cfif YesNoFormat(arguments.compress)>
	<cftry>
		<cfset local				= StructNew()>
		<cfset local.bufferSize		= 8192>
		<cfset local.byteArray 		= createObject("java","java.lang.reflect.Array").newInstance(createObject("java","java.lang.Byte").TYPE,local.bufferSize)>
		<cfset local.decompressOutputStream	= createObject("java","java.io.ByteArrayOutputStream").init()>
		<cfset local.decompressInputStream	= 0>
		<cfset local.l				= 0>
		<cfset local.input			= binaryDecode(arguments.string,arguments.encode)>
		<cfset local.decompressInputStream	= createObject("java","java.util.zip.GZIPInputStream").init(createObject("java","java.io.ByteArrayInputStream").init(local.input))>
		<cfset local.l				= local.decompressInputStream.read(local.byteArray,0,local.bufferSize)>
		
		<cfset local.count = 1>
		<cfloop condition = "local.l gt -1">
			<cfset local.decompressOutputStream.write(local.byteArray,0,local.l)>
			<cfset local.l		= local.decompressInputStream.read(local.byteArray,0,local.bufferSize)>
			<cfset local.count	= 1+local.count>
			<cfif local.count gt 100000>
				<!--- safty break --->
				<cfbreak>
			</cfif>
		</cfloop>
		
		<cfset local.decompressInputStream.close()>
		<cfset local.decompressOutputStream.close()>
		<cfreturn local.decompressOutputStream.toString()>
		<cfset StructKeyExists(variables,'local')>
	<cfcatch>
		<cfreturn arguments.string>
	</cfcatch>
	</cftry>
	<cfelse>
		<cfreturn cfusion_decrypt(arguments.string,arguments.code)>
	</cfif>
</cffunction>