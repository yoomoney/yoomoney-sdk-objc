//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAWalletSourceGroup;
@class YMAMoneySource;
@class YMACardsSourceGroup;


@interface YMAMoneySources : NSObject

+ (instancetype)moneySourcesWithWallet:(YMAWalletSourceGroup *)walletSource cardsSource:(YMACardsSourceGroup *)cards;

@property(nonatomic, strong, readonly) YMAWalletSourceGroup *wallet;
@property(nonatomic, strong, readonly) YMACardsSourceGroup *cards;

@end