# Delta Chat Core Plugin

The Delta Chat core plugin provides a Flutter / Dart wrapper for the [Delta Chat Core](https://github.com/deltachat/deltachat-core). 
It interacts with the native interfaces provided by the Android and iOS platform to enable IMAP / SMTP based chatting.

- Android state: Currently in development
- iOS state: Pending

## Relevant information
- [Documentation](https://confluence-public.open-xchange.com/display/COIPublic/OX+Talk+Mobile+App)
- Everything located in the [com.b44t.messenger](https://github.com/open-xchange/flutter-deltachat-core/tree/master/android/src/main/java/com/b44t/messenger) package is mainly provided by the Delta Chat core team. This code should not get altered.
- Within this repository only Flutter / Dart files should get edited. Java and C files shouldn't get changed as they are provided by sub repositories or other sources.

## Execution of the Flutter app
As for now (08.11.2018) it is required to execute the example app inside the project from console using ```flutter run --target-platform android-arm``` as the DCC is written as 32 bit program and Flutter is a 
64 bit program (see https://github.com/flutter/flutter/issues/15530). When using an IDE use ```--target-platform android-arm``` as additional argument in your run configuration.

## Requirements
- The used [Delta Chat Core](https://github.com/deltachat/deltachat-core) is currently only out of the box buildable using Linux (Debian / Ubuntu is recommended)
- As Flutter is still under development the newest version of Flutter and the Flutter plugin is required (at least until 1.0 is reached)

## Development
To be able to edit / extend the delta_chat_core plugin the following steps are important after checking out / altering the project:

- Download the [Android NDK](https://developer.android.com/ndk/downloads/older_releases) in version Android NDK, Revision 14b (March 2017) as newer versions are currently not supported 
- Execute *git submodule update --init --recursive*
- Navigate in the *delta_chat_core/android* folder and execute *ndk-build* inside that folder
- The plugin contains an example app to test the plugin
- If the Java part is changed a rebuild of the Android part is needed. E.g. in Android Studio a switch to the Android view, combined with a rebuilt applies all changes.

### Flutter 

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).

### Dart

Flutter is based on Dart, more information regarding Dart can be found on the [official website](https://www.dartlang.org/).
