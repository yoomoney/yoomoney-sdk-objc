//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAWalletSourceGroup.h"
#import "YMAMoneySource.h"

@implementation YMAWalletSourceGroup

- (id)initWithMoneySource:(YMAMoneySource *)moneySource  allowed:(BOOL)allowed {
    self = [super init];

    if (self) {
        _isAllowed = allowed;
        _moneySource = moneySource;
    }

    return self;
}

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed {
    return [[YMAWalletSourceGroup alloc] initWithMoneySource:[YMAMoneySource moneySourceWithType:YMAMoneySourceWallet cardType:YMAPaymentCardUnknown panFragment:nil moneySourceToken:nil] allowed:allowed];
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