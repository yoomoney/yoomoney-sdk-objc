//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySource.h"


@implementation YMAMoneySource

- (id)initWithSourceType:(YMAMoneySourceType)type allowed:(BOOL)allowed {
    self = [super init];

    if (self) {
        _type = type;
        _isAllowed = allowed;
    }

    return self;
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"type" : [NSNumber numberWithInt:self.type],
                                              @"isAllowed" : (self.isAllowed) ? @"YES" : @"NO"
                                      }];
}

@end