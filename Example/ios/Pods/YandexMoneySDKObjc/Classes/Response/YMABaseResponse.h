//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Values for YMAResponseStatus
/// Status of process payment
typedef NS_ENUM(NSInteger, YMAResponseStatus) {
    YMAResponseStatusUnknown,

    /// Payment processing completed successfully
        YMAResponseStatusSuccess,
    /// The refusal of the payment.
    /// The reason of failure is returned in the error.
    /// This is the end state of the payment.
        YMAResponseStatusRefused,
    /// Payment processing is not yet complete.
    /// The application should retry the request with the same parameters
    /// later time specified in the nextRetry property.
        YMAResponseStatusInProgress,
    /// To complete the processing of payment requires additional authorization
    /// (you should open the WebView and send the client to uri + params specified in YMAAscModel)
        YMAResponseStatusExtAuthRequired,

        YMAResponseStatusHoldForPickup
};

@class YMABaseResponse;

typedef void (^YMAResponseHandler)(YMABaseResponse *response, NSError *error);

///
/// Abstract class of response. This class contains common info about the response (status, nextRetry).
///
@interface YMABaseResponse : NSOperation

/// Constructor. Returns a YMABaseResponse with the specified data and completion of block.
/// @param data -
/// @param headers -
/// @param block -
- (id)initWithData:(NSData *)data headers:(NSDictionary *)headers andCompletion:(YMAResponseHandler)block;

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error;

@end