# Apple TV changes

This branch includes changes to support building React Native applications on Apple TV.

The changes have been implemented with the intention of supporting existing React Native iOS applications so that few or no changes are required in the Javascript code for the applications.

This branch includes a working version of the UIExplorer example project for Apple TV.

## Build changes

- *Native layer*: tvOS applications must be built in separate Xcode projects from iOS applications.  Each iOS project now has a corresponding tvOS project with name ending in "TV".
- *Javascript layer*: The packager has been modified to accept a new option, `appletv`.  If `appletv=true` is passed into the URL requested from the packager, the JS bundle will have `__APPLETV__` set to true.  This allows applications to expose Apple TV specific behavior, or suppress views that are not supported on Apple TV.

## Code changes

- *General support for tvOS*: Apple TV specific changes in native code are all wrapped by the TARGET_OS_TV define.  These include changes to suppress APIs that are not supported on tvOS (e.g. web views, sliders, switches, status bar, etc.), and changes to support user input from the TV remote or keyboard.
- *TV remote/keyboard input*: A new native class, RCTTVRemoteHandler, sets up gesture recognizers for TV remote events and fires corresponding application events in the Javascript layer.  An application can add a listener for these events, e.g.

```js
ReactNative.NativeAppEventEmitter.addListener( 'tvEvent', evt => {
  console.log("TV remote event: " + evt.eventType);
});
```

- *Access to touchable controls*: The View class now has optional methods onTVSelect, onTVFocus, onTVBlur, and onTVMenu.  Code has been added to RCTView in the native layer to make any view with a non-null onTVSelect method to be focusable and navigable with the TV remote.  If the view is focused and the TV remote select button is pressed, the onTVSelect method is called.  The TouchableHighlight and TouchableOpacity components have these methods implemented such that when they are selected, the onPress method fires as expected.
- *Back navigation with the TV remote menu button*: The RCTRootView native class has a gesture recognizer that detects when the menu button is pressed, and then propagates through all its subviews, calling the onTVMenu method if it exists in a subview.  The NavigationExperimental and NavigatorIOS components have views with onTVMenu implemented to navigate back as expected.
