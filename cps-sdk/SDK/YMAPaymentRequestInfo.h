//
//  YMAPaymentRequestInfo.h
//  cps-sdk
//
//  Created by mertvetcov on 10.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAPaymentRequestInfo : NSObject

+ (instancetype)paymentRequestInfoWithId:(NSString *)requestId amount:(NSString *)amount andTitle:(NSString *)title;

@property(nonatomic, copy, readonly) NSString *requestId;
@property(nonatomic, copy, readonly) NSString *amount;
@property(nonatomic, copy, readonly) NSString *title;

@end
