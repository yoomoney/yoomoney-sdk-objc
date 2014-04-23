//
//  ViewController.m
//  ios-example
//
//  Created by Alexander Mertvetsov on 07.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "ViewController.h"
#import <ymcpssdk.h>

static NSString *const kKeychainIdInstance = @"instanceKeychainId";
static NSString *const kSuccessUrl = @"yandexmoneyapp://oauth/authorize/success";
static NSString *const kFailUrl = @"yandexmoneyapp://oauth/authorize/fail";

//Use you application identifier
static NSString *const kClientId = @"YOU_CLIENT_ID";

@interface ViewController () {
    NSMutableDictionary *_instanceIdQuery;
    YMASession *_session;
}

@property(nonatomic, strong) UIButton *doPaymentButton;
@property(nonatomic, strong) UILabel *phoneNumberLabel;
@property(nonatomic, strong) UITextField *phoneNumberTextField;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITextField *amountTextField;
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) YMAPaymentRequestInfo *paymentRequestInfo;
@property(nonatomic, strong, readonly) NSDictionary *instanceIdQuery;
@property(nonatomic, copy) NSString *instanceId;
@property(nonatomic, strong, readonly) YMASession *session;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.doPaymentButton setTitle: @"pay" forState:UIControlStateNormal];
    [self.doPaymentButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.doPaymentButton];
    
    [self.doPaymentButton addTarget:self action:@selector(doTestPayment) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumberLabel.text = @"phone number";
    
    
    [self.view addSubview:self.phoneNumberLabel];
    
    UIView *bgPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 44)];
    bgPhoneView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:bgPhoneView];
    [bgPhoneView release];
    
    self.phoneNumberTextField.placeholder = @"7##########";
    [self.view addSubview:self.phoneNumberTextField];
    
    self.amountLabel.text = @"Amount (RUB)";
    [self.view addSubview:self.amountLabel];
    
    UIView *bgAmountView = [[UIView alloc] initWithFrame:CGRectMake(0, 184, self.view.frame.size.width, 44)];
    bgAmountView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:bgAmountView];
    [bgAmountView release];
    
    self.amountTextField.placeholder = @"0 rub.";
    [self.view addSubview:self.amountTextField];
}

- (void)dealloc {
    [_doPaymentButton release];
    [_phoneNumberLabel release];
    [_phoneNumberTextField release];
    [_amountLabel release];
    [_amountTextField release];
    [_instanceIdQuery release];
    [_webView release];
    [_paymentRequestInfo release];
    [_session release];
    
    [super dealloc];
}

- (void)doTestPayment {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:(id) kSecClassGenericPassword forKey:(id) kSecClass];
    SecItemDelete((CFDictionaryRef) dict);
    
    NSDictionary *paymentParams = @{@"amount" : self.amountTextField.text, @"phone-number" : self.phoneNumberTextField.text};
    
    // Register your application using clientId and obtaining instanceId (if needed).
    [self updateInstanceWithCompletion:^(NSError *error) {
        if (error)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError:error];
            });
        else {
            // Payment request. First phase of payment is required to obtain payment info (YMAPaymentRequestInfo)
            [self startPaymentWithPatternId:@"phone-topup" andPaymentParams:paymentParams completion:^(YMAPaymentRequestInfo *requestInfo, NSError *paymentRequestError) {
                if (!paymentRequestError) {
                    self.paymentRequestInfo = requestInfo;
                    // Process payment request. Second phase of payment.
                    [self finishPayment];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showError:paymentRequestError];
                    });
                }
            }];
        }
    }];
}

#pragma mark -
#pragma mark *** UI  ***
#pragma mark -

- (UIButton *)doPaymentButton {
    if (!_doPaymentButton) {
        CGRect buttonRect = CGRectMake(0, 270, self.view.frame.size.width, 44);
        
        _doPaymentButton = [[UIButton alloc] initWithFrame:buttonRect];
        _doPaymentButton.backgroundColor = [UIColor whiteColor];
    }
    
    return _doPaymentButton;
}

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        CGRect labelRect = CGRectMake(20, 40, self.view.frame.size.width - 40, 44);
        
        _phoneNumberLabel = [[UILabel alloc] initWithFrame:labelRect];
    }
    
    return _phoneNumberLabel;
}

- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        CGRect textFieldRect = CGRectMake(20, 84, self.view.frame.size.width - 40, 44);
        
        _phoneNumberTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        _phoneNumberTextField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    
    return _phoneNumberTextField;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        CGRect labelRect = CGRectMake(20, 140, self.view.frame.size.width - 40, 44);
        
        _amountLabel = [[UILabel alloc] initWithFrame:labelRect];
    }
    
    return _amountLabel;
}

- (UITextField *)amountTextField {
    if (!_amountTextField) {
        CGRect textFieldRect = CGRectMake(20, 184, self.view.frame.size.width - 40, 44);
        
        _amountTextField = [[UITextField alloc] initWithFrame:textFieldRect];
        _amountTextField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    
    return _amountTextField;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    
    return _webView;
}

- (void)showError:(NSError *)error {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error ? error.domain : @"fail" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
    [alert show];

}

#pragma mark -
#pragma mark *** UIWebViewDelegate ***
#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![request URL])
        return NO;
    
    NSString *scheme = [[request URL] scheme];
    NSString *path = [[request URL] path];
    NSString *host = [[request URL] host];
    
    NSString *strippedURL = [NSString stringWithFormat:@"%@://%@%@", scheme, host, path];
    
    if ([strippedURL isEqual:kSuccessUrl]) {
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self finishPayment];
        });
        
        [webView removeFromSuperview];
        
        return NO;
    }
    
    if ([strippedURL isEqual:kFailUrl]) {
        [self showError:nil];
        [webView removeFromSuperview];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}


#pragma mark -
#pragma mark *** Payment process  ***
#pragma mark -

- (YMASession *)session {
    if (!_session) {
        _session = [[YMASession alloc] init];
    }
    
    return _session;
}

- (void)updateInstanceWithCompletion:(YMAHandler)block {
    NSString *instanceId = self.instanceId;
    
    if (!instanceId || [instanceId isEqual:@""]) {
        [self.session authorizeWithClientId:kClientId completion:^(NSString *newInstanceId, NSError *error) {
            if (error)
                block(error);
            else {
                self.instanceId = newInstanceId;
                block(nil);                
            }
        }];
        
        return;
    }
    
    self.session.instanceId = instanceId;
    block(nil);
}

- (void)startPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams completion:(void (^)(YMAPaymentRequestInfo *requestInfo, NSError *error))block {
    YMABaseRequest *externalPaymentRequest = [YMAExternalPaymentRequest externalPaymentWithPatternId:patternId andPaymentParams:paymentParams];
    
    [self.session performRequest:externalPaymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }
        
        YMAExternalPaymentResponse *externalPaymentResponse = (YMAExternalPaymentResponse *) response;
        block(externalPaymentResponse.paymentRequestInfo, nil);
    }];
}

- (void)finishPaymentWithRequestId:(NSString *)requestId completion:(void (^)(YMAAsc *asc, NSError *error))block {
    YMABaseRequest *processExternalPaymentRequest = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:kSuccessUrl failUri:kFailUrl requestToken:NO];
    
    [self processPaymentRequest:processExternalPaymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }
        
        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request, @"response" : response}];
        
        if (response.status == YMAResponseStatusSuccess)
            block(nil, nil);
        else if (response.status == YMAResponseStatusExtAuthRequired) {
            YMAProcessExternalPaymentResponse *processExternalPaymentResponse = (YMAProcessExternalPaymentResponse *) response;
            YMAAsc *asc = processExternalPaymentResponse.asc;
            
            block(asc, asc ? nil : unknownError);
        } else
            block(nil, unknownError);
    }];
}

- (void)processPaymentRequest:(YMABaseRequest *)paymentRequest completion:(YMARequestHandler)block {
    [self.session performRequest:paymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (response.status == YMAResponseStatusInProgress) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, response.nextRetry);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self processPaymentRequest:request completion:block];
            });
        } else
            block(request, response, error);
    }];
}

- (void)finishPayment {
    [self finishPaymentWithRequestId:self.paymentRequestInfo.requestId completion:^(YMAAsc *asc, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processPaymentRequestWithAsc:asc andError:error];
        });
    }];
}

