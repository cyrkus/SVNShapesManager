# To install this framework

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

Add the framework to 'Linked Frameworks and Libraries' in the Xcode Project by dragging and dropping the framework created in
 Carthage/Build/iOS/pathToFramework*.framework

Add this run Script to your xcodeproj
/usr/local/bin/carthage copy-frameworks

Add this input file to the run script:
$(SRCROOT)/Carthage/Build/iOS/pathToFramework*.framework

If Xcode has issues finding your framework Add
 $(SRCROOT)/Carthage/Build/iOS
  To 'Framework Search Paths' in Build Settings
