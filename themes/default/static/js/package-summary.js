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


// export default {
//     props: {
//         id : {
//             type : String,
//             required: true
//         },
//         linkToMethod : {
//             type : String,
//             default : ""
//         }
//     },
//     data() {
//         return {
//             endpoint : "/quickdocs/view",
//             document : {}
//         };
//     },
//     methods: {
//         fetchDocument(){
//             return new Promise(( resolve, reject ) => {
//                 $.getJSON( `${ this.endpoint }/${ this.id }` )
//                     .done( result => {
//                         this.document = result;
//                         resolve( result );
//                     })
//                     .fail( xhr => {
//                         reject( xhr );
//                     });
//             });
//         },
//         scrollToMethod(){
//             if ( !this.linkToMethod.length ){
//                 return;
//             }
//             document.querySelector( `#${ this.linkToMethod }` ).scrollIntoView({
//                 behavior: "smooth"
//             });
//         }
//     },
//     mounted(){
//         this.fetchDocument().then( this.scrollToMethod );
//     }
// };