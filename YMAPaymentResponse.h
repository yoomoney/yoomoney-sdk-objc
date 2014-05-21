//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABasePaymentProcessResponse.h"

@class YMAPaymentInfo;


@interface YMAPaymentResponse : YMABasePaymentProcessResponse

@property(nonatomic, strong, readonly) YMAPaymentInfo *paymentInfo;

@end