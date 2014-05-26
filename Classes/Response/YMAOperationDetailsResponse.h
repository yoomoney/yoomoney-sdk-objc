//
// Created by mertvetcov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

@class YMAOperationDetails;


@interface YMAOperationDetailsResponse : YMABaseResponse

@property(nonatomic, strong, readonly) YMAOperationDetails *operationDetails;

@end