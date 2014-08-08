//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAProcessPaymentRequest.h"
#import "YMAMoneySourceModel.h"
#import "YMAHostsProvider.h"

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterMoneySource = @"money_source";
static NSString *const kParameterCsc = @"csc";
static NSString *const kParameterExtAuthSuccessUri = @"ext_auth_success_uri";
static NSString *const kParameterExtAuthFailUri = @"ext_auth_fail_uri";

static NSString *const kUrlProcessPayment = @"api/process-payment";

@interface YMAProcessPaymentRequest ()

@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, strong) YMAMoneySourceModel *moneySource;
@property (nonatomic, copy) NSString *csc;
@property (nonatomic, copy) NSString *successUri;
@property (nonatomic, copy) NSString *failUri;

@end

@implementation YMAProcessPaymentRequest

#pragma mark - Object Lifecycle

- (id)initWithRequestId:(NSString *)requestId
            moneySource:(YMAMoneySourceModel *)moneySource
                    csc:(NSString *)csc
             successUri:(NSString *)successUri
                failUri:(NSString *)failUri
{
    self = [super init];

    if (self != nil) {
        _requestId = [requestId copy];
        _moneySource = moneySource;
        _csc = [csc copy];
        _successUri = [successUri copy];
        _failUri = [failUri copy];
    }

    return self;
}

+ (instancetype)processPaymentRequestId:(NSString *)requestId
                            moneySource:(YMAMoneySourceModel *)moneySource
                                    csc:(NSString *)csc
                             successUri:(NSString *)successUri
                                failUri:(NSString *)failUri
{
    return [[YMAProcessPaymentRequest alloc] initWithRequestId:requestId
                                                   moneySource:moneySource
                                                           csc:csc
                                                    successUri:successUri
                                                       failUri:failUri];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString =
        [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlProcessPayment];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.requestId forKey:kParameterRequestId];
    [dictionary setValue:self.csc forKey:kParameterCsc];
    [dictionary setValue:self.successUri forKey:kParameterExtAuthSuccessUri];
    [dictionary setValue:self.failUri forKey:kParameterExtAuthFailUri];

    if (self.moneySource.type == YMAMoneySourceWallet)
        [dictionary setValue:@"wallet" forKey:kParameterMoneySource];
    else if (self.moneySource.type == YMAMoneySourcePaymentCard)
        [dictionary setValue:[NSString stringWithFormat:@"%@", self.moneySource.moneySourceToken] forKey:kParameterMoneySource];
    
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data headers:(NSDictionary *)headers andCompletionHandler:(YMAResponseHandler)handler
{
    return [[YMAProcessPaymentResponse alloc] initWithData:data headers:headers andCompletion:handler];
}

@end