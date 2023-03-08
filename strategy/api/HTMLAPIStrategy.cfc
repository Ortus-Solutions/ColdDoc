/**
 * Default Document Strategy for DocBox
 * <br>
 * <small><em>Copyright 2015 Ortus Solutions, Corp <a href="www.ortussolutions.com">www.ortussolutions.com</a></em></small>
 */
component extends="docbox.strategy.AbstractTemplateStrategy" accessors="true" {

	/**
	 * The output directory
	 */
	property name="outputDir" type="string";

	/**
	 * The project title to use
	 */
	property
		name   ="projectTitle"
		default="Untitled"
		type   ="string";

	/**
	 * Set the HTML output theme.
	 * 
	 * Stored as a struct with keys 'name' and 'opts':
	 * {
	 * 	"name" : "Shades of Purple",
	 * 	"opts" : {
	 * 		"show_search" : false
	 * 	}
	 * }
	 */
	property name="theme" type="struct";

	/**
	 * Where HTML templates are stored
	 */
	variables.THEME_PATH = "/docbox/themes";

	/**
	 * Constructor
	 * @outputDir The output directory
	 * @projectTitle The title used in the HTML output
	 */
	HTMLAPIStrategy function init(
		required outputDir,
		string projectTitle = "Untitled",
		struct theme = {
			"name" : "default",
			"opts" : {}
		}
	){
		super.init();

		variables.outputDir    = arguments.outputDir;
		variables.projectTitle = arguments.projectTitle;
		variables.theme        = arguments.theme;

		return this;
	}

	/**
	 * Run this strategy
	 * 
	 * @qMetaData The metadata
	 * @throws InvalidConfigurationException if directory does not exist or other invalid configuration is detected
	 */
	HTMLAPIStrategy function run( required query qMetadata ){
		if ( !directoryExists( getOutputDir() ) ){
			throw(
				message = "Invalid configuration; output directory not found",
				type = "InvalidConfigurationException",
				detail = "OutputDir #getOutputDir()# does not exist."
			);
		}
		// copy over the static assets
		directoryCopy(
			expandPath( getThemeAssetsPath() ),
			getOutputDir(),
			true
		);

		// Generate json source data for Alpine/HTML-based templates
		var jsonSourceDirectory = getOutputDir() & "/data/";
		ensureDirectory( jsonSourceDirectory );
		new docbox.strategy.json.JSONAPIStrategy(
			outputDir = jsonSourceDirectory,
			projectTitle = getProjectTitle()
		).run( arguments.qMetadata );

		// write the index template
		writeTemplate( 
			path         : getOutputDir() & "/index.html",
			template     : "#getThemePath()#/index.cfm",
			args = {
				projectTitle : getProjectTitle()
			}
		)
			// Write overview summary and frame
			.writeOverviewSummaryAndFrame( arguments.qMetaData )
			// Write classes frame
			.writeAllClassesFrame( arguments.qMetaData )
			// Write packages
			.writePackagePages( arguments.qMetaData );

		return this;
	}

	/**
	 * writes the package summaries
	 * @qMetaData The metadata
	 */
	HTMLAPIStrategy function writePackagePages( required query qMetadata ){
		var currentDir  = 0;
		var qPackage    = 0;
		var qClasses    = 0;
		var qInterfaces = 0;

		// done this way as ACF compat. Does not support writeoutput with query grouping.
		include "#getThemePath()#/packagePages.cfm";

		return this;
	}

	/**
	 * builds the class pages
	 * @qPackage the query for a specific package
	 * @qMetaData The metadata
	 */
	HTMLAPIStrategy function buildClassPages(
		required query qPackage,
		required query qMetadata
	){
		for ( var thisRow in arguments.qPackage ) {
			var currentDir = variables.outputDir & "/" & replace( thisRow.package, ".", "/", "all" );
			var safeMeta   = structCopy( thisRow.metadata );

			// Is this a class
			if ( safeMeta.type eq "component" ) {
				var qSubClass = getMetaSubquery(
					arguments.qMetaData,
					"UPPER( extends ) = UPPER( '#thisRow.package#.#thisRow.name#' )",
					"package asc, name asc"
				);
				var qImplementing = queryNew( "" );
			} else {
				// all implementing subclasses
				var qSubClass = getMetaSubquery(
					arguments.qMetaData,
					"UPPER(fullextends) LIKE UPPER('%:#thisRow.package#.#thisRow.name#:%')",
					"package asc, name asc"
				);
				var qImplementing = getMetaSubquery(
					arguments.qMetaData,
					"UPPER(implements) LIKE UPPER('%:#thisRow.package#.#thisRow.name#:%')",
					"package asc, name asc"
				);
			}

			// write it out
			writeTemplate(
				path          = currentDir & "/#thisRow.name#.html",
				template      = "#getThemePath()#/class.cfm",
				args          = {
					projectTitle  = variables.projectTitle,
					package       = thisRow.package,
					name          = thisRow.name,
					qSubClass     = qSubClass,
					qImplementing = qImplementing,
					qMetadata     = qMetaData,
					metadata      = safeMeta
				}
			);
		}

		return this;
	}


	/**
	 * writes the overview-summary.html
	 * @qMetaData The metadata
	 */
	HTMLAPIStrategy function writeOverviewSummaryAndFrame( required query qMetadata ){
		var qPackages = new Query(
			dbtype = "query",
			md     = arguments.qMetadata,
			sql    = "
			SELECT DISTINCT package
			FROM md
			ORDER BY package"
		).execute().getResult();

		// overview summary
		writeTemplate(
			path         = getOutputDir() & "/overview-summary.html",
			template     = "#getThemePath()#/overview-summary.cfm",
			args         = {
				projectTitle = getProjectTitle(),
				qPackages    = qPackages
			}
		);

		// overview frame
		writeTemplate(
			path         = getOutputDir() & "/overview-frame.html",
			template     = "#getThemePath()#/overview-frame.cfm",
			args         = {
				projectTitle = getProjectTitle(),
				qMetadata    = arguments.qMetadata
			}
		);

		return this;
	}

	/**
	 * writes the allclasses-frame.html
	 * @qMetaData The metadata
	 */
	HTMLAPIStrategy function writeAllClassesFrame( required query qMetadata ){
		arguments.qMetadata = getMetaSubquery(
			query   = arguments.qMetaData,
			orderby = "name asc"
		);

		writeTemplate(
			path      = getOutputDir() & "/allclasses-frame.html",
			template  = "#getThemePath()#/allclasses-frame.cfm",
			args      = {
				qMetaData = arguments.qMetaData
			}
		);

		return this;
	}

	package AbstractTemplateStrategy function writeTemplate(
		required string path,
		required string template,
		struct args = {}
	){
		var filename = listFirst( arguments.path, "." );
		arguments.args.theme = getTheme();
		arguments.args.themePath = getThemePath();
		arguments.args.theme.rootPath = "/" & reReplace( getOutputDir(), expandPath( "/" ), "" ) & "/";

		return super.writeTemplate( argumentCollection = arguments );
	}

	/**
	 * Get the full path to the set theme.
	 */
	private string function getThemePath(){
		return "#variables.THEME_PATH#/#getTheme().name#";
	}



	/**
	 * Static assets used in HTML templates.
	 * 
	 * By default these are stored in the theme's static/ directory.
	 * This could potentially be configurable in the future.
	 */
	private string function getThemeAssetsPath(){
		return getThemePath() & "/static/";
	}
}
