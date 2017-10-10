## Payworks Pay Button(BETA) for iOS

**The repository is EOL and will no longer be updated. The latest binary builds can be accessed as usual at http://www.payworks.mpymnt.com/**

<img src="http://payworksmobile.com/blog/wp-content/uploads/2015/02/export_ipadmini_white_angle1.png"/>


The payworks Pay Button makes the integration of card acceptance in your app insanely easy.

Learn more about the payworks Pay Button [here][1].

The `mpos-ui` project contains the source code for the payworks Pay Button. The Pay Button uses the [payworks mPOS SDK][4] for iOS to process payments.

The `mpos-ui-sample` project contains the sample on how to integrate the payworks Pay Button in your iOS app.

Visit us at [www.payworksmobile.com][3] to learn more about what we do.

Installation
------------------------------
Put this in your `Podfile` and then run `pod install`:

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://bitbucket.org/mpymnt/io.mpymnt.repo.pods.git'

target :"<your-app-target>" do
    pod 'payworks',
    pod 'payworks.paybutton'
end
```

Import the framework in your header file:

```Objective-C
#import <mpos-ui/mpos-ui.h>
```

Detailed installation instructions and documentation for the Pay Button can be found [here][2].

Building from source
--------------------------
We recommend using the pre-build sdk from CocoaPods but, if you want to build from source follow the instructions below.

1. Clone the repository

  ```bash
  $ git clone https://github.com/payworks/mpos-ui-ios.git
  ```

2. Make sure you have CocoaPods installed. Do a `pod install` in `mpos-ui` and `mpos-ui-sample` folders. This will create an .xcworkspace for both the projects. Open them up in Xcode.

  ```bash
  $ cd mpos-ui
  $ pod install
  ```

  ```bash
  $ cd mpos-ui-sample
  $ pod install
  ```

3. The `mpos-ui-sample` project does not build as it does not have the `mpos-ui` library to link with. To fix this, go to the root folder and run the `build-mpos-ui.sh` script as follows to build the `mpos-ui` library and make it available for `mpos-ui-sample`

  ```bash
  $ ./build-mpos-ui.sh debug
  ```

4. This builds the `mpos-ui` frameworks with resources in the `packaged` directory in the root folder. Rebuild the `mpos-ui-sample` in Xcode for a successful build. You can run the `mpos-ui-sample` to see the Pay Button in action.

License
-----------
    mpos-ui : http://www.payworksmobile.com

    The MIT License (MIT)

    Copyright (c) 2015 payworks GmbH

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

[1]: http://payworksmobile.com/blog/2015/02/23/hashtag-shipped-the-pay-button/
[2]: http://www.payworks.mpymnt.com/paybutton#ios
[3]: http://payworksmobile.com/
[4]: http://www.payworks.mpymnt.com/node/101
