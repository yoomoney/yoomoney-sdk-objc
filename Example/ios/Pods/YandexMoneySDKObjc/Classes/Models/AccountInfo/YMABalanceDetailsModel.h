//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMABalanceDetailsModel : NSObject

+ (instancetype)balanceDetailsWithTotal:(NSString *)total
                              available:(NSString *)available
                      depositionPending:(NSString *)depositionPending
                                blocked:(NSString *)blocked
                                   debt:(NSString *)debt;

@property (nonatomic, copy, readonly) NSString *total;
@property (nonatomic, copy, readonly) NSString *available;
@property (nonatomic, copy, readonly) NSString *depositionPending;
@property (nonatomic, copy, readonly) NSString *blocked;
@property (nonatomic, copy, readonly) NSString *debt;

@end