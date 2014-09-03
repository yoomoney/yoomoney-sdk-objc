# YandexMoneySDKObjc

[![Version](http://cocoapod-badges.herokuapp.com/v/YandexMoneySDKObjc/badge.png)](http://api.yandex.ru/money/)
[![Platform](http://cocoapod-badges.herokuapp.com/p/YandexMoneySDKObjc/badge.png)](http://api.yandex.ru/money/)

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

### App registration

To be able to use the library you: the first thing you need to do is to register your application and get your unique *client id*. To do that please follow the steps described on [this page][1] (also available in [Russian][2]).

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

## Installation

YandexMoneySDKObjc is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "YandexMoneySDKObjc"

## License

YandexMoneySDKObjc is available under the MIT license. See the LICENSE file for more info.

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
