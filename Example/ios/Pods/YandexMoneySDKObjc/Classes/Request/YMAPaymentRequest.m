//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlPayment = @"api/request-payment";
static NSString *const kParameterPatternId = @"pattern_id";

@interface YMAPaymentRequest ()

@property (nonatomic, copy) NSString *patternId;
@property (nonatomic, strong) NSDictionary *paymentParams;

@end

@implementation YMAPaymentRequest

#pragma mark - Object Lifecycle

- (id)initWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams
{
    self = [super init];

    if (self != nil) {
        _patternId = [patternId copy];
        _paymentParams = paymentParams;
    }

    return self;
}

+ (instancetype)paymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams
{
    return [[YMAPaymentRequest alloc] initWithPatternId:patternId andPaymentParams:paymentParams];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString =
        [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlPayment];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.paymentParams];
    [dictionary setValue:self.patternId forKey:kParameterPatternId];
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data headers:(NSDictionary *)headers andCompletionHandler:(YMAResponseHandler)handler
{
    return [[YMAPaymentResponse alloc] initWithData:data headers:headers andCompletion:handler];
}

@end