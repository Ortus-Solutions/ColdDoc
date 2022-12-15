document.addEventListener("alpine:init", () => {
    Alpine.data( "componentDocs", () => ({
        // Must go in a struct, or uninitialized keys will be dropped during the JSON import.
        document : {},
        isDocumentLoaded : false,
        init(){
            // do stuffs
            window.fetchData( window.dataFile ).then( json => {
                for( let key in json ){
                    this.document[ key ] = json[ key ];
                }
            }).then( () => this.isDocumentLoaded = true );
        },
    }))
});