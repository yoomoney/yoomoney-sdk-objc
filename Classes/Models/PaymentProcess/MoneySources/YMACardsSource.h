//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAMoneySource.h"
#import "YMAMoneySourceGroup.h"

@class YMACard;


@interface YMACardsSource : YMAMoneySourceGroup

+ (instancetype)cardsSourceWithCards:(NSArray *)cards defaultCard:(YMACard *)defaultCard cscRequired:(BOOL)cscRequired;

@property(nonatomic, strong, readonly) YMACard *defaultCard;
@property(nonatomic, strong, readonly) NSArray *cards;
@property(nonatomic, assign, readonly) BOOL isCscRequired;

@end