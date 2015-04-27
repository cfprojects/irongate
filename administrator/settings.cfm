<cfprocessingdirective pageencoding="utf-8">

<!--- Data Source Name (Valid and Working DSN Required.)             --->
<cfset irongate.datasource		= "">
<!--- Data Source User Name (Leave Blank if not applicable)          --->
<cfset irongate.username		= "">
<!--- Data Source Password (Leave Blank if not applicable)           --->
<cfset irongate.password		= "">
<!--- Log file storage folder (Required)                             --->
<cfset irongate.LogFolder		= "">
<!--- Compress Log Files (If Your Hosting Provider does not support CFOBJECT tag, set this to 'No') [Yes,No] --->
<cfset irongate.compress		= "Yes">

<cfset irongate.table			= "irongate">
<cfset irongate.version			= "1">