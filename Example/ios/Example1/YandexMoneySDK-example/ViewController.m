#import "ViewController.h"
#import "YMAExternalPaymentInfoModel.h"
#import "YMAExternalPaymentSession.h"
#import "YMAExternalPaymentRequest.h"
#import "YMAAscModel.h"
#import "YMAProcessExternalPaymentRequest.h"

static NSString *const kHttpsScheme = @"https";

static NSString *const kKeychainIdInstance = @"instanceKeychainId";
static NSString *const kSuccessUrl = @"yandexmoneyapp://oauth/authorize/success";
static NSString *const kFailUrl = @"yandexmoneyapp://oauth/authorize/fail";

// You must register your application and receive unique "client_id".
// More information: http://api.yandex.com/money/doc/dg/tasks/register-client.xml
static NSString *const kClientId = @"CLIENT_ID";
#error You should paste your unique client_id.

@interface ViewController () {
    NSMutableDictionary *_instanceIdQuery;
    YMAExternalPaymentSession *_session;
}

@property(nonatomic, strong) UIButton *doPaymentButton;
@property(nonatomic, strong) UILabel *phoneNumberLabel;
@property(nonatomic, strong) UITextField *phoneNumberTextField;
@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UITextField *amountTextField;
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) YMAExternalPaymentInfoModel *paymentRequestInfo;
@property(nonatomic, strong, readonly) NSDictionary *instanceIdQuery;
@property(nonatomic, copy) NSString *instanceId;
@property(nonatomic, strong, readonly) YMAExternalPaymentSession *session;

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
    
    self.phoneNumberTextField.placeholder = @"7##########";
    [self.view addSubview:self.phoneNumberTextField];
    
    self.amountLabel.text = @"Amount (RUB)";
    [self.view addSubview:self.amountLabel];
    
    UIView *bgAmountView = [[UIView alloc] initWithFrame:CGRectMake(0, 184, self.view.frame.size.width, 44)];
    bgAmountView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:bgAmountView];
    
    self.amountTextField.placeholder = @"0 rub.";
    [self.view addSubview:self.amountTextField];
}



- (void)doTestPayment {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id) kSecClass] = (id) kSecClassGenericPassword;
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
            [self startPaymentWithPatternId:@"phone-topup" andPaymentParams:paymentParams completion:^(YMAExternalPaymentInfoModel *requestInfo, NSError *paymentRequestError) {
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
        _phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
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
        _amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    return _amountTextField;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    }
    
    return _webView;
}

- (void)showError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error ? error.domain : @"fail" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark -
#pragma mark *** UIWebViewDelegate ***
#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request URL] == nil) {
        return NO;
    }
    
    NSString *strippedURL        = [self strippedURL:request.URL];
    NSString *strippedSuccessURL = [self strippedURL:[NSURL URLWithString:kSuccessUrl]];
    NSString *strippedFailURL    = [self strippedURL:[NSURL URLWithString:kFailUrl]];
    
    if ([strippedURL isEqualToString:strippedSuccessURL]) {
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self finishPayment];
        });
        
        [webView removeFromSuperview];
        
        return NO;
    }
    
    if ([strippedURL isEqualToString:strippedFailURL]) {
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

- (YMAExternalPaymentSession *)session {
    if (!_session) {
        _session = [[YMAExternalPaymentSession alloc] init];
    }
    
    return _session;
}

- (void)updateInstanceWithCompletion:(YMAHandler)block {
    NSString *currentInstanceId = self.instanceId;
    
    if (!currentInstanceId || [currentInstanceId isEqual:@""]) {
        [self.session instanceWithClientId:kClientId
                                     token:nil
                                completion:^(NSString *instanceId, NSError *error) {
                                    if (error)
                                        block(error);
                                    else {
                                        self.instanceId = instanceId;
                                        self.session.instanceId = instanceId;
                                        block(nil);
                                    }
                                }];

        return;
    }
    
    self.session.instanceId = currentInstanceId;
    block(nil);
}

- (void)startPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams completion:(void (^)(YMAExternalPaymentInfoModel *requestInfo, NSError *error))block {
    YMABaseRequest *externalPaymentRequest = [YMAExternalPaymentRequest externalPaymentWithPatternId:patternId paymentParameters:paymentParams];

    [self.session performRequest:externalPaymentRequest
                           token:nil
                      completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
                   if (error) {
                       block(nil, error);
                       return;
                   }

                   YMAExternalPaymentResponse *externalPaymentResponse = (YMAExternalPaymentResponse *) response;
                   block(externalPaymentResponse.paymentRequestInfo, nil);
               }];
}

- (void)finishPaymentWithRequestId:(NSString *)requestId completion:(void (^)(YMAAscModel *asc, NSError *error))block {
    YMABaseRequest *processExternalPaymentRequest = [YMAProcessExternalPaymentRequest processExternalPaymentWithRequestId:requestId successUri:kSuccessUrl failUri:kFailUrl requestToken:NO];
    
    [self processPaymentRequest:processExternalPaymentRequest completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }
        
        NSError *unknownError = [NSError errorWithDomain:YMAErrorDomainUnknown code:0 userInfo:@{@"request" : request, @"response" : response}];

        YMABaseProcessResponse *processResponse = (YMABaseProcessResponse *)response;

        if (processResponse.status == YMAResponseStatusSuccess)
            block(nil, nil);
        else if (processResponse.status == YMAResponseStatusExtAuthRequired) {
            YMAProcessExternalPaymentResponse *processExternalPaymentResponse = (YMAProcessExternalPaymentResponse *) response;
            YMAAscModel *asc = processExternalPaymentResponse.asc;
            
            block(asc, asc ? nil : unknownError);
        } else
            block(nil, unknownError);
    }];
}

