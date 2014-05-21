//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySources.h"
#import "YMAWalletSource.h"
#import "YMACard.h"
#import "YMACardsSource.h"


@implementation YMAMoneySources

- (id)initWithWallet:(YMAWalletSource *)walletSource cardsAllowed:(BOOL)cardsAllowed cards:(NSArray *)cards andDefaultCard:(YMACard *)defaultCard {
    self = [super init];

    if (self) {
        _wallet = walletSource;
        _cards = cards;
        _defaultCard = defaultCard;
        _isCardsAllowed = cardsAllowed;
    }

    return self;
}

+ (instancetype)moneySourcesWithWallet:(YMAWalletSource *)walletSource cardsAllowed:(BOOL)cardsAllowed cards:(NSArray *)cards andDefaultCard:(YMACard *)defaultCard {
    return [[YMAMoneySources alloc] initWithWallet:walletSource cardsAllowed:(BOOL)cardsAllowed cards:cards andDefaultCard:defaultCard];
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