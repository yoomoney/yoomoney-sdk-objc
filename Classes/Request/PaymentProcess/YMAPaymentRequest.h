//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2020 YooMoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"
#import "YMAPaymentResponse.h"

@interface YMAPaymentRequest : YMABaseRequest<YMAParametersPosting>

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)paymentWithPatternId:(NSString *)patternId paymentParameters:(NSDictionary *)paymentParams;

NS_ASSUME_NONNULL_END

@end
