//
// Created by mertvetcov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

@class YMAAccountInfo;

@interface YMAAccountInfoResponse : YMABaseResponse

@property(nonatomic, strong, readonly) YMAAccountInfo *accountInfo;

@end