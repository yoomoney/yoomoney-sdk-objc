//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentResponse.h"
#import "YMAPaymentInfo.h"

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterMoneySource = @"money_source";
static NSString *const kParameterContractAmount = @"contract_amount";
static NSString *const kParameterBalance = @"balance";
static NSString *const kParameterRecipientAccountStatus = @"recipient_account_status";
static NSString *const kParameterRecipientAccountType = @"recipient_account_type";
static NSString *const kParameterProtectionCode = @"protection_code";

@implementation YMAPaymentResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    [super parseJSONModel:responseModel];

    NSString *requestId = [responseModel objectForKey:kParameterRequestId];
    NSString *contractAmount = [[responseModel objectForKey:kParameterContractAmount] stringValue];
    //NSString *title = [responseModel objectForKey:kParameterTitle];

    //_paymentRequestInfo = [YMAExternalPaymentInfo paymentRequestInfoWithId:requestId amount:contractAmount andTitle:title];
}

- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
//                                      @{
//                                              @"requestId" : self.paymentRequestInfo.requestId,
//                                              @"contract amount" : self.paymentRequestInfo.amount,
//                                              @"title" : self.paymentRequestInfo.title
//                                      }];
}

@end