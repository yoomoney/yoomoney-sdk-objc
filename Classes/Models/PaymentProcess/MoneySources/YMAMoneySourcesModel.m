//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourcesModel.h"
#import "YMAWalletSourceGroupModel.h"
#import "YMACardsSourceGroupModel.h"


@implementation YMAMoneySourcesModel

- (id)initWithWallet:(YMAWalletSourceGroupModel *)walletSource cardsSource:(YMACardsSourceGroupModel *)cards {
    self = [super init];

    if (self) {
        _wallet = walletSource;
        _cards = cards;
    }

    return self;
}

+ (instancetype)moneySourcesWithWallet:(YMAWalletSourceGroupModel *)walletSource cardsSource:(YMACardsSourceGroupModel *)cards {
    return [[YMAMoneySourcesModel alloc] initWithWallet:walletSource cardsSource:cards];
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