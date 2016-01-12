# TDDropInAlertView

## Usage

TDDropInAlertView is a drop-in replacement for UIAlertView that uses the (non-deprecated) UIAlertController API.  To use it, install the CocoaPod add the following lines to your app's `prefix.pch`

```
#ifdef __OBJC__
#import <TDDropInAlertView/TDDropInAlertView.h>
#define UIAlertView TDDropInAlertView
#define UIAlertViewDelegate TDDropInAlertViewDelegate
#endif
```

## Installation

TDDropInAlertView is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "TDDropInAlertView"

## Author

Nick Lee, nick@tendigi.com

## License

TDDropInAlertView is available under the Apache license. See the LICENSE file for more info.
