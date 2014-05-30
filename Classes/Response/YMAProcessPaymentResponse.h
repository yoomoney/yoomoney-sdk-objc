//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABasePaymentProcessResponse.h"

@class YMAPaymentResultModel;
@class YMADigitalGoodsModel;

@interface YMAProcessPaymentResponse : YMABasePaymentProcessResponse

+ (YMADigitalGoodsModel *)digitalGoodsByModel:(id)digitalGoodsModel;

@property(nonatomic, strong, readonly) YMAPaymentResultModel *paymentResultInfo;

@end