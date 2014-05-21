//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAMoneySource.h"


@interface YMAWalletSource : YMAMoneySource

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed;

@end