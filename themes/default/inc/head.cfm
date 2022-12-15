<cfparam name="local.theme.title" default="" />

<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Generated Documentation (#local.theme.title#) </title>
    <cfinclude template="#args.themePath#/inc/common.cfm" />
</head>
<body class="p-0">
    <div
        class="flex min-h-screen"
        x-data="{}"
    >
        <cfinclude template="#args.themePath#/inc/search.cfm" />

        <!-- right-hand overview -->
        <div class="flex-grow border-l-2 border-gray-200 relative">

            <!-- package title -->
            <div class="bg-gray-100 p-4 px-10 text-gray-900">
                <h1 x-text="$store.title" class="text-2xl"></h1>
            </div>
</cfoutput>