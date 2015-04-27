<cfparam name="form.dbtype" default="">

<cfset createTable = "0">
<!--- ********************************************************************* --->
<!--- Create Data Table                                                     --->
<!--- ********************************************************************* --->
<cftry>
<cfquery name="chk" datasource="#cfusion_decrypt(form.d,settingfile)#" username="#cfusion_decrypt(form.u,settingfile)#" password="#cfusion_decrypt(form.p,settingfile)#">
	select bugid from #irongate.table# where bugid = 1
</cfquery>
	<cfcatch>
		<cfif trim(cfcatch.Message) eq "Datasource #cfusion_decrypt(form.d,settingfile)# could not be found.">
				<cfoutput>
				<div class="alert alert-block alert-error" style="margin:20px;">
				<div style="font-size:18px;">
					Oh Snap! We just started and this happened. Datasource #cfusion_decrypt(form.d,settingfile)# could not be found. 
				</div>
				<div style="font-size:14px; padding-top:20px">
					Don't worry though, easy to fix.
					Please Create a DSN name #cfusion_decrypt(form.d,settingfile)# using #server.coldfusion.productname# Administrator or enter correct Datasource name. <br /><br />
					ColdFusion server said : <cfoutput> "#cfcatch.Cause.Message#" </cfoutput> <br /><br />
				</div>	
				<a href="#cgi.HTTP_REFERER#">Back</a>
				</div>
				</cfoutput>
			<cfabort>
		</cfif>
		<cfset createTable = "1">
	</cfcatch>
</cftry>

<cftry>
<cfswitch expression="#form.dbtype#">
	<cfcase value="mssql">
		<cfif val(createTable)>
			<!--- create mssql database ---->
			<cfquery name="create" datasource="#cfusion_decrypt(form.d,settingfile)#" username="#cfusion_decrypt(form.u,settingfile)#" password="#cfusion_decrypt(form.p,settingfile)#">
				CREATE TABLE [#irongate.table#](
					[bugid] [int] IDENTITY(1,1) NOT NULL,
					[code] [varchar](35) NULL,
					[errorid] [int] NULL,
					[template] [varchar](200) NULL,
					[message] [varchar](500) NULL,
					[line] [int] NULL,
					[type] [varchar](20) NULL,
					[etime] [datetime] NULL,
					[status] [tinyint] NULL,
					[viewed] [bit] NULL,
				 CONSTRAINT [PK_#irongate.table#] PRIMARY KEY CLUSTERED  ([bugid] ASC)
				ON [PRIMARY]
				) 
				ON [PRIMARY]
			</cfquery>
		</cfif>
	</cfcase>
	<cfcase value="mysql">
		<cfif val(createTable)>
			<!--- create mysql database ---->
			<cfquery name="chk" datasource="#cfusion_decrypt(form.d,settingfile)#" username="#cfusion_decrypt(form.u,settingfile)#" password="#cfusion_decrypt(form.p,settingfile)#">
				CREATE TABLE #irongate.table# (
				bugid 		int(11) NOT NULL AUTO_INCREMENT,
				code 		varchar(35) DEFAULT NULL,
				errorid 	int(11) DEFAULT NULL,
				template 	varchar(200) DEFAULT NULL,
				message 	varchar(500) DEFAULT NULL,
				line 		int(11) DEFAULT NULL,
				type 		varchar(20) DEFAULT NULL,
				etime 		datetime DEFAULT NULL,
				status 		tinyint(4) DEFAULT NULL,
				viewed 		bit(1) DEFAULT NULL,
				PRIMARY KEY (bugid)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1;
			</cfquery>
		</cfif>
	</cfcase>
	<cfcase value="pssql">
		<cfif val(createTable)>
			<!--- create postgres database ---->
			<cfquery name="dropseq" datasource="#cfusion_decrypt(form.d,settingfile)#" username="#cfusion_decrypt(form.u,settingfile)#" password="#cfusion_decrypt(form.p,settingfile)#">
				DROP SEQUENCE IF EXISTS #irongate.table#_seq
			</cfquery>
			
			<cfquery name="chk" datasource="#cfusion_decrypt(form.d,settingfile)#" username="#cfusion_decrypt(form.u,settingfile)#" password="#cfusion_decrypt(form.p,settingfile)#">
				CREATE SEQUENCE #irongate.table#_seq;				
				CREATE TABLE #irongate.table# (
				bugid 		INTEGER NOT NULL PRIMARY KEY DEFAULT nextval('#irongate.table#_seq'),
				code 		VARCHAR(35),
				errorid 	INTEGER,
				template	varchar(200),
				message		varchar(500),
				line		int,
				type		varchar(20),
				etime		date,
				status		smallint,
				viewed		bool
				);
			</cfquery>
		</cfif>
	</cfcase>
	<cfcase value="skip">
	</cfcase>
	<cfdefaultcase>
		<strong>Table cannot be created.</strong>
		<br /><br />Missing Database Type. 
	</cfdefaultcase>
</cfswitch>

<!--- ********************************************************************* --->
<!--- Database Creation Error                                               --->
<!--- ********************************************************************* --->
	<cfcatch>
		<div class="alert alert-block alert-error" style="margin:20px;">
		<div style="font-size:18px;">Oh Snap! We just started and this happened. Table Creation failed.<br />
		Don't worry though, easy to fix.
		</div>
		<div style="font-size:14px; padding-top:20px">
			 <a target="_blank" href="<cfoutput>#form.dbtype#.txt</cfoutput>">Download SQL script file</a> and run it manually, come back here and refresh the page. 
			<br /><br />
			Probably your DSN do not allow Table Creation or a table nane "<cfoutput>#irongate.table#</cfoutput>" already exists in your database.<br /><br />
			ColdFusion server said :
			<cfoutput> "#cfcatch.Cause.Message#" </cfoutput> and <a href="javascript:$('#moreinfo').slideDown('slow')">lot of other things</a>
		</div><br /><br />
		</div>
		<div id="moreinfo" style="display:none">
		<cfdump var="#cfcatch#">
		</div>
		
		<cfabort>
	</cfcatch>
</cftry>

<!--- ********************************************************************* --->
<!--- Save Login Page                                                       --->
<!--- ********************************************************************* --->

<cfoutput>
<cfsavecontent variable="pageContent">
[cfprocessingdirective pageEncoding="utf-8">
[cfset irongate.username	= "#form.username#">
[cfset irongate.password	= "#form.password#">
</cfsavecontent>
</cfoutput>

<cfset pageContent = trim(replace(pageContent,'[cf','<cf','all'))>

<cffile 
	action			= "write"
	nameconflict	= "overwrite"
	charset			= "utf-8"
	file			= "#ExpandPath('..\administrator\')#login_details.cfm"
	output			= "#pageContent#">

<cflocation addtoken="no" url="index.cfm?action=5">