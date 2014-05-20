//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAHostsProvider : NSObject

@property(nonatomic, copy, readonly) NSString *moneyUrl;
@property(nonatomic, copy, readonly) NSString *spMoneyUrl;

+ (instancetype)sharedManager;

@end