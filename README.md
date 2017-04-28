# SVNShapesManager

 A CALayer layout, animating, mutating and updating manager.
 Currently supports exit, plus, circle, and checkmark shapes.

To use this manager pass the CGRect of the the container that you want to add shapes to.
You can then use on of the various *create* methods to instantiate and add paths to a CALayer instance.
Once created you can use one of the various *animate* methods to animate and mutate a SVNShapeMetaData instance.

## To install this framework

Add Carthage files to your .gitignore

    #Carthage
    Carthage/Build

Check your Carthage Version to make sure Carthage is installed locally:

    Carthage version

Create a CartFile to manage your dependencies:

    Touch CartFile

Open the Cartfile and add this as a dependency. (in OGDL):

    github "sevenapps/PathToRepo*" "master"

Update your project to include the framework:

    Carthage update --platform iOS

Add the framework to 'Embedded Binaries' in the Xcode Project by dragging and dropping the framework created in

    Carthage/Build/iOS/pathToFramework*.framework

Add this run Script to your xcodeproj

    /usr/local/bin/carthage copy-frameworks

Add this input file to the run script:

    $(SRCROOT)/Carthage/Build/iOS/pathToFramework*.framework

If Xcode has issues finding your framework Add

    $(SRCROOT)/Carthage/Build/iOS

To 'Framework Search Paths' in Build Settings
