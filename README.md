This is an App for IOS that tracks the location of two devices. The location of both devices are pinned on the virtual map with a red and blue marker. The app displays hwo far away the two devices are every moment.

To use, download files on a macos computer then open up the project in Xcode. 

To get this project running on your own machine, you will need to set up a Firebase backend.

Create a Firebase Project

Go to the Firebase console and create a new project.

In your new project's dashboard, navigate to the Build section and select Firestore Database.

Click Create database and choose to start in Test Mode. This allows the app to write data without complex security rules.

Connect the App

In your Firebase project's settings, click Add app and select the iOS platform.

You will be asked for a Bundle Identifier. Open the LocationTracker.xcodeproj file in Xcode, select the LocationTracker target, go to the Signing & Capabilities tab, and copy the Bundle Identifier from there. Paste it into the Firebase form.

Follow the on-screen steps to register the app.

Add Configuration File

Firebase will prompt you to download a GoogleService-Info.plist file.

Drag this downloaded file directly into the LocationTracker folder in Xcode's file navigator. When the options dialog appears, make sure "Copy items if needed" is checked.

Build and Run

Xcode will automatically detect and fetch the required Firebase packages.

Select a simulator or a connected iPhone and press the Play button to build and run the app. It will now be connected to your personal Firebase backend.
