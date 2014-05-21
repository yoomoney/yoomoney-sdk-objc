//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAWalletSourceGroup : NSObject

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed;

@property(nonatomic, assign, readonly) BOOL isAllowed;

@end