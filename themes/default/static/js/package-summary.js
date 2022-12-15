document.addEventListener("alpine:init", () => {
    Alpine.data( "packageOverview", () => ({
        classes : [],
        init(){
            // do stuffs
            window.fetchData( window.dataFile ).then( json => {
                for( let key in json ){
                    this[ key ] = json[ key ];
                }
            });
        },
    }))
});