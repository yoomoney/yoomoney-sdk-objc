//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMADigitalGoodsModel.h"


@implementation YMADigitalGoodsModel

- (id)initWithWithArticle:(NSArray *)article bonus:(NSArray *)bonus {
    self = [super init];

    if (self) {
        _article = article;
        _bonus = bonus;
    }

    return self;
}

+ (instancetype)digitalGoodsWithArticle:(NSArray *)article bonus:(NSArray *)bonus {
    return [[YMADigitalGoodsModel alloc] initWithWithArticle:article bonus:bonus];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"article" : self.article.description,
                                              @"bonus" : self.bonus.description
                                      }];
}

@end