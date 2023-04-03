<cfoutput>
<cfset instance.class.root = RepeatString( '../', ListLen( arguments.package, ".") ) />
<!DOCTYPE html>
<html lang="en">
<head>
	<title>#arguments.name#</title>
	<meta name="keywords" content="#arguments.package#.concurrent.Callable interface">
	<!-- common assets -->
	<cfmodule template="inc/common.cfm" rootPath="#instance.class.root#">
	<!-- syntax highlighter -->
	<link type="text/css" rel="stylesheet" href="#instance.class.root#highlighter/styles/shCoreDefault.css">
	<script src="#instance.class.root#highlighter/scripts/shCore.js"></script>
	<script src="#instance.class.root#highlighter/scripts/shBrushColdFusion.js"></script>
	<script src="#instance.class.root#highlighter/scripts/shBrushXml.js"></script>
	<script src="#instance.class.root#highlighter/scripts/shBrushSql.js"></script>
	<script src="#instance.class.root#highlighter/scripts/shBrushJScript.js"></script>
	<script src="#instance.class.root#highlighter/scripts/shBrushJava.js"></script>
	<script src="#instance.class.root#highlighter/scripts/shBrushCss.js"></script>
	<script type="text/javascript">SyntaxHighlighter.all();</script>
</head>

<body>

<cfmodule template="inc/nav.cfm"
			page="Class"
			projectTitle= "#arguments.projectTitle#"
			package = "#arguments.package#"
			file="#replace(arguments.package, '.', '/', 'all')#/#arguments.name#"
			>
<div class="container-fluid">
<!-- ======== start of class data ======== -->
<!-- Package -->
<div class="pull-right">
	<a href="package-summary.html" title="Package: #arguments.package#"><span class="label label-success">#arguments.package#</span></a>
</div>

<h2 id="class">
<cfif isAbstractClass( arguments.name, arguments.package )>
Abstract
</cfif>
<cfif arguments.metadata.type eq "interface">
Interface
<cfelse>
Class
</cfif>
 #arguments.name#</h2>

<cfset local.i = 0 />

<cfset local.ls = createObject("java", "java.lang.System").getProperty("line.separator") />
<cfset local.buffer = createObject("java", "java.lang.StringBuilder").init() />
<cfset local.thisClass = arguments.package & "." & arguments.name/>

<cfloop array="#getInheritence(arguments.metadata)#" index="className">
	<cfif local.i++ gt 0>
		<cfset local.buffer.append('#RepeatString("  ", local.i)#<img src="#instance.class.root#resources/inherit.gif" alt="extended by ">') />
		<cfif className neq local.thisClass>
			<cfset local.buffer.append(writeClassLink(getPackage(className), getObjectName(className), arguments.qMetaData, "long")) />
		<cfelse>
			<cfset local.buffer.append(className) />
		</cfif>
	<cfelse>
		<cfset local.buffer.append(className) />
	</cfif>
	<cfset local.buffer.append(local.ls) />
</cfloop>

<!-- Inheritance Tree-->
<pre style="background:white">#local.buffer.toString()#</pre>

<!--- All implemented interfaces --->
<cfif arguments.metadata.type eq "component">
	<cfset interfaces = getImplements(arguments.metadata)>
	<cfif NOT arrayIsEmpty(interfaces)>
		<div class="card">
			<div class="card-header">
				<h2 class="fs-4 mb-0">All Implemented Interfaces:</h2>
			</div>
  			<ul class="list-group list-group-flush">
				<cfset local.len = arrayLen(interfaces)>
				<cfloop from="1" to="#local.len#" index="local.counter">
					<cfset interface = interfaces[local.counter]>
					<li class="list-group-item">#writeClassLink(getPackage(interface), getObjectName(interface), arguments.qMetaData, "short")#</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
