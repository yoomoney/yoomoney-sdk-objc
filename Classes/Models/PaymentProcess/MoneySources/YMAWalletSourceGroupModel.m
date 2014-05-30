//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAWalletSourceGroupModel.h"
#import "YMAMoneySourceModel.h"

@implementation YMAWalletSourceGroupModel

- (id)initWithMoneySource:(YMAMoneySourceModel *)moneySource allowed:(BOOL)allowed {
    self = [super init];

    if (self) {
        _isAllowed = allowed;
        _moneySource = moneySource;
    }

    return self;
}

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed {
    return [[YMAWalletSourceGroupModel alloc] initWithMoneySource:[YMAMoneySourceModel moneySourceWithType:YMAMoneySourceWallet cardType:YMAPaymentCardUnknown panFragment:nil moneySourceToken:nil] allowed:allowed];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"isAllowed" : (self.isAllowed) ? @"YES" : @"NO"
                                      }];
}

@end