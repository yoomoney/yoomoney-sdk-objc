//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlExternalPayment = @"api/request-external-payment";
static NSString *const kParameterPatternId = @"pattern_id";

@interface YMAExternalPaymentRequest ()

@property(nonatomic, copy) NSString *patternId;
@property(nonatomic, strong) NSDictionary *paymentParams;

@end

@implementation YMAExternalPaymentRequest

- (id)initWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    self = [super init];

    if (self) {
        _patternId = [patternId copy];
        _paymentParams = paymentParams;
    }

    return self;
}

+ (instancetype)externalPaymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    return [[YMAExternalPaymentRequest alloc] initWithPatternId:patternId andPaymentParams:paymentParams];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlExternalPayment];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.paymentParams];
    [dictionary setObject:self.patternId forKey:kParameterPatternId];
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAExternalPaymentResponse alloc] initWithData:data andCompletion:handler];
}

@end