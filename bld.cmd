@echo off

rem build TiddlyWiki5 for tiddlywiki.com

rem Set up the build output directory

if "x%TW5_BUILD_OUTPUT%" == "x" (
	set TW5_BUILD_OUTPUT=..\tw5_build
)

if not exist %TW5_BUILD_OUTPUT%\nul (
	echo A valid TW5_BUILD_OUTPUT environment variable must be set
	exit 1
)

echo Using TW5_BUILD_OUTPUT as %TW5_BUILD_OUTPUT%
echo.

rem Create the `static` directories if necessary

setlocal enableextensions
mkdir %TW5_BUILD_OUTPUT%\static
setlocal disableextensions

rem Delete any existing content

del /q /s %TW5_BUILD_OUTPUT%\static

rem The tw5.com wiki
rem  index.html: the main file, including content
rem  empty.html: the main file, excluding content
rem  static.html: the static version of the default tiddlers

node .\tiddlywiki.js ^
	.\editions\tw5.com ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\index.html text/plain ^
	--savetiddler $:/favicon.ico %TW5_BUILD_OUTPUT%\favicon.ico ^
	--rendertiddler ReadMe .\readme.md text/html ^
	--rendertiddler ContributingTemplate .\contributing.md text/html ^
	--rendertiddler $:/core/copyright.txt .\licenses\copyright.md text/plain ^
	--rendertiddler $:/editions/tw5.com/download-empty %TW5_BUILD_OUTPUT%\empty.html text/plain ^
	--rendertiddler $:/editions/tw5.com/download-empty %TW5_BUILD_OUTPUT%\empty.hta text/plain ^
	--savetiddler $:/green_favicon.ico %TW5_BUILD_OUTPUT%/static/favicon.ico ^
	--rendertiddler $:/core/templates/static.template.html %TW5_BUILD_OUTPUT%\static.html text/plain ^
	--rendertiddler $:/core/templates/alltiddlers.template.html %TW5_BUILD_OUTPUT%\alltiddlers.html text/plain ^
	--rendertiddler $:/core/templates/static.template.css %TW5_BUILD_OUTPUT%\static\static.css text/plain ^
	--rendertiddlers [!is[system]] $:/core/templates/static.tiddler.html %TW5_BUILD_OUTPUT%\static text/plain ^
	|| exit 1


rem encrypted.html: a version of the main file encrypted with the password "password"

node .\tiddlywiki.js ^
	.\editions\tw5.com ^
	--verbose ^
	--password password ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\encrypted.html text/plain ^
	|| exit 1


rem tahoelafs.html: empty wiki with plugin for Tahoe-LAFS

node .\tiddlywiki.js ^
	.\editions\tahoelafs ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\tahoelafs.html text/plain ^
	|| exit 1


rem d3demo.html: wiki to demo d3 plugin

node .\tiddlywiki.js ^
	.\editions\d3demo ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\d3demo.html text/plain ^
	|| exit 1


rem codemirrordemo.html: wiki to demo codemirror plugin

node .\tiddlywiki.js ^
	.\editions\codemirrordemo ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\codemirrordemo.html text/plain ^
	|| exit 1


rem markdowndemo.html: wiki to demo markdown plugin

node .\tiddlywiki.js ^
	.\editions\markdowndemo ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\markdowndemo.html text/plain ^
	|| exit 1


rem highlightdemo.html: wiki to demo highlight plugin

node .\tiddlywiki.js ^
	.\editions\highlightdemo ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\highlightdemo.html text/plain ^
	|| exit 1


rem ProgrammerLog.html: wiki to demo a blog like wiki

node .\tiddlywiki.js ^
	.\editions\programmerlog ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\ProgrammerLog.html text/plain ^
	|| exit 1


rem empty_alt.html: an empty wiki using the empty edition

node .\tiddlywiki.js ^
	.\editions\empty ^
	--verbose ^
	--rendertiddler $:/core/save/all %TW5_BUILD_OUTPUT%\empty_alt.html text/plain ^
	|| exit 1


rem Make the CNAME file that GitHub Pages requires

echo tiddlywiki.com > %TW5_BUILD_OUTPUT%\CNAME

rem Run the test edition to run the Node.js tests and to generate test.html for tests in the browser

.\test.cmd
