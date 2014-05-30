//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAvatarModel.h"


@implementation YMAAvatarModel

- (id)initWithUrl:(NSURL *)url timeStamp:(NSDate *)timeStamp {
    self = [super init];

    if (self) {
        _url = url;
        _timeStamp = timeStamp;
    }

    return self;
}

+ (instancetype)avatarWithUrl:(NSURL *)url timeStamp:(NSDate *)timeStamp {
    return [[YMAAvatarModel alloc] initWithUrl:url timeStamp:timeStamp];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"url" : self.url,
                                              @"timeStamp" : self.timeStamp
                                      }];
}

@end