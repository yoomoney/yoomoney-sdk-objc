//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentRequest.h"
#import "YMAHostsProvider.h"
#import "YMAPaymentResponse.h"

static NSString *const kUrlPayment = @"api/request-payment";
static NSString *const kParameterPatternId = @"pattern_id";

@interface YMAPaymentRequest ()

@property(nonatomic, copy) NSString *patternId;
@property(nonatomic, strong) NSDictionary *paymentParams;

@end

@implementation YMAPaymentRequest

- (id)initWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    self = [super init];

    if (self) {
        _patternId = [patternId copy];
        _paymentParams = paymentParams;
    }

    return self;
}

+ (instancetype)paymentWithPatternId:(NSString *)patternId andPaymentParams:(NSDictionary *)paymentParams {
    return [[YMAPaymentRequest alloc] initWithPatternId:patternId andPaymentParams:paymentParams];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlPayment];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.paymentParams];
    [dictionary setObject:self.patternId forKey:kParameterPatternId];
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAPaymentResponse alloc] initWithData:data andCompletion:handler];
}

@end