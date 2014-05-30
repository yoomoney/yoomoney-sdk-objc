//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABasePaymentProcessResponse.h"

@class YMAPaymentInfoModel;

@interface YMAPaymentResponse : YMABasePaymentProcessResponse

@property(nonatomic, strong, readonly) YMAPaymentInfoModel *paymentInfo;

@end