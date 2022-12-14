const sidebarDataFile = "data/overview-summary.json";

document.addEventListener("alpine:init", () => {
    Alpine.store( "packages", [] );
    Alpine.store( "classes", [] );
    Alpine.store( "title", "Untitled" );
    Alpine.store( "sortedPackages", ()=> {
        return Object.keys( Alpine.store( "packages" ) )
                        .sort( ( a, b ) => a.length < b.length ? -1 : a.length == b.length ? 0 : 1 )
                        .map( package => Alpine.store( "packages" )[ package ] );
    });

    window.fetchData( sidebarDataFile ).then( json => {
        for( let key in json ){
            Alpine.store( key, json[ key ] );
        }
    });

    Alpine.data( "sidebar", () => ({
        open            : true,
        search          : "",
        filteredPackages: [],

        // init(){
        //     // do stuffs...
        // },

        // ,buildPackageTree( packages ){
        //     let tree = packages.reduce( ( agg, item ) => {

        //     }, [] );
        //     return tree;
        // },
        get filteredPackages(){
            return this.search.length
                ? this.$store.sortedPackages()
                        .filter( package => package.name.indexOf( this.search ) > -1 )
                        .map( package => {
                            package.highlightedName = package.name.replace( this.search, `<em class="bg-yellow-300 text-gray-900">${this.search}</em>` );
                            return package;
                        })
                : this.$store.sortedPackages();
        }
    }));

});