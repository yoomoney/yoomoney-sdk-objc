//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2020 YooMoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"
#import "YMAOperationDetailsResponse.h"

@interface YMAOperationDetailsRequest : YMABaseRequest<YMAParametersPosting>

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)operationDetailsWithRepeatInfoByOperationId:(NSString *)operationId;

+ (instancetype)operationDetailsWithOperationId:(NSString *)operationId;

+ (instancetype)operationDetailsWithFavoriteId:(NSString *)favoriteId;

NS_ASSUME_NONNULL_END

@end
