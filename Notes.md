# DocBox Next

## Ideas

* interfaces!
* A-Z index of all stuff
* use JSON - each strategy is an alpine theme that consumes JSON, basically

## TODO: Architecture

* Core: Handles grabbing metadata and serializing into a standard JSON schema
* Publishers: Given input, send to destination
  * ElasticsearchPublisher
  * GithubPublisher
  * GitBookPublisher
  * etc, etc.
* Output: Theme
  * Bootstrap or Tailwind theme - same data, different style
  * XMI theme - same data, different output
  * JSON theme - same data, different output
  * Markdown theme - same data, different output

* Transformer: Given input, transform to output
  * Do we need this??

```js
var docs = new Docbox()
            .src( "./models" )
            .excludes( "coldbox" )
            .excludes( "testbox" )
            .excludes( "modules" )
            .htmlOutput( "./docs" )
                .withTheme( "ninja", {
                    footer : "",
                    logo : "",
                    title : "",
                    primaryColor : ""
                } )
            .run()
```