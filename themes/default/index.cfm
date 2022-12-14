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

<cfinclude template="#args.themePath#/inc/foot.cfm" />