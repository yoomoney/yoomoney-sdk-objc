//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2020 YooMoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"
#import "YMAAccountInfoResponse.h"

@interface YMAAccountInfoRequest : YMABaseRequest<YMAParametersPosting>

+ (instancetype)accountInfoRequest;

@end
