//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourcesModel.h"

@implementation YMAMoneySourcesModel

#pragma mark - Object Lifecycle

- (instancetype)initWithWallet:(YMAWalletSourceGroupModel *)walletSource cardsSource:(YMACardsSourceGroupModel *)cards
{
    self = [super init];

    if (self != nil) {
        _wallet = walletSource;
        _cards = cards;
    }

    return self;
}

+ (instancetype)moneySourcesWithWallet:(YMAWalletSourceGroupModel *)walletSource
                           cardsSource:(YMACardsSourceGroupModel *)cards
{
    return [[YMAMoneySourcesModel alloc] initWithWallet:walletSource cardsSource:cards];
}

@end