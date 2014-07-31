//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAscModel.h"


@implementation YMAAscModel

#pragma mark - Object Lifecycle

- (id)initWithUrl:(NSURL *)url andParams:(NSDictionary *)params
{
    self = [super init];

    if (self != nil) {
        _url = url;
        _params = params;
    }

    return self;
}

+ (instancetype)ascWithUrl:(NSURL *)url andParams:(NSDictionary *)params
{
    return [[YMAAscModel alloc] initWithUrl:url andParams:params];
}

@end