<cfelse>
	<cfif arguments.qImplementing.recordCount>
	<div class="card">
		<div class="card-header">
			<h2 class="fs-4 mb-0">All Known Implementing Classes:</h2>
		</div>
  		<ul class="list-group list-group-flush">
			<cfloop query="arguments.qimplementing">
				<li class="list-group-item">#writeclasslink(arguments.qimplementing.package, arguments.qimplementing.name, arguments.qmetadata, "short")#</li>
			</cfloop>
		</ul>
	</div>
	</cfif>
</cfif>

<cfif arguments.qSubclass.recordCount>
<div class="card">
	<div class="card-header">
		<h2 class="fs-4 mb-0"><cfif arguments.metadata.type eq "component">Direct Known Subclasses<cfelse>All Known Subinterfaces</cfif>:</h2>
	</div>
		<ul class="list-group list-group-flush">
			<cfloop query="arguments.qsubclass">
				<li class="list-group-item"><a href="#instance.class.root##replace(arguments.qsubclass.package, '.', '/', 'all')#/#arguments.qsubclass.name#.html" title="class in #arguments.package#">#arguments.qsubclass.name#</a></li>
			</cfloop>
		</ul>
	</div>
</cfif>

<!---
<dl>
<dt>

<cfscript>
	local.buffer.setLength(0);
	//local.buffer.append("public ");
	if(isAbstractClass(name, arguments.package))
	{
		local.buffer.append("abstract ");
	}

	if(arguments.metadata.type eq "interface")
	{
		local.buffer.append("interface");
	}
	else
	{
		local.buffer.append("class");
	}

	local.buffer.append(" <strong>#arguments.name#</strong>");
	local.buffer.append(local.ls);
	if(StructKeyExists(arguments.metadata, "extends"))
	{
		local.extendsmeta = arguments.metadata.extends;
		if(arguments.metadata.type eq "interface")
		{
			local.extendsmeta = arguments.metadata.extends[structKeyList(local.extendsmeta)];
		}
		local.buffer.append("<dt>extends #writeClassLink(getPackage(local.extendsmeta.name), getObjectName(local.extendsmeta.name), arguments.qMetaData, 'short')#</dt>");
	}
</cfscript>

<div class="p-2 bg-med-grey w-100 mb-3"><code class="text-dark">#local.buffer.tostring()#</code></div>

</dt>
</dl>
--->

<cfif StructKeyExists(arguments.metadata, "hint")>
<div id="class-hint">
	<p>#arguments.metadata.hint#</p>
</div>
</cfif>

<!-- Clas Attributes -->
<div class="card mb-4">
	<div class="card-header">
		<h2 id="class_attributes" class="fs-4 mb-0">Class Attributes:</strong>
	</div>
	<ul class="flex-fill flex-row flex-wrap p-4 m-0">
		<cfset local.cfcAttributesCount = 0>
		<cfloop collection="#arguments.metadata#" item="local.cfcmeta">
			<cfif isSimpleValue( arguments.metadata[ local.cfcmeta ] ) AND
				!listFindNoCase( "hint,extends,fullname,functions,hashcode,name,path,properties,type,remoteaddress", local.cfcmeta ) >
			<cfset local.cfcAttributesCount++>
			<li class="badge text-bg-secondary">
				#lcase( local.cfcmeta )#
				<cfif len( arguments.metadata[ local.cfcmeta ] )>
				: <code class="text-light">#arguments.metadata[ local.cfcmeta ]#</code>
				</cfif>
			</li>
			</cfif>
		</cfloop>
		<cfif local.cfcAttributesCount eq 0>
			<span class="label label-warning"><em>None</em></span>
		</cfif>
	</ul>
</div>

<cfscript>
	instance.class.cache = StructNew();
	local.localFunctions = StructNew();

	local.qFunctions = buildFunctionMetaData(arguments.metadata);
	local.qProperties = buildPropertyMetadata(arguments.metadata);

	local.qInit = getMetaSubQuery(local.qFunctions, "UPPER(name)='INIT'");
</cfscript>

