//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySources.h"
#import "YMAWalletSource.h"
#import "YMACardSource.h"


@implementation YMAMoneySources

- (id)initWithWallet:(YMAWalletSource *)walletSource cards:(NSArray *)cards andDefaultCard:(YMACardSource *)defaultCard {
    self = [super init];

    if (self) {
        _wallet = walletSource;
        _cards = cards;
        _defaultCard = defaultCard;
    }

    return self;
}

- (instancetype)moneySourcesWithWallet:(YMAWalletSource *)walletSource cards:(NSArray *)cards andDefaultCard:(YMACardSource *)defaultCard {
    return [[YMAMoneySources alloc] initWithWallet:walletSource cards:cards andDefaultCard:defaultCard];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"wallet" : self.wallet.description,
                                              @"defaultCard" : self.defaultCard.description,
                                              @"cards" : self.cards.description
                                      }];
}


@end