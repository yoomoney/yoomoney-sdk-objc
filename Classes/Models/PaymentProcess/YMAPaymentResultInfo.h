//
// Created by mertvetcov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAAsc;
@class YMADigitalGoods;


@interface YMAPaymentResultInfo : NSObject

+ (instancetype)paymentResultWithPaymentId:(NSString *)paymentId balance:(NSString *)balance invoiceId:(NSString *)invoiceId payer:(NSString *)payer payee:(NSString *)payee creditAmount:(NSString *)creditAmount payeeUid:(NSString *)payeeUid holdForPickupLink:(NSURL *)holdForPickupLink asc:(YMAAsc *)asc digitalGoods:(YMADigitalGoods *)digitalGoods;

@property(nonatomic, copy, readonly) NSString *paymentId;
@property(nonatomic, copy, readonly) NSString *balance;
@property(nonatomic, copy, readonly) NSString *invoiceId;
@property(nonatomic, copy, readonly) NSString *payer;
@property(nonatomic, copy, readonly) NSString *payee;
@property(nonatomic, copy, readonly) NSString *creditAmount;
@property(nonatomic, copy, readonly) NSString *payeeUid;
@property(nonatomic, strong, readonly) NSURL *holdForPickupLink;
@property(nonatomic, strong, readonly) YMAAsc *asc;
@property(nonatomic, strong, readonly) YMADigitalGoods *digitalGoods;

@end