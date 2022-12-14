<cfinclude template="#args.themePath#/inc/head.cfm" />

<!-- main package overview -->
<div class="border mx-10 my-8 px-2" x-data="packageOverview">
    <h2 class="text-xl bg-gray-200 px-5 -mx-2.5">Class Summary</h2>
    <table>
        <thead>
            <tr>
                <th>Class</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <template x-for="component in classes">
                <tr>
                    <td>
                        <a x-bind:href="component.path.replace('json','html')" x-text="component.name" class="text-blue-8"></a>
                    </td>
                    <td x-text="component.name"></td>
                </tr>
            </template>
        </tbody>
    </table>
</div>
<script src="js/package-summary.js"></script>

<cfinclude template="#args.themePath#/inc/foot.cfm" />