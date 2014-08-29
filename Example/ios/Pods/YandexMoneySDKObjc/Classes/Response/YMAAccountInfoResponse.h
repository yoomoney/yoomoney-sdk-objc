//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"
#import "YMAAccountInfoModel.h"

@interface YMAAccountInfoResponse : YMABaseResponse

@property (nonatomic, strong, readonly) YMAAccountInfoModel *accountInfo;

@end