<cfparam name="attributes.package" default="">
<cfparam name="attributes.file">

<cfset root = RepeatString('../', ListLen(attributes.package, ".")) />

<!-- ========= START OF NAVBAR ======= -->
<a name="navbar_top"></a>
<a href="#skip-navbar_top" title="skip navigation links"></a>	

<nav class="navbar navbar-expand-sm fixed-top bg-light border-1 border-info p-2 rounded shadow-lg " role="navigation" data-bs-theme="dark" id="navigation">
	<div class="container-fluid">
    
		<div class="navbar-brand">
			<button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#class-navigation">
				<span class="navbar-toggler-icon" aria-label="Toggle navigation"></span>
			</button>
			<a class="navbar-brand" href="#"><strong><cfoutput>#attributes.projecttitle#</cfoutput></strong></a>
		</div>

	    <div class="collapse navbar-collapse show" id="class-navigation">
	    	<ul class="nav navbar-nav">
				<cfif attributes.page eq "overview">
					<li class="active nav-item"><a href="#" class="nav-link"><i class="glyphicon glyphicon-plane"></i> overview</a></li>
				<cfelse>
					<cfoutput>
					<li class="nav-item"><a href="#root#overview-summary.html" class="nav-link"><i class="glyphicon glyphicon-plane"></i> overview</a></li>
					</cfoutput>
				</cfif>

				<cfif attributes.page eq "package">
					<li class="active nav-item"><a href="#" class="nav-link" ><i class="glyphicon glyphicon-folder-open"></i> &nbsp;package</a></li>
				<cfelseif attributes.page eq "class">
					<li class="nav-item"><a href="package-summary.html" class="nav-link" ><i class="glyphicon glyphicon-folder-open"></i> &nbsp;package</a></li>
				</cfif>

			  	<cfif attributes.page eq "class">
					<li class="nav-item dropdown active">
						<a class="nav-link" href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown"><i class="glyphicon glyphicon-file"></i> class <b class="caret"></b></a>

						<ul class="dropdown-menu">
							<li class="dropdown-item"><a href="#class" class="nav-link" >Class Definition</a></li>
							<li class="dropdown-item"><a href="#constructor_summary" class="nav-link" >Constructor Summary</a></li>
							<li class="dropdown-item"><a href="#constructor_detail" class="nav-link" >Constructor Detail</a></li>
							<li class="dropdown-item"><a href="#inherited_methods" class="nav-link" >Inherited Methods</a></li>
							<li class="dropdown-item"><a href="#method_summary" class="nav-link" >Method Summary</a></li>
							<li class="dropdown-item"><a href="#method_detail" class="nav-link" >Method Detail</a></li>
							<li class="dropdown-item"><a href="#property_summary" class="nav-link" >Property Summary</a></li>
							<li class="dropdown-item"><a href="#property_detail" class="nav-link" >Property Detail</a></li>
							
						</ul>
					</li>
				</cfif>
	      	</ul>

			<ul class="nav navbar-nav navbar-right">
				<li><cfoutput><a href="#root#index.html?#attributes.file#.html" target="_top" class="nav-link">
					<i class="glyphicon glyphicon-fullscreen"></i> Frames
					</a></cfoutput>
				</li>
			</ul>
	    </div>

	</div>
</nav>
<div id="navspacer"></div>
<script>
document.addEventListener("DOMContentLoaded", function(event) {
	let spacer = document.getElementById("navspacer");
	let nav = document.getElementById( "navigation" );

    spacer.style.paddingTop = nav.offsetHeight + "px";
});
	
</script>

<a name="skip-navbar_top"></a>
<!-- ========= END OF NAVBAR ========= -->