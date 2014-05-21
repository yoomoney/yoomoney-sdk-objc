//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAMoneySource;

@interface YMAWalletSourceGroup : NSObject

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed;

@property(nonatomic, assign, readonly) BOOL isAllowed;
@property(nonatomic, strong, readonly) YMAMoneySource *moneySource;

@end