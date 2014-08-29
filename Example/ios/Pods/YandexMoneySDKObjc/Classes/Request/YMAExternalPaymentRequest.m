//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlExternalPayment = @"api/request-external-payment";
static NSString *const kParameterPatternId = @"pattern_id";

@interface YMAExternalPaymentRequest ()

@property (nonatomic, copy) NSString *patternId;
@property (nonatomic, strong) NSDictionary *paymentParams;

@end

@implementation YMAExternalPaymentRequest

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

+ (instancetype)externalPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams
{
    return [[YMAExternalPaymentRequest alloc] initWithPatternId:patternId andPaymentParams:paymentParams];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString =
        [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlExternalPayment];
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
    return [[YMAExternalPaymentResponse alloc] initWithData:data headers:headers andCompletion:handler];
}

@end