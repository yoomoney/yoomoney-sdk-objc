//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAGoods.h"


@implementation YMAGoods

- (id)initWithId:(NSString *)merchantArticleId serial:(NSString *)serial secret:(NSString *)secret {
    self = [super init];

    if (self) {
        _merchantArticleId = [merchantArticleId copy];
        _secret = [secret copy];
        _serial = [serial copy];
    }

    return self;
}

+ (instancetype)goodsWithId:(NSString *)merchantArticleId serial:(NSString *)serial secret:(NSString *)secret {
    return [[YMAGoods alloc] initWithId:merchantArticleId serial:serial secret:secret];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"merchantArticleId" : self.merchantArticleId,
                                              @"serial" : self.serial,
                                              @"secret" : self.secret
                                      }];
}


@end