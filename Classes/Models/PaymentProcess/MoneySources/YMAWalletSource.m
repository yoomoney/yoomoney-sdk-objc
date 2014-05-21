//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourceGroup.h"
#import "YMAWalletSource.h"

@implementation YMAWalletSource

- (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed {
    return [[YMAWalletSource alloc] initWithAllowed:allowed];
}

@end