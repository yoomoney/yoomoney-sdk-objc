//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABalanceDetailsModel.h"


@implementation YMABalanceDetailsModel

- (id)initWithTotal:(NSString *)total available:(NSString *)available depositionPending:(NSString *)depositionPending blocked:(NSString *)blocked debt:(NSString *)debt {
    self = [super init];

    if (self) {
        _total = [total copy];
        _available = [available copy];
        _depositionPending = [depositionPending copy];
        _blocked = [blocked copy];
        _debt = [debt copy];
    }

    return self;
}

+ (instancetype)balanceDetailsWithTotal:(NSString *)total available:(NSString *)available depositionPending:(NSString *)depositionPending blocked:(NSString *)blocked debt:(NSString *)debt {
    return [[YMABalanceDetailsModel alloc] initWithTotal:total available:available depositionPending:depositionPending blocked:blocked debt:debt];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"total" : self.total,
                                              @"available" : self.available,
                                              @"depositionPending" : self.depositionPending,
                                              @"blocked" : self.blocked,
                                              @"debt" : self.debt
                                      }];
}


@end