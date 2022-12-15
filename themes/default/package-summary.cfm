<cfinclude template="#args.themePath#/inc/head.cfm" />

<!-- main package overview -->
<div class="border mx-10 my-8 px-2" x-data="packageOverview">
    <h2 class="font-bold text-xl bg-gray-200 p-4 -mx-2.5">Class Summary</h2>
    <table class="w-full table-fixed">
        <thead>
            <tr>
                <th class="text-left p-2 w-60">Class</th>
                <th class="text-left p-2">Description</th>
            </tr>
        </thead>
        <tbody>
            <template x-for="component in classes">
                <tr>
                    <td class="p-2">
                        <a x-bind:href="component.path.replace('json','html')" x-text="component.name" class="text-blue-800 font-bold"></a>
                    </td>
                    <td
                        class="p-2" 
                        x-text="component.name"
                    ></td>
                </tr>
            </template>
        </tbody>
    </table>
</div>
<script src="js/package-summary.js"></script>

<cfinclude template="#args.themePath#/inc/foot.cfm" />