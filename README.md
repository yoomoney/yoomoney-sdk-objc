 ![Logo](http://api.yandex.com/money/money1.png) 
# Objective-c Yandex.Money SDK  

[![Version](http://cocoapod-badges.herokuapp.com/v/YandexMoneySDKObjc/badge.png)](http://api.yandex.ru/money/)
[![Platform](http://cocoapod-badges.herokuapp.com/p/YandexMoneySDKObjc/badge.png)](http://api.yandex.ru/money/)

## Overview
This open-source library allows you to work with Yandex.Money API. Learn more about [Yandex.Money API][ENAPILink] (also available in [Russian][RUAPILink]).

## Installation

YandexMoneySDKObjc is available through [CocoaPods](http://cocoapods.org).  Install it simply add the following line to your Podfile:

    pod "YandexMoneySDKObjc"

## Usage
#### App Registration
To be able to use the library you: the first thing you need to do is to register your application and get your unique *client id*. To do that please follow the steps described on [this page][1] (also available in [Russian][2]).

#### Payments from wallet
##### Authorization
First of all, you create authorization request using YMAAPISession class

```Objective-C
YMAAPISession *session = [[YMAAPISession alloc] init];
NSDictionary *parameters = @{
    YMAParameterResponseType    : YMAValueParameterResponseType,  //Constant value  
    YMAParameterRedirectUri     : @"Your redirect_uri", //URI that the OAuth server sends the authorization result to.
    YMAParameterScope           : @"payment-p2p"}; //A list of requested permissions.
NSURLRequest *authorizationRequest =  [session authorizationRequestWithClientId:@"Your client_id" andAdditionalParams:parameters];
```
The next step, you use UIWebView or OS browser to send an Authorization Request to the Yandex.Money server.
```Objective-C
[webView loadRequest:authorizationRequest];
```
For the authorization request, the user is redirected to the Yandex.Money authorization page. The user enters his login and password, reviews the list of requested permissions and payment limits, and either approves or rejects the application's authorization request. The authorization result is returned as an "HTTP 302 Redirect" to your **redirect_uri**.<br>

You should intercept a request to you **redirect_uri**, cancel the request and extract the verification code from the request query string.
```Objective-C
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldStartLoad = YES;
    NSMutableDictionary *authInfo = nil;
    NSError *error = nil;
    if ([self.session isRequest:request toRedirectUrl:@"Your redirect_uri" authorizationInfo:&authInfo error:&error]) {
        if (error == nil) {
            self.authCode = authInfo[@"code"];
        }
    }
    return shouldStartLoad;
}
```
If authorization was completed successfully, the application should immediately exchange the temporary authorization code for an access token.
```Objective-C
NSDictionary *additionalParameters = @{
    @"grant_type"           : @"authorization_code", // Constant value
    YMAParameterRedirectUri : @"Your redirect_uri"};
    
[self.session receiveTokenWithWithCode:self.authCode clientId:@"Your client_id" andAdditionalParams:additionalParameters completion:^(NSString *Id, NSError *error) {
if (error == nil && Id) {
self.accessToken = Id;
}
}];
```
_The access_token is a symmetric authorization key, so the application developer must secure it - the token should be encrypted for storage, with access allowed only after the user authenticates within the application. For example, the token can be encrypted using the 3DES algorithm, where the encryption key is a 4-digit PIN code._

#### Payment

For more information about scenario of payment, please see API page: [Ru][5], [En][6].

#### Request payment

For creating a payment and checking its parameters (API page: [Ru][7], [En][8]) use YMAExternalPaymentRequest class:


### Payments from bank cards without authorization

For payments from bank cards without authorization (API page: [Ru][5], [En][6]) use YMAExternalPaymentSession class.
To perform a request (call of API method), use `performRequest` method of YMAExternalPaymentSession class:

```Objective-C

/// Perform some request and obtaining response in block.
/// @param request - request inherited from YMABaseRequest.
/// @param block - completion of block is used to get the response.
- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block;

```

#### Registering an instance of the application

Before making the first payment, you need to register a copy of the application in Yandex.Money that is installed on a device and get an identifier for the instance of the application — instance_id. To register an instance, call the instance-id method (API page: [Ru][9], [En][10]):

```Objective-C

YMAExternalPaymentSession *session = [[YMAExternalPaymentSession alloc] init];

if (instanceId == nil) {
    [session instanceWithClientId:@"You ClientId" token:self.secureStorage.token completion:^(NSString *Id, NSError *error)     {
        if (error != nil) {
            // Process error 
        } else {
            instanceId = Id; // Do NOT request instance id every time you need to call API method. 
                             // Obtain it once and reuse it.
            session.instanceId = instanceId;
        }
    }];
} else {
    session.instanceId = instanceId;
}

```
#### Payment

For more information about scenario of payment, please see API page: [Ru][5], [En][6].

#### Request external payment

For creating a payment and checking its parameters (API page: [Ru][7], [En][8]) use YMAExternalPaymentRequest class:

```Objective-C

YMABaseRequest *externalPaymentRequest = [YMAExternalPaymentRequest externalPaymentWithPatternId:patternId andPaymentParams:paymentParams];
    
// session - instance of YMAExternalPaymentSession class 
// token - can be nil.
[session performRequest:externalPaymentRequest token:token completion:^(YMABaseRequest *request, 
    YMABaseResponse *response, NSError *error) {
    if (error != nil) {
        // Process error
    } else {
        YMAExternalPaymentResponse *externalPaymentResponse = (YMAExternalPaymentResponse *) response;
        // Process external payment response
    }
}];

```

#### Process external payment

Making a payment (API page: [Ru][11], [En][12]). The application calls the method up until the final payment status is known (status=success/refused).
The recommended retry mode is determined by the "next_retry" response field (by default, 5 seconds).
For making a payment use YMAExternalPaymentRequest class:

```Objective-C

YMABaseRequest *processExternalPaymentRequest = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:YMSuccessUrl failUri:YMFailUrl requestToken:NO];
    
// session - instance of YMAExternalPaymentSession class 
// token - can be nil.
[session performRequest:paymentRequest token:token completion:^(YMABaseRequest *request, YMABaseResponse *response,
    NSError *error) {
    if (error != nil) {
        // Process error
        return;
    }

    YMABaseProcessResponse *processResponse = (YMABaseProcessResponse *)response;
        
    if (processResponse.status == YMAResponseStatusInProgress) {
        // Process InProgress status 
    } else if (processResponse.status == YMAResponseStatusSuccess) {
        // Process Success status
    } else if (processResponse.status == YMAResponseStatusExtAuthRequired) {
        // Process AuthRequired status
    } 
}];

```

## Links

* Yandex.Money API page: [Ru](http://api.yandex.ru/money/), [En](http://api.yandex.com/money/)
* [example projects](https://github.com/yandex-money/yandex-money-sdk-objc/tree/master/Example)

## License

YandexMoneySDKObjc is available under the MIT license. See the LICENSE file for more info.

[RUAPILink]:http://api.yandex.ru/money/
[ENAPILink]:http://api.yandex.com/money/


[1]: http://api.yandex.com/money/doc/dg/tasks/register-client.xml
[2]: http://api.yandex.ru/money/doc/dg/tasks/register-client.xml
[3]: http://api.yandex.com/money/
[4]: http://api.yandex.ru/money/
[5]: http://api.yandex.ru/money/doc/dg/reference/process-external-payments.xml
[6]: http://api.yandex.com/money/doc/dg/reference/process-external-payments.xml
[7]: http://api.yandex.ru/money/doc/dg/reference/request-external-payment.xml
[8]: http://api.yandex.com/money/doc/dg/reference/request-external-payment.xml
[9]: http://api.yandex.ru/money/doc/dg/reference/instance-id.xml
[10]: http://api.yandex.com/money/doc/dg/reference/instance-id.xml
[11]: http://api.yandex.ru/money/doc/dg/reference/process-external-payment.xml
[12]: http://api.yandex.com/money/doc/dg/reference/process-external-payment.xml
