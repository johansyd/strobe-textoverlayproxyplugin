strobe-base64imagegeneratorplugin
=================================

Strobe plugin for grabbing a base64 encoded image throught Strobe's JS API

####Building the plugin with mxmlc

Download and install flex with the [flex installer](https://github.com/aptoma/flex-installer "Flex installer") (ubuntu only, see [Flex installer README](https://github.com/aptoma/flex-installer) for how to install flex on Mac OSX and Windows)

From the root directory of this repository. Do the following from the terminal:

    mxmlc src/Base64ImageGeneratorPlugin.as -library-path+=libs -sp="src/" -static-link-runtime-shared-libraries=true -o bin-debug/Base64ImageGeneratorPlugin.swf

For testing you can set up a vhost and point it to the bin-debug folder. Copy the following files to the bin-debug folder if not 
allready there.

    cp html-template/StrobeMediaPlayback.swf bin-debug/
    cp html-template/crossdomain.xml bin-debug/
    cp html-template/index.template.html bin-debug/index.html

If you want to just work in a folder directly on the root of your webserver you can do this:

    # Assumming /var/www is the root of your webserver
    sudo su
    mkdir /var/www/Base64ImageGeneratorPlugin
    cp -r bin-debug/*  /var/www/Base64ImageGeneratorPlugin/

####Debugging

If you want firebug/chrome style debugging you can do the following:

    # Calls console.log
    console.log("Hello Foxy lady");
    # calls console.error
    console.error("Hello Foxy lady");
    # creates a javascript alert box (does not require firebug or chrome)
    console.alert("Hello Foxy lady");

I have mentinoned some possibilities in the [flex installer README](https://github.com/johansyd/flex-installer "Flex installer") if you want other powertools.

