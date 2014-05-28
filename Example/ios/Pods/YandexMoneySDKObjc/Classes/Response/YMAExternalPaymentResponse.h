//
// Created by Alexander Mertvetsov on 28.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABasePaymentProcessResponse.h"

@class YMAExternalPaymentInfo;

///
/// Payment response. This class contains payment info (paymentRequestInfo)
///
@interface YMAExternalPaymentResponse : YMABasePaymentProcessResponse

/// Info about the current payment request.
/// The property is not equal to zero for status = YMAResponseStatusInProgress.
@property(nonatomic, strong, readonly) YMAExternalPaymentInfo *paymentRequestInfo;

@end