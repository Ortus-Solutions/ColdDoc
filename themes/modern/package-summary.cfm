<cfoutput>
<cfset assetPath = repeatstring( '../', listlen( arguments.package, "." ) )>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>	#arguments.package# </title>
	<meta name="keywords" content="#arguments.package# package">
	<cfmodule template="inc/common.cfm" rootPath="#assetPath#">
</head>
<body class="pt-5">

	<cfmodule template="inc/nav.cfm"
				page="Package"
				projectTitle= "#arguments.projectTitle#"
				package = "#arguments.package#"
				file="#replace(arguments.package, '.', '/', 'all')#/package-summary"
				>
	
<!--
	BREADCRUMB NAV!!!
-->
	
<div class="container-fluid">
	<div class="table-responsive">
	<cfif arguments.qInterfaces.recordCount>

		<div class="card">
			<div class="card-header">
				<strong>interface summary</strong>
			</div>
			<ul class="list-group list-group-flush">
				<cfloop query="arguments.qinterfaces">
					<li class="list-group-item">
						<a href="#name#.html" title="class in #package#" class="fw-bold">#name#</a>
						<span>
							<cfset meta = metadata>
							<cfif structkeyexists(meta, "hint")>
								#listgetat(meta.hint, 1, chr(13)&chr(10)&'.' )#
							</cfif>
						</span>
					</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
	
	<cfif arguments.qClasses.recordCount>
		<div class="card">
			<div class="card-header">
				<strong>class summary</strong>
			</div>
			<ul class="list-group list-group-flush">
				<cfloop query="arguments.qclasses">
					<li class="list-group-item">
						<a href="#name#.html" title="class in #package#" class="fw-bold">#name#</a>
						<span>
							<cfset meta = metadata>
							<cfif structkeyexists(meta, "hint") and len(meta.hint) gt 0>
								#listgetat( meta.hint, 1, chr(13)&chr(10)&'.' )#
							</cfif>
						</span>
					</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
	</div>
</div>

</body>
</html>
</cfoutput>