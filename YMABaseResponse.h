//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMABaseResponse;

typedef void (^YMAResponseHandler)(YMABaseResponse *response, NSError *error);

@interface YMABaseResponse : NSOperation

/// Constructor. Returns a YMABasePaymentProcessResponse with the specified data and completion of block.
/// @param data -
/// @param block -
- (id)initWithData:(NSData *)data andCompletion:(YMAResponseHandler)block;

@end