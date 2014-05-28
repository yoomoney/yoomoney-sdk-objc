//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

@interface YMAChangeAvatarResponse : YMABaseResponse

/// Response status.
@property(nonatomic, assign, readonly) YMAResponseStatus status;

@end