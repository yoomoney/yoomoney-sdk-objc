//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAWalletSourceGroup.h"

@implementation YMAWalletSourceGroup

- (id)initWithAllowed:(BOOL)allowed {
    self = [super init];

    if (self) {
        _isAllowed = allowed;
    }

    return self;
}

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed {
    return [[YMAWalletSourceGroup alloc] initWithAllowed:allowed];
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