//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAWalletSourceGroupModel.h"
#import "YMAMoneySourceModel.h"
#import "YMACardsSourceGroupModel.h"

@interface YMAMoneySourcesModel : NSObject

+ (instancetype)moneySourcesWithWallet:(YMAWalletSourceGroupModel *)walletSource
                           cardsSource:(YMACardsSourceGroupModel *)cards;

@property (nonatomic, strong, readonly) YMAWalletSourceGroupModel *wallet;
@property (nonatomic, strong, readonly) YMACardsSourceGroupModel *cards;

@end