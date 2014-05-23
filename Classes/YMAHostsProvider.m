//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAHostsProvider.h"

static NSString *const kDefaultModeyUrl = @"money.yandex.ru";
static NSString *const kDefaultSpMoneyUrl = @"m.sp-money.yandex.ru";

@implementation YMAHostsProvider

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });

    return sharedMyManager;
}

- (id)init {
    self = [super init];

    if (self) {
        _moneyUrl = [kDefaultModeyUrl copy];
        _spMoneyUrl = [kDefaultSpMoneyUrl copy];
    }

    return self;
}

@end