<cfif local.qProperties.recordCount>
<div class="card mb-4">
	<div class="card-header">
		<h2 id="property_summary" class="fs-4 mb-0">Property Summary</h2>
	</div>
	<ul class="list-group list-group-flush">

		<cfloop query="local.qproperties">
			<cfset local.prop = local.qproperties.metadata />
			<cfset local.localproperties[ local.prop.name ] = 1 />
			<li class="list-group-item">
				<div class="row">
					<div class="col col-4">#local.prop.access# #local.prop.type# #local.prop.name#</div>
					<div class="col">
						<cfif StructKeyExists( local.prop, "hint" ) AND Len( local.prop.hint )>
						<!-- only grab the first sentence of the hint -->
						#repeatString( '&nbsp;', 5)# #listGetAt( local.prop.hint, 1, chr(13)&chr(10)&'.' )#.
						</cfif>
						<ul>
							<cfloop collection="#local.prop#" item="local.propmeta">
								<cfif not listFindNoCase( "hint,name,type,serializable,required,access,returntype", local.propmeta ) && local.prop[ local.propmeta ] != "" >
								<li class="label label-default label-annotations"><code class="text-bg-light">#lcase( local.propmeta )# = #local.prop[ local.propmeta ]#</code></li>
								</cfif>
							</cfloop>
							<cfif local.prop.required>
								<li class="label label-default label-annotations">Required</li>
							</cfif>
						</ul>
					</div>
				</div>
			</li>
		</cfloop>
	</ul>
</div>
</cfif>

<cfif local.qInit.recordCount>
	<cfset local.init = local.qInit.metadata />
	<cfset local.localFunctions[local.init.name] = 1 />
	<!-- ======== CONSTRUCTOR SUMMARY ======== -->

	<div class="card mb-4">
		<div class="card-header">
			<h2 class="fs-4 mb-0" id="constructor_summary">Constructor Summary</h2>
		</div>
		<div class="card-body">
			<div class="row">
				<cfif local.init.access neq "public">
					<div class="col col-2" align="right" valign="top" width="1%">
						<code>#local.init.access# </code>
					</div>
				</cfif>
				<div class="col">
					#writemethodlink(arguments.name, arguments.package, local.init, arguments.qmetadata)#
					<br>
					<cfif StructKeyExists(local.init, "hint") and len( local.init.hint ) >
					#repeatString( '&nbsp;', 5)# #listGetAt( local.init.hint, 1, chr(13)&chr(10)&'.' )#.
					</cfif>
				</div>
			</div>
		</div>
	</div>
</cfif>

<cfset local.qFunctions = getMetaSubQuery(local.qFunctions, "UPPER(name)!='INIT'") />

<cfif local.qFunctions.recordCount>
<!-- ========== METHOD SUMMARY =========== -->

<div class="card mb-4">
	<div class="card-header">
		<h2 class="fs-4 mb-0" id="method_summary">Method Summary</h2>
	</div>
	<div class="card-body">
		<cfloop query="local.qFunctions">
		<cfset local.func = local.qFunctions.metadata />
		<cfset local.localFunctions[ local.func.name ] = 1 />
			<div class="row">
				<div class="col col-3">
					<code><cfif local.func.access neq "public">#local.func.access#&nbsp;</cfif>#writetypelink(local.func.returntype, arguments.package, arguments.qmetadata, local.func)#</code>
				</div>
				<div class="col">
					#writemethodlink(arguments.name, arguments.package, local.func, arguments.qmetadata)#
					<br>
					<cfif StructKeyExists(local.func, "hint") AND Len(local.func.hint)>
					#repeatString( '&nbsp;', 5)##listGetAt( local.func.hint, 1, chr(13)&chr(10)&'.' )#.
					</cfif>
				</div>
			</div>
		</cfloop>
	</div>
</div>

</cfif>

