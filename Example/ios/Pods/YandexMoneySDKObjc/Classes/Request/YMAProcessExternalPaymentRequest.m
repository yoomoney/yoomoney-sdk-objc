//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAProcessExternalPaymentRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlProcessExternalPayment = @"api/process-external-payment";

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterSuccessUri = @"ext_auth_success_uri";
static NSString *const kParameterFailUri = @"ext_auth_fail_uri";
static NSString *const kParameterRequestToken = @"request_token";
static NSString *const kParameterMoneySourceToken = @"money_source_token";
static NSString *const kParameterCsc = @"csc";

@interface YMAProcessExternalPaymentRequest ()

@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *successUri;
@property (nonatomic, copy) NSString *failUri;
@property (nonatomic, assign) BOOL requestToken;
@property (nonatomic, copy) NSString *moneySourceToken;
@property (nonatomic, copy) NSString *csc;

@end

@implementation YMAProcessExternalPaymentRequest

#pragma mark - Object Lifecycle

- (id)initWithRequestId:(NSString *)requestId
             successUri:(NSString *)successUri
                failUri:(NSString *)failUri
           requestToken:(BOOL)requestToken
       moneySourceToken:(NSString *)moneySourceToken
                 andCsc:(NSString *)csc
{
    self = [super init];

    if (self != nil) {
        _requestId = [requestId copy];
        _successUri = [successUri copy];
        _failUri = [failUri copy];
        _requestToken = requestToken;
        _moneySourceToken = [moneySourceToken copy];
        _csc = [csc copy];
    }

    return self;
}

+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId
                                         successUri:(NSString *)successUri
                                            failUri:(NSString *)failUri
                                       requestToken:(BOOL)requestToken
{
    return [[YMAProcessExternalPaymentRequest alloc] initWithRequestId:requestId
                                                            successUri:successUri
                                                               failUri:failUri
                                                          requestToken:requestToken
                                                      moneySourceToken:nil
                                                                andCsc:nil];
}

+ (instancetype)processExternalPaymentWithRequestId:(NSString *)requestId
                                         successUri:(NSString *)successUri
                                            failUri:(NSString *)failUri
                                   moneySourceToken:(NSString *)moneySourceToken
                                             andCsc:(NSString *)csc
{
    return [[YMAProcessExternalPaymentRequest alloc] initWithRequestId:requestId
                                                            successUri:successUri
                                                               failUri:failUri
                                                          requestToken:NO
                                                      moneySourceToken:moneySourceToken
                                                                andCsc:csc];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@",
                                                     [YMAHostsProvider sharedManager].moneyUrl,
                                                     kUrlProcessExternalPayment];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.requestId forKey:kParameterRequestId];
    [dictionary setValue:self.successUri forKey:kParameterSuccessUri];
    [dictionary setValue:self.failUri forKey:kParameterFailUri];

    if (self.moneySourceToken == nil) {
        if (self.requestToken)
            [dictionary setValue:@"true" forKey:kParameterRequestToken];
        
        return dictionary;
    }

    [dictionary setValue:self.moneySourceToken forKey:kParameterMoneySourceToken];
    [dictionary setValue:self.csc forKey:kParameterCsc];
    
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data headers:(NSDictionary *)headers andCompletionHandler:(YMAResponseHandler)handler
{
    return [[YMAProcessExternalPaymentResponse alloc] initWithData:data headers:headers andCompletion:handler];
}

@end