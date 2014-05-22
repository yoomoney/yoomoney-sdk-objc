//
// Created by mertvetcov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMAGoods : NSObject

+ (instancetype)goodsWithId:(NSString *)merchantArticleId serial:(NSString *)serial secret:(NSString *)secret;

@property(nonatomic, copy, readonly) NSString *merchantArticleId;
@property(nonatomic, copy, readonly) NSString *serial;
@property(nonatomic, copy, readonly) NSString *secret;

@end