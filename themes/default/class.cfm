<cfinclude template="#args.themePath#/inc/head.cfm" />


<!--Class / component documentation -->

<!-- avoid undefined errors if the document isn't loaded yet -->
<div x-data="componentDocs" x-show="isDocumentLoaded">
    <div class="bg-gray-200 p-2 px-6">
        <template x-show="document.package != ''"><span x-text="document.package"></span>.<span x-text="document.name"></span></template>
        <template x-show="document.meta" class="float-right"><span x-text="document.meta.api.name"></span> <span x-text="document.meta.api.version"></span></template>
    </div>
    
    <div class="px-6">
        <h1 class="font-bold leading-7 text-2xl my-4"> <span x-text="document.name"></span> </h1>
        <pre class="my-4 whitespace-pre-wrap text-gray-700 border-0 leading-4" x-show="document.hint" x-html="document.hint"></pre>
        
        <div class="divide-gray-200 divide-solid divide-y-2">
            <template x-for="method in document.functions" :key="method.name">
                <div class="py-4 my-4 bg-white text-gray-900">

                    <h2 class="text-xl text-gray-700 font-bold" :id="method.name">
                        <span x-text="method.access"></span>
                        function
                        <span x-text="method.name"></span>
                    </h2>
                    <code class="bg-gray-100 p-2 text-gray-900 block my-2">
                        <span><span x-text="method.access"></span> function <span x-text="method.name"></span>(
                            <span x-show="method.parameters.length > 0">
                                <template x-for="(param,index) in method.parameters" :key="param.name">
                                    <span>
                                        <span x-show="method.parameters.length > 1">
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;
                                        </span>
                                        <span x-text="param.required ? 'required' : ''"></span> <span x-text="param.type"></span>
                                        <span x-text="param.name"></span><span x-show="index < method.parameters.length-1">,</span>
                                        <span x-show="method.parameters.length > 1 && index == method.parameters.length-1"><br></span>
                                    </span>
                                </template>
                            </span>
                        )</span> 
                    </code>

                    <pre class="my-4 whitespace-pre-wrap text-gray-700 border-0" x-show="method.hint"><span x-text="method.hint"></span></pre>
                    <div x-if="method.description.length" x-html="method.description"></div>
                    <template x-for="param in method.parameters" :key="param.name">
                        <div class="my-2">
                            <span class="bg-gray-100 py-2 px-2 inline-block rounded-xl leading-none">
                                @param
                                <span class="text-red-600 border-red-600 text-xs ml-1" x-show="param.required">required</span>
                            </span>
                            <span class="mx-2">
                                <span x-text="param.type"></span> <span x-text="param.name"></span>
                            </span>
                            <span><span x-text="param.hint"></span></span>
                        </div>
                    </template>
                </div>
            </template>
        </div>
    </div>
</div>
<script src="js/class.js"></script>


<cfinclude template="#args.themePath#/inc/foot.cfm" />