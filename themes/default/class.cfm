<cfinclude template="#args.themePath#/inc/head.cfm" />
<!-- main package overview -->
<div class="border mx-10 my-8 px-2" x-data="{}">
    <h2 class="text-xl bg-gray-200 px-5 -mx-2.5">Package Overview</h2>
    <ul class="p-2">
        <template x-for="package in $store.sortedPackages()">
            <li>
                <a x-bind:href="package.path.replace('json','html')" x-text="package.name" class="text-blue-8"></a>
            </li>
        </template>
    </ul>
</div>

<div x-data="packageOverview">
    <div class="bg-gray-200 p-2">
        <span v-if="document.package != ''">{{ document.package }}.{{ document.name }}</span>
        <span v-if="document.meta" class="float-right">{{ document.meta.api.name }} {{ document.meta.api.version}}</span>
    </div>
    
    <h1 class="font-bold leading-7 text-2xl my-4"> {{ document.name }} </h1>
    <pre class="my-4 whitespace-pre-wrap text-gray-700 border-0 leading-4" v-if="document.hint != ''" v-html="document.hint"></pre>
    
    <div class="divide-gray-200 divide-solid divide-y-2">
        <div v-for="method in document.functions" :key="method.name" class="px-4 py-4 my-4 bg-white text-gray-900">

            <h2 class="text-xl text-gray-700 font-bold" :id="method.name">{{ method.access }} function {{ method.name }}</h2>
            <code class="bg-gray-100 p-2 text-gray-900 block my-2 -mx-2">
                <span>{{ method.access }} function {{ method.name }}(
                    <span v-if="method.parameters.length > 0">
                        <span v-for="(param,index) in method.parameters" :key="param.name">
                            <span v-if="method.parameters.length > 1">
                                <br>&nbsp;&nbsp;&nbsp;&nbsp;
                            </span>
                            {{ param.required ? 'required' : '' }} {{ param.type }}
                            {{ param.name }}<span v-if="index < method.parameters.length-1">,</span>
                            <span v-if="method.parameters.length > 1 && index == method.parameters.length-1"><br></span>
                        </span>
                    </span>
                )</span> 
            </code>

            <pre class="my-4 whitespace-pre-wrap text-gray-700 border-0" v-if="method.hint">{{ method.hint }}</pre>
            <div v-if="method.description != ''" v-html="method.description"></div>
            <div v-for="param in method.parameters" :key="param.name" class="my-2">
                <span class="bg-gray-100 py-2 px-2 inline-block rounded-xl leading-none">
                    @param
                    <span class="text-red-600 border-red-600 text-xs ml-1" v-if="param.required">required</span>
                </span>
                <span class="mx-2">
                    {{ param.type }} {{ param.name }}
                </span>
                <span>{{ param.hint }}</span>
            </div>
        </div>
    </div>
</div>
<script src="js/package-summary.js"></script>


<cfinclude template="#args.themePath#/inc/foot.cfm" />