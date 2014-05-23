//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"

typedef NS_ENUM(NSUInteger, YMAHistoryOperationFilter) {
    YMAHistoryOperationFilterUnknown = 0,
    YMAHistoryOperationFilterDeposition = 1 << 0,
    YMAHistoryOperationFilterPayment = 1 << 1
};

@interface YMAOperationHistoryRequest : YMABaseRequest <YMAParametersPosting>

+ (instancetype)operationHistoryWithFilter:(YMAHistoryOperationFilter)filter label:(NSString *)label from:(NSDate *)from till:(NSDate *)till startRecord:(NSString *)startRecord records:(NSUInteger)records details:(BOOL)details;

@end