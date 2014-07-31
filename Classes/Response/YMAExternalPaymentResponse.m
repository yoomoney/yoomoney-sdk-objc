//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentResponse.h"

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterContractAmount = @"contract_amount";
static NSString *const kParameterTitle = @"title";

@implementation YMAExternalPaymentResponse

#pragma mark - Overridden methods

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error
{
    [super parseJSONModel:responseModel error:error];

    NSString *requestId = responseModel[kParameterRequestId];
    NSString *contractAmount = [responseModel[kParameterContractAmount] stringValue];
    NSString *title = responseModel[kParameterTitle];

    _paymentRequestInfo =
        [YMAExternalPaymentInfoModel paymentRequestInfoWithId:requestId amount:contractAmount andTitle:title];
}

@end