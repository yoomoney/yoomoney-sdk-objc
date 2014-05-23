//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABasePaymentProcessResponse.h"

@class YMAPaymentResultInfo;

@interface YMAProcessPaymentResponse : YMABasePaymentProcessResponse

@property(nonatomic, strong, readonly) YMAPaymentResultInfo *paymentResultInfo;

@end