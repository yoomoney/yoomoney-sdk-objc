//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAWalletSource;
@class YMACard;
@class YMACardsSource;


@interface YMAMoneySources : NSObject

+ (instancetype)moneySourcesWithWallet:(YMAWalletSource *)walletSource cardsSource:(YMACardsSource *)cards;

@property(nonatomic, strong, readonly) YMAWalletSource *wallet;
@property(nonatomic, strong, readonly) YMACardsSource *cards;

@end