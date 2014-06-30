//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAMoneySource.h"

@class YMAMoneySource;


@interface YMACardsSourceGroup : NSObject

+ (instancetype)cardsSourceWithCards:(NSArray *)cards defaultCard:(YMAMoneySource *)defaultCard cscRequired:(BOOL)cscRequired allowed:(BOOL)allowed;

@property(nonatomic, strong, readonly) YMAMoneySource *defaultCard;
@property(nonatomic, copy, readonly) NSArray *cards;
@property(nonatomic, assign, readonly) BOOL isCscRequired;
@property(nonatomic, assign, readonly) BOOL isAllowed;

@end