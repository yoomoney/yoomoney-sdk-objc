//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAWalletSource;
@class YMACardSource;


@interface YMAMoneySources : NSObject

- (instancetype)moneySourcesWithWallet:(YMAWalletSource *)walletSource cards:(NSArray *)cards andDefaultCard:(YMACardSource *)defaultCard;

@property(nonatomic, strong, readonly) YMAWalletSource *wallet;
@property(nonatomic, strong, readonly) YMACardSource *defaultCard;
@property(nonatomic, strong, readonly) NSArray *cards;

@end