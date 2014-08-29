//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABalanceDetailsModel.h"

@implementation YMABalanceDetailsModel

#pragma mark - Object Lifecycle

- (id)initWithTotal:(NSString *)total
          available:(NSString *)available
  depositionPending:(NSString *)depositionPending
            blocked:(NSString *)blocked
               debt:(NSString *)debt
{
    self = [super init];

    if (self != nil) {
        _total = [total copy];
        _available = [available copy];
        _depositionPending = [depositionPending copy];
        _blocked = [blocked copy];
        _debt = [debt copy];
    }

    return self;
}

+ (instancetype)balanceDetailsWithTotal:(NSString *)total
                              available:(NSString *)available
                      depositionPending:(NSString *)depositionPending
                                blocked:(NSString *)blocked
                                   debt:(NSString *)debt
{
    return [[YMABalanceDetailsModel alloc] initWithTotal:total
                                               available:available
                                       depositionPending:depositionPending
                                                 blocked:blocked
                                                    debt:debt];
}

@end