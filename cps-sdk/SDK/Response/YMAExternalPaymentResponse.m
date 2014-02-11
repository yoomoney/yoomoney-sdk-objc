//
// Created by Александр Мертвецов on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentResponse.h"
#import "YMAPaymentRequestInfo.h"

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterContractAmount = @"contract_amount";
static NSString *const kParametertTitle = @"title";

@implementation YMAExternalPaymentResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    NSString *requestId = [responseModel objectForKey:kParameterRequestId];
    NSString *contractAmount = [responseModel objectForKey:kParameterContractAmount];
    NSString *title = [responseModel objectForKey:kParametertTitle];
    
    _paymentRequestInfo = [YMAPaymentRequestInfo paymentRequestInfoWithId:requestId amount:contractAmount andTitle:title];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"requestId" : self.paymentRequestInfo.requestId,
                                              @"contract amount" : self.paymentRequestInfo.amount,
                                              @"title" : self.paymentRequestInfo.title
                                      }];
}

@end