//
//  YMABasePaymentProcessResponse.h
//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseResponse.h"

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
    /// (you should open the WebView and send the client to uri + params specified in YMAAsc)
            YMAResponseStatusExtAuthRequired,

            YMAResponseStatusHoldForPickup
};

///
/// Abstract class of response. This class contains common info about the response (status, nextRetry).
///
@interface YMABasePaymentProcessResponse : YMABaseResponse

/// Status of process payment.
@property(nonatomic, assign, readonly) YMAResponseStatus status;
/// Recommended time later that you should repeat the request in milliseconds.
/// The property is not equal to zero for status = YMAResponseStatusInProgress.
@property(nonatomic, assign, readonly) NSUInteger nextRetry;

- (void)parseJSONModel:(id)responseModel;

@end