- (void)processPaymentRequest:(YMABaseRequest *)paymentRequest completion:(YMARequestHandler)block {

    [self.session performRequest:paymentRequest
                           token:nil
                      completion:^(YMABaseRequest *request, YMABaseResponse *response, NSError *error) {
                   YMABaseProcessResponse *processResponse = (YMABaseProcessResponse *)response;

                   if (processResponse.status == YMAResponseStatusInProgress) {
                       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, processResponse.nextRetry);
                       dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                           [self processPaymentRequest:request completion:block];
                       });
                   } else
                       block(request, response, error);
               }];
}

- (void)finishPayment {
    [self finishPaymentWithRequestId:self.paymentRequestInfo.requestId completion:^(YMAAscModel *asc, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processPaymentRequestWithAsc:asc andError:error];
        });
    }];
}

- (void)processPaymentRequestWithAsc:(YMAAscModel *)asc andError:(NSError *)error {
    if (error)
        [self showError:error];
    else if (asc) {
        
        // Process info about redirect to authorization page.
        
        NSMutableString *post = [NSMutableString string];
        
        for (NSString *key in asc.params.allKeys) {
            NSString *paramValue = [self addPercentEscapesToString:(asc.params)[key]];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
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

- (NSString *)strippedURL:(NSURL *)url
{
    NSString *scheme = [url.scheme lowercaseString];
    NSString *path   = [url.path stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    NSString *host   = url.host;
    NSInteger port   = [url.port integerValue];
    if (port == 0) {
        if ([scheme isEqualToString:kHttpsScheme]) {
            port = 443;
        }
        else {
            port = 80;
        }
    }
    NSString *strippedURL = [[NSString stringWithFormat:@"%@://%@:%ld/%@", scheme, host, port ,  path] lowercaseString];
    return strippedURL;
}

#pragma mark -
#pragma mark *** Key Chain  ***
#pragma mark -

- (NSString *)instanceId {
    CFTypeRef outDictionaryRef = [self performQuery:self.instanceIdQuery];
    
    if (outDictionaryRef != NULL) {
        NSMutableDictionary *outDictionary = (__bridge NSMutableDictionary *) outDictionaryRef;
        NSDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];
        
        return queryResult[(id) kSecValueData];
    }
    
    return nil;
}

- (void)setInstanceId:(NSString *)instanceId {
    CFTypeRef outDictionaryRef = [self performQuery:self.instanceIdQuery];
    NSMutableDictionary *secItem;
    
    if (outDictionaryRef != NULL) {
        NSMutableDictionary *outDictionary = (__bridge NSMutableDictionary *) outDictionaryRef;
        NSMutableDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];
        
        if (![queryResult[(id) kSecValueData] isEqual:instanceId]) {
            secItem = [self dictionaryToSecItemFormat:@{(id) kSecValueData : instanceId}];
            SecItemUpdate((CFDictionaryRef) self.instanceIdQuery, (CFDictionaryRef) secItem);
        }
        
        return;
    }
    
    secItem = [self dictionaryToSecItemFormat:@{(id) kSecValueData : instanceId}];
    secItem[(id) kSecAttrGeneric] = kKeychainIdInstance;
    SecItemAdd((CFDictionaryRef) secItem, NULL);
}

- (NSDictionary *)instanceIdQuery {
    if (!_instanceIdQuery) {
        _instanceIdQuery = [[NSMutableDictionary alloc] init];
        _instanceIdQuery[(id) kSecClass] = (id) kSecClassGenericPassword;
        _instanceIdQuery[(id) kSecAttrGeneric] = kKeychainIdInstance;
        _instanceIdQuery[(id) kSecMatchLimit] = (id) kSecMatchLimitOne;
        _instanceIdQuery[(id) kSecReturnAttributes] = (id) kCFBooleanTrue;
    }
    
    return _instanceIdQuery;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    returnDictionary[(id) kSecReturnData] = (id) kCFBooleanTrue;
    returnDictionary[(id) kSecClass] = (id) kSecClassGenericPassword;
    
    CFTypeRef itemDataRef = nil;
    
    if (!SecItemCopyMatching((CFDictionaryRef) returnDictionary, &itemDataRef)) {
        NSData *data = (__bridge NSData *) itemDataRef;
        
        [returnDictionary removeObjectForKey:(id) kSecReturnData];
        NSString *itemData = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        returnDictionary[(id) kSecValueData] = itemData;
    }
    
    return returnDictionary;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    returnDictionary[(id) kSecClass] = (id) kSecClassGenericPassword;
    NSString *secDataString = dictionaryToConvert[(id) kSecValueData];
    returnDictionary[(id) kSecValueData] = [secDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    return returnDictionary;
}

- (CFTypeRef)performQuery:(NSDictionary *)query {
    CFTypeRef outDictionaryRef = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef) query, &outDictionaryRef) == errSecSuccess)
        return outDictionaryRef;
    
    return NULL;
}

@end