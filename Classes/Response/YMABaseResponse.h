//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMABaseResponse;

typedef void (^YMAResponseHandler)(YMABaseResponse *response, NSError *error);

///
/// Abstract class of response. This class contains common info about the response (status, nextRetry).
///
@interface YMABaseResponse : NSOperation {
@protected
    YMAResponseHandler _handler;
}

/// Constructor. Returns a YMABasePaymentProcessResponse with the specified data and completion of block.
/// @param data -
/// @param block -
- (id)initWithData:(NSData *)data andCompletion:(YMAResponseHandler)block;

- (void)parseJSONModel:(id)responseModel;

@end