<div id="inherited_methods">
	<cfset local.localmeta = arguments.metadata />
	<cfloop condition="#StructKeyExists(local.localmeta, 'extends')#">
		<cfscript>
			if(local.localmeta.type eq "interface")
			{
				local.localmeta = local.localmeta.extends[structKeyList(local.localmeta.extends)];
			}
			else
			{
				local.localmeta = local.localmeta.extends;
			}
		</cfscript>

		<cfset local.qFunctions = buildFunctionMetaData(local.localmeta)>

		<cfset local.buffer.setLength(0) />
		<cfset i = 1 />
		<cfloop query="local.qFunctions">
			<cfset local.func = local.qFunctions.metadata />
			<cfif NOT StructKeyExists(local.localFunctions, local.func.name)>
			<cfif i++ neq 1>
				<cfset local.buffer.append(", ") />
			</cfif>
			<cfset local.buffer.append('<a href="#instance.class.root##replace(getPackage(local.localmeta.name), '.', '/', 'all')#/#getObjectName(local.localmeta.name)#.html###local.func.name#()">#local.func.name#</a>') />
			<cfset local.localFunctions[local.func.name] = 1 />
			</cfif>
		</cfloop>
		&nbsp;
		<cfif local.buffer.length()>
			<div class="card">
				<div class="card-header">
					<strong id="methods_inherited_from_class_#local.localmeta.name#">Methods inherited from class <code>#writeClassLink(getPackage(local.localmeta.name), getObjectName(local.localmeta.name), arguments.qMetaData, 'long')#</code></strong>
				</div>
				<div class="card-body">
					<cfif local.buffer.length()>
						#local.buffer.toString()#
					<cfelse>
						<span class="label label-warning"><em>None</em></span>
					</cfif>
				</div>
			</div>
		</cfif>
	</cfloop>
</div>

<!-- ========= CONSTRUCTOR DETAIL ======== -->
<cfif StructKeyExists(local, "init")>
	<div class="container-xl mb-4 pb-4">
		<h2 class="fs-4 mb-0" id="constructor_detail">Constructor Detail</h2>

		<h3 id="#local.init.name#()">#local.init.name#</h3>
		<div class="p-2 px-4 bg-med-grey w-100 mb-3"><code class="text-dark">#local.init.access# #writeMethodLink(arguments.name, arguments.package, local.init, arguments.qMetaData, false)#</code></div>

		<div class="px-4">
			<cfif StructKeyExists(local.init, "hint")>
			<p>#local.init.hint#</p>
			</cfif>

			<cfif StructKeyExists(local.init, "parameters") AND ArrayLen(local.init.parameters)>
			<dl>
				<dt><strong>Parameters:</strong></dt>
				<cfloop array="#local.init.parameters#" index="local.param">
					<dd><code>#local.param.name#</code><cfif StructKeyExists(local.param, "hint")> - #local.param.hint#</cfif></dd>
				</cfloop>
			</dl>
			</cfif>
		</div>
	</div>
</cfif>

