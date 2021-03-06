//
// Created by Alexander Mertvetsov on 27.05.14.
// Copyright (c) 2020 YooMoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"
#import "YMABaseProcessResponse.h"

@interface YMAIncomingTransferRejectRequest : YMABaseRequest<YMAParametersPosting>

+ (instancetype)rejectIncomingTransferWithOperationId:(NSString *)operationId;

@end
