//
// Created by mertvetcov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"


@interface YMAOperationDetailsRequest : YMABaseRequest <YMAParametersPosting>

+ (instancetype)operationDetailsWithRepeatInfoByOperationId:(NSString *)operationId;

+ (instancetype)operationDetailsWithOperationId:(NSString *)operationId;

+ (instancetype)operationDetailsWithFavouriteId:(NSString *)favouriteId;

@end