- (void)processPaymentRequestWithAsc:(YMAAsc *)asc andError:(NSError *)error {
    if (error)
        [self showError:error];
    else if (asc) {
        
        // Process info about redirect to authorization page.
        
        NSMutableString *post = [NSMutableString string];
        
        for (NSString *key in asc.params.allKeys) {
            NSString *paramValue = [self addPercentEscapesToString:[asc.params objectForKey:key]];
            NSString *paramKey = [self addPercentEscapesToString:key];
            
            [post appendString:[NSString stringWithFormat:@"%@=%@&", paramKey, paramValue]];
        }
        
        if (post.length)
            [post deleteCharactersInRange:NSMakeRange(post.length - 1, 1)];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:asc.url];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) postData.length] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];

        if (!self.webView.superview)
            [self.view addSubview:self.webView];
        
        [self.webView loadRequest:request];
        
        if (self.phoneNumberTextField.isFirstResponder)
            [self.phoneNumberTextField resignFirstResponder];
        
        if (self.amountTextField.isFirstResponder)
            [self.amountTextField resignFirstResponder];
        
    } else {
        
        // Success payment
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (NSString *)addPercentEscapesToString:(NSString *)string {
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (__bridge CFStringRef)string,
                                                                                  NULL,
                                                                                  (CFStringRef)@";/?:@&=+$,",
                                                                                  kCFStringEncodingUTF8));
}

#pragma mark -
#pragma mark *** Key Chain  ***
#pragma mark -

- (NSString *)instanceId {
    CFTypeRef outDictionaryRef = [self performQuery:self.instanceIdQuery];
    
    if (outDictionaryRef != NULL) {
        NSMutableDictionary *outDictionary = (NSMutableDictionary *) outDictionaryRef;
        NSDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];
        
        return [queryResult objectForKey:(id) kSecValueData];
    }
    
    return nil;
}

- (void)setInstanceId:(NSString *)instanceId {
    CFTypeRef outDictionaryRef = [self performQuery:self.instanceIdQuery];
    NSMutableDictionary *secItem;
    
    if (outDictionaryRef != NULL) {
        NSMutableDictionary *outDictionary = (NSMutableDictionary *) outDictionaryRef;
        NSMutableDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];
        
        if (![[queryResult objectForKey:(id) kSecValueData] isEqual:instanceId]) {
            secItem = [self dictionaryToSecItemFormat:@{(id) kSecValueData : instanceId}];
            SecItemUpdate((CFDictionaryRef) self.instanceIdQuery, (CFDictionaryRef) secItem);
        }
        
        return;
    }
    
    secItem = [self dictionaryToSecItemFormat:@{(id) kSecValueData : instanceId}];
    [secItem setObject:kKeychainIdInstance forKey:(id) kSecAttrGeneric];
    SecItemAdd((CFDictionaryRef) secItem, NULL);
}

- (NSDictionary *)instanceIdQuery {
    if (!_instanceIdQuery) {
        _instanceIdQuery = [[NSMutableDictionary alloc] init];
        [_instanceIdQuery setObject:(id) kSecClassGenericPassword forKey:(id) kSecClass];
        [_instanceIdQuery setObject:kKeychainIdInstance forKey:(id) kSecAttrGeneric];
        [_instanceIdQuery setObject:(id) kSecMatchLimitOne forKey:(id) kSecMatchLimit];
        [_instanceIdQuery setObject:(id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
    }
    
    return _instanceIdQuery;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(id) kCFBooleanTrue forKey:(id) kSecReturnData];
    [returnDictionary setObject:(id) kSecClassGenericPassword forKey:(id) kSecClass];
    
    CFTypeRef itemDataRef = nil;
    
    if (!SecItemCopyMatching((CFDictionaryRef) returnDictionary, &itemDataRef)) {
        NSData *data = (NSData *) itemDataRef;
        
        [returnDictionary removeObjectForKey:(id) kSecReturnData];
        NSString *itemData = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:itemData forKey:(id) kSecValueData];
        [itemData release];
    }
    
    return returnDictionary;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(id) kSecClassGenericPassword forKey:(id) kSecClass];
    NSString *secDataString = [dictionaryToConvert objectForKey:(id) kSecValueData];
    [returnDictionary setObject:[secDataString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id) kSecValueData];
    
    return returnDictionary;
}

- (CFTypeRef)performQuery:(NSDictionary *)query {
    CFTypeRef outDictionaryRef = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef) query, &outDictionaryRef) == errSecSuccess)
        return outDictionaryRef;
    
    return NULL;
}

@end
