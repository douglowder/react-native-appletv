# Apple TV changes

This branch includes changes to support building React Native applications on Apple TV.

The changes have been implemented with the intention of supporting existing React Native iOS applications so that few or no changes are required in the Javascript code for the applications.

This branch includes a working version of the UIExplorer example project for Apple TV.

Jan 31, 2017: This branch has now been merged to the latest from Facebook master, where most of the work in this fork has been committed.

## Build changes

- *Native layer*: React Native Xcode projects all now have Apple TV build targets, with names ending in the string '-tvOS'.

- *Javascript layer*: Previously in this branch, there were packager changes that defined a new global `__APPLETV__`.  That has now been removed, and support has been added to `Platform.ios.js`.  You can check whether code is running on AppleTV by doing

```js
var Platform = require('Platform');
var running_on_apple_tv = Platform.isTVOS;
```

## Code changes

- *General support for tvOS*: Apple TV specific changes in native code are all wrapped by the TARGET_OS_TV define.  These include changes to suppress APIs that are not supported on tvOS (e.g. web views, sliders, switches, status bar, etc.), and changes to support user input from the TV remote or keyboard.
- *TV remote/keyboard input*: A new native class, RCTTVRemoteHandler, sets up gesture recognizers for TV remote events.  When TV remote events occur, the events are eventually picked up by the new `TVEventHandler`.  Components may now listen for the events by adding code similar to the example below.

```js
var TVEventHandler = require('TVEventHandler');

.
.
.

class Game2048 extends React.Component {
  _tvEventHandler: any;

  _enableTVEventHandler() {
    this._tvEventHandler = new TVEventHandler();
    this._tvEventHandler.enable(this, function(cmp, evt) {
      if (evt && evt.eventType === 'right') {
        cmp.setState({board: cmp.state.board.move(2)});
      } else if(evt && evt.eventType === 'up') {
        cmp.setState({board: cmp.state.board.move(1)});
      } else if(evt && evt.eventType === 'left') {
        cmp.setState({board: cmp.state.board.move(0)});
      } else if(evt && evt.eventType === 'down') {
        cmp.setState({board: cmp.state.board.move(3)});
      } else if(evt && evt.eventType === 'playPause') {
        cmp.restartGame();
      }
    });
  }

  _disableTVEventHandler() {
    if (this._tvEventHandler) {
      this._tvEventHandler.disable();
      delete this._tvEventHandler;
    }
  }

  componentDidMount() {
    this._enableTVEventHandler();
  }

  componentWillUnmount() {
    this._disableTVEventHandler();
  }

```

- *Access to touchable controls*: When running on Apple TV, the native view class is `RCTTVView`, which has additional methods to make use of the tvOS focus engine.  `Touchable`, `TouchableHighlight`, and `TouchableOpacity` have code added to detect focus changes, style the components properly, and fire the `onPress` method when the view is selected using the TV remote.
- *TV remote animations*: `RCTTVView` native code implements Apple-recommended parallax animations to help guide the eye as the user navigates through views.  The animations can be disabled or adjusted with new optional view properties. 
- *Back navigation with the TV remote menu button*: The `NavigationExperimental` and `NavigatorIOS` components make use of the new `TVEventHandler` to navigate back as expected.


## Test status

- *Jest tests*: All pass.
- *iOS unit tests*: All pass.
- *iOS integration tests*: All pass.
 
