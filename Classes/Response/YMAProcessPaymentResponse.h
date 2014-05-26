//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABasePaymentProcessResponse.h"

@class YMAPaymentResultInfo;
@class YMADigitalGoods;

@interface YMAProcessPaymentResponse : YMABasePaymentProcessResponse

+ (YMADigitalGoods *)digitalGoodsByModel:(id)digitalGoodsModel;

@property(nonatomic, strong, readonly) YMAPaymentResultInfo *paymentResultInfo;

@end