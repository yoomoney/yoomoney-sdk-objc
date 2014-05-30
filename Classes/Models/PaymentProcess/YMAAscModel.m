//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAscModel.h"


@implementation YMAAscModel

- (id)initWithUrl:(NSURL *)url andParams:(NSDictionary *)params {
    self = [super init];

    if (self) {
        _url = url;
        _params = params;
    }

    return self;
}

+ (instancetype)ascWithUrl:(NSURL *)url andParams:(NSDictionary *)params {
    return [[YMAAscModel alloc] initWithUrl:url andParams:params];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"url" : self.url,
                                              @"params" : self.params
                                      }];
}

@end