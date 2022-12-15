<!-- left-hand navbar -->
<div
    class="transition-all duration-100 ease-in relative"
    :class="open ? 'w-52' : 'w-0'"
    x-data="sidebar"
>
    <!-- avoid wrapping when width changes -->
    <div class="w-52 overflow-hidden" x-show="open" x-transition>
        <div class="p-2">
            <form class="my-4">
                <input
                    id="search"
                    name="search"
                    class="block w-full py-2 px-4 border border-gray-200 rounded-md sm:text-sm"
                    placeholder="Search"
                    type="search"
                    x-model="search">
            </form>

            <!--
                Tree view. This is gonna be interesting... 👨‍🏭
            -->
            <ul>
                <template x-for="package in filteredPackages">
                    <li><a x-bind:href="package.path.replace('json','html')" x-html="package.highlightedName ? package.highlightedName : package.name" class="text-blue-8"></a></li>
                </template>
            </ul>
        </div>
    </div>

    <!--
        Nav / search toggle
    -->
    <button x-on:click="open = !open" class="transform hover:scale-110 p-2 text-xl fixed bottom-2 left-2 bg-gray-100 rounded-3xl z-10 shadow-lg">
        <span x-show="open">👈</span>
        <span x-show="!open">👉</span>
    </button>
</div>
<script src="js/sidebar.js"></script>