<cfoutput>
    </div>
    </div>

    <script>
        window.dataFile = '#args.dataFile#';
        // Reusable .json file data fetcher.
        window.fetchData = async function( dataFile = window.dataFile ){
            return fetch( dataFile )
                .catch( err => console.error(err) )
                .then( response => {
                    if (!response.ok) {
                        const message = `Unable to load JSON data file: ${response.status}`;
                        throw new Error(message);
                    }
                    return response;
                })
                .then( response => response.json() );
        };
    </script>

</body>
</html>
</cfoutput>