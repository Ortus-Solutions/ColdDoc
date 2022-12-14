<!--- <cfparam name="theme.rootPath" default=""> --->

<!--- <cfdump var="#callStackGet()#" /><cfabort /> --->

<cfoutput>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <base href="#args.theme.rootPath#" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" referrerpolicy="no-referrer" />
        
    <script src="https://cdnjs.cloudflare.com/ajax/libs/alpinejs/3.10.5/cdn.min.js" integrity="sha512-y22y4rJ9d7NGoRLII5LVwUv0BfQKf6MpATy5ebVu/fbHdtJCxBpZRHZMHJv8VYl8scWjuwZcMPzwYk4sEoyL4A==" crossorigin="anonymous" referrerpolicy="no-referrer" defer></script>
</cfoutput>