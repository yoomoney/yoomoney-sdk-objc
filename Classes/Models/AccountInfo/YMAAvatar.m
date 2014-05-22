//
// Created by mertvetcov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAvatar.h"


@implementation YMAAvatar

- (id)initWithUrl:(NSURL *)url timeStamp:(NSDate *)timeStamp {
    self = [super init];

    if (self) {
        _url = url;
        _timeStamp = timeStamp;
    }

    return self;
}

+ (instancetype)avatarWithUrl:(NSURL *)url timeStamp:(NSDate *)timeStamp {
    return [[YMAAvatar alloc] initWithUrl:url timeStamp:timeStamp];
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