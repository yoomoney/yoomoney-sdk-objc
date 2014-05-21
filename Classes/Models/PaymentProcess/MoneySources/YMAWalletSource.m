//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAWalletSource.h"


@implementation YMAWalletSource

- (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed {
    return [[YMAWalletSource alloc] initWithSourceType:YMAMoneySourceWallet allowed:allowed];
}

@end