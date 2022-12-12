/**
 * @author Luis Majano <lmajano@ortussolutions.com>
 *
 * Core DocBox documentation class that takes care of generating docs for you.
 * You can initialize the object with a strategy and strategy properties or with nothing at all.
 * You can then generate the docs according to 1 or more output strategies via the <code>generate()</code> method.
 * <hr>
 * <small><em>Copyright 2015 Ortus Solutions, Corp <a href="www.ortussolutions.com">www.ortussolutions.com</a></em></small>
 */
component accessors="true" {

	/**
	 * Array of structs pointing to source code with mapping names.
	 * 
	 * For example:
	 * 
	 * [
	 * 	{
	 * 		"dir" : "/var/www/html/myProject",
	 * 		"mapping" : "myProject"
	 * 	}
	 * ]
	 */
	property name="sources" type = "array";

	/**
	 * Array of regex patterns to exclude from source inputs.
	 * Files matching any of these patterns will be removed from the source inputs.
	 * 
	 * For example: [ "coldbox|testbox", "docbox" ]
	 */
	property name="excludes" type = "array";

	/**
	 * String pointing where the generated output should be saved to disk.
	 */
	property name="outputDir" type = "string" default="";

	/**
	 * Throw an error and halt the generation process if DocBox encounters an invalid component.
	 */
	property name="throwOnError" type="boolean" default="false";

	/**
	 * Turn on debug logs, off by default.
	 */
	property name="loggingEnabled" type="boolean" default="false";

	/**
	 * The strategy to use for document generation. Must extend docbox.strategy.AbstractTemplateStrategy
	 */
	property
		name       ="strategies"
		type       ="array"
		doc_generic="docbox.strategy.AbstractTemplateStrategy";

	/**
	 * Constructor
	 *
	 * @strategy The documentation output strategy to utilize.
	 * @properties Struct of data properties required for the specific output strategy
	 *
	 * @return The DocBox instance
	 */
	DocBox function init(
		any strategy      = "",
		struct properties = {}
	){
		variables.sources	 = [];
		variables.excludes	 = [];
		variables.strategies = [];
		variables.properties = arguments.properties;

		// If we have a strategy, then add it in
		if ( len( arguments.strategy ) ) {
			addStrategy(
				strategy   = arguments.strategy,
				properties = arguments.properties
			);
		}

		return this;
	}

	/**
	 * Add a source path (and optional mapping) to the configured source list.
	 * 
	 * @source
	 * @mapping A string name to use when mapping the source code. Specify this if the directory name doesn't match the reference name. For example, `extends="docbox.Docbox"` could use a `docbox` mapping to point to `/libs/docboxSrc/`.
	 */
	DocBox function src( required any source, string mapping = "" ){
		if ( isSimpleValue( arguments.source ) ) {
			variables.sources.append(
				{
					"dir"     : arguments.source,
					"mapping" : len( arguments.mapping ) ? arguments.mapping : reReplace( arguments.source, "/", ".", "all" )
				}
			);
		} else {
			variables.sources.append( arguments.source );
		}
		return this;
	}

	/**
	 * Append a regex partial to exclude file paths from docs generation.
	 *
	 * @exclude	A regex that will be applied to the input source to exclude from the docs
	 */
	DocBox function exclude( required string exclude ){
		variables.excludes.append( arguments.exclude );
		return this;
	}

	/**
	 * Set the disk location of the generated documentation.
	 *
	 * @outputDir Full (expanded) path to the desired location of the generated docs.
	 */
	DocBox function outputDir( required string outputDir ){
		variables.outputDir = arguments.outputDir;
		return this;
	}

	/**
	 * Enable throwing an error upon encountering an invalid source file.
	 * 
	 * @throwOnError Omit or pass 'true' to enable throwing.
	 */
	DocBox function throwOnError( boolean throwOnError = true ){
		setThrowOnError( arguments.throwOnError );
		return this;
	}

	/**
	 * Output logging to the server console (System.Out) for each file INcluded or EXcluded in the documentation.
	 *
	 * @loggingEnabled True to enable, false to disable. Calling this method with no parameter will turn ON debugging.
	 */
	DocBox function withFileLogging( boolean loggingEnabled = true ){
		setLoggingEnabled( arguments.loggingEnabled );
		return this;
	}

	/**
	 * Backwards-compatible setter to add a strategy to the docbox configuration.
	 *
	 * @see addStrategy
	 *
	 * @return The DocBox instance
	 */
	DocBox function setStrategy(){
		return addStrategy( argumentCollection = arguments );
	}

	/**
	 * Add a documentation strategy for output format.
	 *
	 * @strategy The optional strategy to generate the documentation with. This can be a class path or an instance of the  strategy. If none is passed then
	 * we create the default strategy of 'docbox.strategy.api.HTMLAPIStrategy'
	 * @properties The struct of properties to instantiate the strategy with.
	 *
	 * @return The DocBox instance
	 */
	DocBox function addStrategy(
		any strategy      = "docbox.strategy.api.HTMLAPIStrategy",
		struct properties = {}
	){
		// Set the incomign strategy to store
		var newStrategy = arguments.strategy;

		// If the strategy is not an object, then look it up
		if ( isSimpleValue( newStrategy ) ) {
			// Discover the strategy
			switch ( uCase( arguments.strategy ) ) {
				case "CommandBox":
					arguments.strategy = "docbox.strategy.CommandBox.CommandBoxStrategy";
					break;
				case "HTML":
				case "HTMLAPISTRATEGY":
					arguments.strategy = "docbox.strategy.api.HTMLAPIStrategy";
					break;
				case "JSON":
				case "JSONAPISTRATEGY":
					arguments.strategy = "docbox.strategy.json.JSONAPIStrategy";
					break;
				case "UML":
				case "XMI":
				case "XMISTRATEGY":
					arguments.strategy = "docbox.strategy.uml2tools.XMIStrategy";
				default:
					break;
			}
		}
		setStrategies( getStrategies().append( {
			strategy  : arguments.strategy,
			properties: arguments.properties
		} ) );
		return this;
	}

	/**
	 * Fluent-style method to kick off a new documentation run.
	 */
	DocBox function run(){
		// verify we have at least one strategy defined, if not, auto add the HTML strategy
		if ( isNull( getStrategies() ) || !getStrategies().len() ) {
			this.addStrategy( strategy : "HTML", properties : variables.properties );
		}

		// build metadata collection
		var metadata = buildMetaDataCollection();

		getStrategies().each( function( strategy ){
			param strategy.properties.outputDir = getOutputDir();
			if ( isSimpleValue( strategy.strategy ) ){
				new "#strategy.strategy#"( argumentCollection = strategy.properties ).run( metadata );
			} else {
				strategy.strategy.run( metadata );
			}
		} );
		return this;
	}

	/**
	 * Generate the docs
	 * 
	 * !Deprecated! Please use the new run() method and related fluent syntax.
	 *
	 * @source Either, the string directory source, OR an array of structs containing 'dir' and 'mapping' key
	 * @mapping The base mapping for the folder. Only required if the source is a string
	 * @excludes	A regex that will be applied to the input source to exclude from the docs
	 * @throwOnError Throw an error and halt the generation process if DocBox encounters an invalid component.
	 *
	 * @return The DocBox instance
	 */
	DocBox function generate(
		required source,
		string mapping  = "",
		string excludes = "",
		boolean throwOnError = false
	){
		return this
			// handle source args for backwards compat
			.src( source = arguments.source, mapping = arguments.mapping )

			// handle excludes for backwards compat
			.exclude( exclude = arguments.excludes )

			// handle throwOnError for backwards compat
			.throwOnError( arguments.throwOnError )

			.run();
	}

	/************************************ PRIVATE ******************************************/

	/**
	 * Clean input path
	 *
	 * @path The incoming path to clean
	 * @inputDir The input dir to clean off
	 */
	private function cleanPath( required path, required inputDir ){
		var currentPath = replace(
			getDirectoryFromPath( arguments.path ),
			arguments.inputDir,
			""
		);
		currentPath = reReplace( currentPath, "^[/\\]", "" );
		currentPath = reReplace( currentPath, "[/\\]", ".", "all" );
		return reReplace( currentPath, "\.$", "" );
	}

	/**
	 * Builds the searchable meta data collection
	 */
	query function buildMetaDataCollection(){
		var metadata = queryNew( "package,name,extends,metadata,type,implements,fullextends,currentMapping" );

		// iterate over input sources
		for ( var source in getSources() ) {
			if ( !directoryExists( source.dir ) ){
				throw(
					message = "Invalid configuration; source directory not found",
					type = "InvalidConfigurationException",
					detail ="Configured source #source.dir# does not exist."
				);
			}
			directoryList( source.dir, true, "path", "*.cfc" )
			.filter(function( thisFile ){
				// Use relative file path so placement on disk doesn't affect the regex check
				var relativeFilePath = replace( thisFile, source.dir, "" );
				var excluded = getExcludes().len() && getExcludes().some( ( exclude ) => {
					if ( getLoggingEnabled() && reFindNoCase( exclude, relativeFilePath ) ){
						writeDump( var = "Skipping file #relativeFilePath# based on exclusion: #exclude#", output = "console" );
					}
					return reFindNoCase( exclude, relativeFilePath );
				});

				// Core Excludes, don't document the Application.cfc
				var isApplicationCFC = listFirst( getFileFromPath( relativeFilePath ), "." ) == "Application";
				return !excluded && !isApplicationCFC;
			}).each(function( thisFile ){
				if ( getLoggingEnabled() ){
					writeDump( var = "pulling docs for #thisFile#", output = "console" );
				}
				// get current path
				var currentPath = cleanPath( thisFile, source.dir );

				// calculate package path according to mapping
				var packagePath = source.mapping;
				if ( len( currentPath ) ) {
					packagePath = listAppend( source.mapping, currentPath, "." );
				}
				// setup cfc name
				var cfcName = listFirst( getFileFromPath( thisFile ), "." );

				try {
					// Get component metadatata
					var meta = "";
					if ( len( packagePath ) ) {
						meta = getComponentMetadata( packagePath & "." & cfcName );
					} else {
						meta = getComponentMetadata( cfcName );
					}

					// let's do some cleanup, in case CF sucks.
					if ( len( packagePath ) AND NOT meta.name contains packagePath ) {
						meta.name = packagePath & "." & cfcName;
					}

					// Add row
					queryAddRow( metadata );
					// Add contents
					querySetCell( metadata, "package", packagePath );
					querySetCell( metadata, "name", cfcName );
					querySetCell( metadata, "metadata", meta );
					querySetCell( metadata, "type", meta.type );
					querySetCell(
						metadata,
						"currentMapping",
						source.mapping
					);

					// Get implements
					var implements = getImplements( meta );
					implements     = listQualify( arrayToList( implements ), ":" );
					querySetCell( metadata, "implements", implements );

					// Get inheritance
					var fullextends = getInheritance( meta );
					fullextends     = listQualify( arrayToList( fullextends ), ":" );
					querySetCell( metadata, "fullextends", fullextends );

					// so we can easily query direct descendants
					if ( structKeyExists( meta, "extends" ) ) {
						if ( meta.type eq "interface" ) {
							querySetCell(
								metadata,
								"extends",
								meta.extends[ structKeyList( meta.extends ) ].name
							);
						} else {
							querySetCell(
								metadata,
								"extends",
								meta.extends.name
							);
						}
					} else {
						querySetCell( metadata, "extends", "-" );
					}
				} catch ( Any e ) {
					if ( getThrowOnError() ){
						throw(
							type         = "InvalidComponentException",
							message      = e.message,
							detail       = e.detail,
							extendedInfo = serializeJSON( e )
						);
					} else {
						trace(
							type     = "warning",
							category = "docbox",
							inline   = "true",
							text     = "Warning! The following script has errors: " & packagePath & "." & cfcName & ": #e.message & e.detail & e.stacktrace#"
						);
					}
					if ( structKeyExists( server, "lucee" ) ) {
						systemOutput(
							"Warning! The following script has errors: " & packagePath & "." & cfcName,
							true
						);
						systemOutput( "#e.message & e.detail#", true );
						systemOutput( e.stackTrace );
					}
				}
			});
			// end qFiles iteration
		}
		// end input source iteration

		return metadata;
	}

	/**
	 * Gets an array of the classes that this metadata implements, in order of extension
	 *
	 * @metadata The metadata to look at
	 *
	 * @return array of component interfaces implemented by some component in this package
	 */
	private array function getImplements( required struct metadata ){
		var interfaces = {};

		// check if a cfc
		if ( arguments.metadata.type neq "component" ) {
			return [];
		}
		// iterate
		while ( structKeyExists( arguments.metadata, "extends" ) ) {
			if ( structKeyExists( arguments.metadata, "implements" ) ) {
				for ( var key in arguments.metadata.implements ) {
					interfaces[ arguments.metadata.implements[ key ].name ] = 1;
				}
			}
			arguments.metadata = arguments.metadata.extends;
		}
		// get as an array
		interfaces = structKeyArray( interfaces );
		// sort it
		arraySort( interfaces, "textnocase" );

		return interfaces;
	}

	/**
	 * Gets an array of the classes that this metadata extends, in order of extension
	 *
	 * @metadata The metadata to look at
	 *
	 * @return array of classes inherited by some component in this package
	 */
	private array function getInheritance( required struct metadata ){
		// ignore top level
		var inheritence = [];

		while ( structKeyExists( arguments.metadata, "extends" ) ) {
			// manage interfaces
			if ( arguments.metadata.type == "interface" ) {
				arguments.metadata = arguments.metadata.extends[ structKeyList( arguments.metadata.extends ) ];
			} else {
				arguments.metadata = arguments.metadata.extends;
			}

			arrayPrepend( inheritence, arguments.metadata.name );
		}

		return inheritence;
	}

	/**
	 * Undocumented function
	 *
	 * @deprecated This is no longer in use.
	 * @param1 param 1
	 * @param2 param 2
	 *
	 * @throws Throws X,Y and Z
	 *
	 * @return Nothing
	 */
	function testFunction( param1, param2 ){
	}

}
