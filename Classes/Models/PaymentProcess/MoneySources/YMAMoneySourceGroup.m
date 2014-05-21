//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourceGroup.h"


@implementation YMAMoneySourceGroup

- (id)initWithAllowed:(BOOL)allowed {
    self = [super init];

    if (self) {
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
                                              @"isAllowed" : (self.isAllowed) ? @"YES" : @"NO"
                                      }];
}

@end