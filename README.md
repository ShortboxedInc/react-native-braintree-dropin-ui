# react-native-braintree-dropin-ui

React Native integration of Braintree Drop-in for iOS & Android (Apple Pay, Google Pay, Paypal, Venmo, credit card)

<p align="center">
<img src="https://raw.githubusercontent.com/wgltony/react-native-braintree-dropin-ui/master/node_modules/iphone.png" width="250">
<img src="https://raw.githubusercontent.com/wgltony/react-native-braintree-dropin-ui/master/node_modules/android.png" width="250">
</p>

## Getting started

For React Native versions >= 0.60

### NPM
```bash
npm install react-native-braintree-dropin-ui --save
```

### Yarn
```bash
yarn add react-native-braintree-dropin-ui
```

### iOS
```
cd ./ios
pod install
```

## Configure Payment Method
See Braintree’s documentation for [Apple Pay][8], [Google Pay][9], [Paypal][10], [Venmo][11]. Once you’ve finished setting up all each payment method, it will appear in the drop-in UI.

### Apple Pay

The Drop-in UI will show Apple Pay as a payment option as long as you've completed the [Apple Pay integration][6] and the customer’s [device and card type are supported][7].

### PayPal

To enable PayPal payments in iOS, you will need to add `setReturnURLScheme` to the `launchOptions` of your `AppDelegate.m`

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BTAppContextSwitcher setReturnURLScheme:@"com.your-company-name.your-app-name.payments"]; // ADD THIS LINE 
    return YES;
}
```

## Configuration

For more configuration options, see Braintree’s documentation ([iOS][2] | [Android][3]).

### 3D Secure

If you plan on using 3D Secure, you have to do the following:

#### iOS

##### Configure a new URL scheme

Add a bundle url scheme `{BUNDLE_IDENTIFIER}.payments` in your app Info via Xcode or manually in the `Info.plist`.
In your `Info.plist`, you should have something like:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.myapp</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.myapp.payments</string>
        </array>
    </dict>
</array>
```

##### Update your code

In your `AppDelegate.m`:

```objective-c
#import "BraintreeCore.h"

...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ...
    [BTAppContextSwitcher setReturnURLScheme:self.paymentsURLScheme];
    ...
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    if ([url.scheme localizedCaseInsensitiveCompare:self.paymentsURLScheme] == NSOrderedSame) {
      return [BTAppContextSwitcher handleOpenURL:url];
    }

    return [RCTLinkingManager application:application openURL:url options:options];
}

- (NSString *)paymentsURLScheme {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return [NSString stringWithFormat:@"%@.%@", bundleIdentifier, @"payments"];
}
```

In your `AppDelegate.swift`:

```swift
import Braintree

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ...
    BTAppContextSwitcher.setReturnURLScheme(self.paymentsURLScheme)
    ...
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if let scheme = url.scheme, scheme.localizedCaseInsensitiveCompare(self.paymentsURLScheme) == .orderedSame {
        return BTAppContextSwitcher.handleOpen(url)
    }
    return RCTLinkingManager.application(app, open: url, options: options)
}

private var paymentsURLScheme: String {
    let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
    return bundleIdentifier + ".payments"
}
```

#### Android

Set up [browser switch][4].

## Use

For the API, see the [Flow typings][5].

### Basic

```javascript
import BraintreeDropIn from 'react-native-braintree-dropin-ui';

BraintreeDropIn.show({
  clientToken: 'token',
  merchantIdentifier: 'applePayMerchantIdentifier',
  googlePayMerchantId: 'googlePayMerchantId',
  countryCode: 'US',    // Apple Pay setting
  currencyCode: 'USD',   // Apple Pay setting
  merchantName: 'Your Merchant Name for Apple Pay',
  orderTotal:'Total Price',
  googlePay: true,
  applePay: true,
  vaultManager: true,
  payPal: true, 
  cardDisabled: false,
  darkTheme: true,
})
.then(result => console.log(result))
.catch((error) => {
  if (error.code === 'USER_CANCELLATION') {
    // Update your UI to handle cancellation
  } else {
    // Update your UI to handle other errors
  }
});
```

### 3D Secure

```javascript
import BraintreeDropIn from 'react-native-braintree-dropin-ui';

BraintreeDropIn.show({
  clientToken: 'token',
  threeDSecure: {
    amount: 1.0,
  },
  merchantIdentifier: 'applePayMerchantIdentifier',
  googlePayMerchantId: 'googlePayMerchantId',
  countryCode: 'US',    // Apple Pay setting
  currencyCode: 'USD',   // Apple Pay setting
  merchantName: 'Your Merchant Name for Apple Pay',
  orderTotal:'Total Price',
  googlePay: true,
  applePay: true,
  vaultManager: true,
  payPal: true, 
  cardDisabled: false,
  darkTheme: true,
})
.then(result => console.log(result))
.catch((error) => {
  if (error.code === 'USER_CANCELLATION') {
    // Update your UI to handle cancellation
  } else {
    // Update your UI to handle other errors
    // For 3D Secure, there are two other specific error codes: 3DSECURE_NOT_ABLE_TO_SHIFT_LIABILITY and 3DSECURE_LIABILITY_NOT_SHIFTED
  }
});
```

### Custom Fonts
```
BraintreeDropIn.show({
  ...,
  fontFamily: 'Averta-Regular',
  boldFontFamily: 'Averta-Semibold',
})
```

[1]:  http://guides.cocoapods.org/using/using-cocoapods.html
[2]:  https://github.com/braintree/braintree-ios-drop-in
[3]:  https://github.com/braintree/braintree-android-drop-in
[4]:  https://developers.braintreepayments.com/guides/client-sdk/setup/android/v2#browser-switch-setup
[5]:  ./index.js.flow
[6]:  https://developers.braintreepayments.com/guides/apple-pay/configuration/ios/v4
[7]:  https://articles.braintreepayments.com/guides/payment-methods/apple-pay#compatibility
[8]:  https://developers.braintreepayments.com/guides/apple-pay/overview
[9]:  https://developers.braintreepayments.com/guides/google-pay/overview
[10]: https://developers.braintreepayments.com/guides/paypal/overview/ios/v4
[11]: https://developers.braintreepayments.com/guides/venmo/overview