<!-- ============ PROPERTY DETAIL ========== -->
<cfif local.qProperties.recordCount>
	<h2 class="fs-4 mb-0" id="property_detail">Property Detail</h2>

	<cfloop query="local.qProperties">
		<cfset local.prop = local.qProperties.metadata />
		<div class="container-xl mb-4 pb-4">
			<h3 id="#local.prop.name#">#local.prop.name#</h3>

			<div class="p-2 bg-med-grey w-100 mb-3"><code class="text-dark">property #writeTypeLink(local.prop.type, arguments.package, arguments.qMetaData, local.prop)#
				#writeMethodLink(arguments.name, arguments.package, local.prop, arguments.qMetaData, false)#
				<cfif structKeyExists( local.prop, "default" ) and len( local.prop.default )>
				= [#local.prop.default#]
				</cfif>
				</code>
			</div>

			<div class="px-4">
				<cfif StructKeyExists(local.prop, "hint") AND Len(local.prop.hint)>
					<p>#local.prop.hint#</p>
				</cfif>

				<dl>
				<dt><strong>Attributes:</strong></dt>
				<cfloop collection="#local.prop#" item="local.param">
					<cfif not listFindNoCase( "name,type,hint,default", local.param )>
					<dd><code>#lcase( local.param )#</code> - #local.prop[ local.param ]#</dd>
					</cfif>
				</cfloop>
				</dl>
			</div>
		</div>
	</cfloop>
</cfif>



<cfset local.qFunctions = buildFunctionMetaData(arguments.metadata) />
<cfset local.qFunctions = getMetaSubQuery(local.qFunctions, "UPPER(name)!='INIT'") />

<cfif local.qFunctions.recordCount>

<!-- ============ METHOD DETAIL ========== -->

<h2 id="method_detail">Method Detail</h2>

<cfloop query="local.qFunctions">
	<cfset local.func = local.qFunctions.metadata />
	<div class="container-xl mb-4 pb-4" id="#local.func.name#()">
		<h3 class="visually-hidden">
			#local.func.name#
			<cfif structKeyExists( local.func, "deprecated" )>Deprecated</span></cfif>
		</h3>

		<div class="p-2 bg-med-grey w-100 mb-3"><code class="text-dark">#local.func.access# #writeTypeLink(local.func.returnType, arguments.package, arguments.qMetaData, local.func)# #writeMethodLink(arguments.name, arguments.package, local.func, arguments.qMetaData, false)#</code></div>

		<div class="px-4">
			<cfif structKeyExists( local.func, "deprecated" )>
				<span class="label label-danger">
			</cfif>
			<cfif StructKeyExists(local.func, "hint") AND Len(local.func.hint)>
				<p>#local.func.hint#</p>
			</cfif>

			<cfif StructKeyExists(local.func, "deprecated") AND isSimplevalue(local.func.deprecated)>
				<dl>
					<dt><span class="label label-danger"><strong>Deprecated:</strong></span></dt>
					<dd>#local.func.deprecated#</dd>
				</dl>
			</cfif>

			<cfif arguments.metadata.type eq "component">
				<cfset local.specified = findSpecifiedBy(arguments.metaData, local.func.name) />
				<cfif Len(local.specified)>
					<dl>
						<dt><strong>Specified by:</strong></dt>
						<dd>
						<code>
						<a href="#instance.class.root##replace(getPackage(local.specified), '.', '/', 'all')#/#getObjectName(local.specified)#.html###local.func.name#()">#local.func.name#</a></code>
						in interface
						<code>
							#writeClassLink(getPackage(local.specified), getObjectName(local.specified), arguments.qMetaData, 'short')#
						</code>
						</dd>
					</dl>
				</cfif>
			</cfif>

			<cfset local.overWrites = findOverwrite(arguments.metaData, local.func.name) />
			<cfif Len(local.overWrites)>
				<dl>
					<dt><strong>Overrides:</strong></dt>
					<dd>
					<code>
					<a href="#instance.class.root##replace(getPackage(local.overWrites), '.', '/', 'all')#/#getObjectName(local.overWrites)#.html###local.func.name#()">#local.func.name#</a></code>
					in class
					<code>
						#writeClassLink(getPackage(local.overWrites), getObjectName(local.overWrites), arguments.qMetaData, 'short')#
					</code>
					</dd>
				</dl>
			</cfif>

			<cfif StructKeyExists(local.func, "parameters") AND ArrayLen(local.func.parameters)>
				<dl>
				<dt><strong>Parameters:</strong></dt>
				<cfloop array="#local.func.parameters#" index="local.param">
				<dd><code>#local.param.name#</code><cfif StructKeyExists(local.param, "hint")> - #local.param.hint#</cfif></dd>
				</cfloop>
				</dl>
			</cfif>

			<cfif StructKeyExists(local.func, "return") AND isSimplevalue(local.func.return)>
				<dl>
					<dt><strong>Returns:</strong></dt>
					<dd>#local.func.return#</dd>
				</dl>
			</cfif>

			<cfif StructKeyExists(local.func, "throws") AND isSimplevalue(local.func.throws)>
				<dl>
					<dt><strong>Throws:</strong></dt>
					<dd>#local.func.throws#</dd>
				</dl>
			</cfif>

			</dl>
		</div>
	</div>
</cfloop>
</cfif>

</body>
</html>
</cfoutput>
<cfsilent>
	<cffunction name="writeMethodLink" hint="draws a method link" access="private" returntype="string" output="false">
		<cfargument name="name" hint="the name of the class" type="string" required="Yes">
		<cfargument name="package" hint="out current package" type="string" required="Yes">
		<cfargument name="func" hint="the function to link to" required="Yes">
		<cfargument name="qMetaData" hint="the meta daya query" type="query" required="Yes">
		<cfargument name="drawMethodLink" hint="actually draw the link on the method" type="boolean" required="No" default="true">
		<cfset var param = 0 />
		<cfset var i = 1 />
		<cfset var builder = createObject("java", "java.lang.StringBuilder").init() />
		<cfsilent>

		<cfif StructKeyExists(arguments.func, "parameters")>
			<cfset builder.append("(") />
				<cfloop array="#arguments.func.parameters#" index="param">
					<cfscript>
						if(i++ neq 1)
						{
							builder.append(", ");
						}

						if(NOT StructKeyExists(param, "required"))
						{
							param.required = false;
						}

						if(NOT param.required)
						{
							builder.append("[");
						}
					</cfscript>

					<cfscript>
						safeParamMeta(param);
						builder.append(writeTypeLink(param.type, arguments.package, arguments.qMetadata, param));

						builder.append(" " & param.name);

						if(StructKeyExists(param, "default"))
						{
							builder.append("='" & param.default & "'");
						}

						if(NOT param.required)
						{
							builder.append("]");
						}
					</cfscript>
				</cfloop>
			<cfset builder.append(")") />
		</cfif>

		</cfsilent>
		<cfif arguments.drawMethodLink>
			<cfreturn '<strong><a href="#arguments.name#.html###arguments.func.name#()">#arguments.func.name#</A></strong>#builder.toString()#'/>
		<cfelse>
			<cfreturn '<strong>#arguments.func.name#</strong>#builder.toString()#'/>
		</cfif>
	</cffunction>

	<cffunction name="writeTypeLink" hint="writes a link to a type, or a class" access="private" returntype="string" output="false">
		<cfargument name="type" hint="the type/class" type="string" required="Yes">
		<cfargument name="package" hint="the current package" type="string" required="Yes">
		<cfargument name="qMetaData" hint="the meta data query" type="query" required="Yes">
		<cfargument name="genericMeta" hint="optional meta that may contain generic type information" type="struct" required="No" default="#structNew()#">
		<cfscript>
			var result = createObject("java", "java.lang.StringBuilder").init();
			var local = {};

			if(isPrimitive(arguments.type))
			{
				result.append(arguments.type);
			}
			else
			{
				arguments.type = resolveClassName(arguments.type, arguments.package);
				result.append(writeClassLink(getPackage(arguments.type), getObjectName(arguments.type), arguments.qMetaData, 'short'));
			}

			if(NOT structIsEmpty(arguments.genericMeta))
			{
				local.array = getGenericTypes(arguments.genericMeta, arguments.package);
				if(NOT arrayIsEmpty(local.array))
				{
					result.append("&lt;");

					local.len = ArrayLen(local.array);
                    for(local.counter=1; local.counter lte local.len; local.counter++)
                    {
						if(local.counter neq 1)
						{
							result.append(",");
						}

                    	local.generic = local.array[local.counter];
						result.append(writeTypeLink(local.generic, arguments.package, arguments.qMetaData));
                    }

					result.append("&gt;");
				}
			}

			return result.toString();
        </cfscript>
	</cffunction>

	<cfscript>
		/*
		function getArgumentList(func)
		{
			var list = "";
			var len = 0;
			var counter = 1;
			var param = 0;

			if(StructKeyExists(arguments.func, "parameters"))
			{
				len = ArrayLen(arguments.func.parameters);
				for(; counter lte len; counter = counter + 1)
				{
					param = safeParamMeta(arguments.func.parameters[counter]);
					list = listAppend(list, param.type);
				}
			}

			return list;
		}
		*/

		function writeClassLink(package, name, qMetaData, format)
		{
			var qClass = getMetaSubQuery(arguments.qMetaData, "LOWER(package)=LOWER('#arguments.package#') AND LOWER(name)=LOWER('#arguments.name#')");
			var builder = 0;
			var safeMeta = 0;
			var title = 0;

			if(qClass.recordCount)
			{
				safeMeta = StructCopy(qClass.metadata);

				title = "class";
				if(safeMeta.type eq "interface")
				{
					title = "interface";
				}

				builder = createObject("java", "java.lang.StringBuilder").init();
				builder.append('<a href="#instance.class.root##replace(qClass.package, '.', '/', 'all')#/#qClass.name#.html" title="#title# in #qClass.package#">');
				if(arguments.format eq "short")
				{
					builder.append(qClass.name);
				}
				else
				{
					builder.append(qClass.package & "." & qClass.name);
				}
				builder.append("</a>");

				return builder.toString();
			}

			return package & "." & name;
		}

		function getInheritence(metadata)
		{
			var localmeta = arguments.metadata;
			var inheritence = [arguments.metadata.name];

			while(StructKeyExists(localmeta, "extends"))
			{
				//manage interfaces
				if(localmeta.type eq "interface")
				{
					localmeta = localmeta.extends[structKeyList(localmeta.extends)];
				}
				else
				{
					localmeta = localmeta.extends;
				}

				ArrayPrepend(inheritence, localmeta.name);
			}

			return inheritence;
		}

		function getImplements(metadata)
		{
			var localmeta = arguments.metadata;
			var interfaces = {};
			var key = 0;
			var imeta = 0;

			while(StructKeyExists(localmeta, "extends"))
			{
				if(StructKeyExists(localmeta, "implements"))
				{
					for(key in localmeta.implements)
					{
						imeta = localmeta.implements[local.key];
						interfaces[imeta.name] = 1;
					}
				}
				localmeta = localmeta.extends;
			}

			interfaces = structKeyArray(interfaces);

			arraySort(interfaces, "textnocase");

			return interfaces;
		}

		function findOverwrite(metadata, functionName)
		{
			var qFunctions = 0;

			while(StructKeyExists(arguments.metadata, "extends"))
			{
				if(arguments.metadata.type eq "interface")
				{
					arguments.metadata = arguments.metadata.extends[structKeyList(arguments.metadata.extends)];
				}
				else
				{
					arguments.metadata = arguments.metadata.extends;
				}

				qFunctions = buildFunctionMetaData(arguments.metadata);
				qFunctions = getMetaSubQuery(qFunctions, "name='#arguments.functionName#'");

				if(qFunctions.recordCount)
				{
					return arguments.metadata.name;

				}
			}

			return "";
		}

		function findSpecifiedBy(metadata, functionname)
		{
			var imeta = 0;
			var qFunctions = 0;
			var key = 0;

			if(structKeyExists(arguments.metadata, "implements"))
			{
				for(key in arguments.metadata.implements)
				{
					imeta = arguments.metadata.implements[local.key];

					qFunctions = buildFunctionMetaData(imeta);
					qFunctions = getMetaSubQuery(qFunctions, "name='#arguments.functionName#'");

					if(qFunctions.recordCount)
					{
						return imeta.name;
					}

					//now look up super-interfaces
					while(structKeyExists(imeta, "extends"))
					{
						imeta = imeta.extends[structKeyList(imeta.extends)];

						qFunctions = buildFunctionMetaData(imeta);
						qFunctions = getMetaSubQuery(qFunctions, "name='#arguments.functionName#'");

						if(qFunctions.recordCount)
						{
							return imeta.name;
						}
					}
				}

			}

			return "";
		}

		//stupid cleanup

		StructDelete(variables, "findOverwrite");
		StructDelete(variables, "writeTypeLink");
		StructDelete(variables, "writeMethodLink");
		StructDelete(variables, "getArgumentList");
		StructDelete(variables, "writeClassLink");
		StructDelete(variables, "getInheritence");
		StructDelete(variables, "writeObjectLink");
		StructDelete(variables, "getImplements");
		StructDelete(variables, "findSpecifiedBy");

		//store for resident data
		StructDelete(variables.instance, "class");
	</cfscript>
</cfsilent>
</div>