//
// Created by Александр Залуцкий on 18.01.2021.
// Copyright (c) 2021 YooMoney. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YMALogger <NSObject>

- (void)logMessage:(NSString *)message;

@end