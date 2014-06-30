//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySources.h"
#import "YMAWalletSourceGroup.h"
#import "YMACardsSourceGroup.h"


@implementation YMAMoneySources

- (id)initWithWallet:(YMAWalletSourceGroup *)walletSource cardsSource:(YMACardsSourceGroup *)cards {
    self = [super init];

    if (self) {
        _wallet = walletSource;
        _cards = cards;
    }

    return self;
}

+ (instancetype)moneySourcesWithWallet:(YMAWalletSourceGroup *)walletSource cardsSource:(YMACardsSourceGroup *)cards {
    return [[YMAMoneySources alloc] initWithWallet:walletSource cardsSource:cards];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"wallet" : self.wallet.description,
                                              @"cards" : self.cards.description
                                      }];
}


@end