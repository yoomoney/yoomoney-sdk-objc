//
//  YMABasePaymentProcessResponse.m
//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABasePaymentProcessResponse.h"
#import "YMAConstants.h"

static NSString *const kResponseStatusKeyRefused = @"refused";
static NSString *const kResponseStatusKeyInProgress = @"in_progress";
static NSString *const kResponseStatusKeyExtAuthRequired = @"ext_auth_required";
static NSString *const kResponseStatusHoldForPickup = @"hold_for_pickup";
static NSString *const kResponseStatusSuccess = @"success";
static NSString *const kParameterStatus = @"status";
static NSString *const kParameterError = @"error";
static NSString *const kParameterNextRetry = @"next_retry";

@implementation YMABasePaymentProcessResponse

- (id)init {
    self = [super init];

    if (self) {
        _nextRetry = 0;
    }

    return self;
}

#pragma mark -
#pragma mark *** NSOperation ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    NSString *statusKey = [responseModel objectForKey:kParameterStatus];

    if ([statusKey isEqual:kResponseStatusKeyRefused]) {
        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];

        NSString *errorKey = [responseModel objectForKey:kParameterError];
        _status = YMAResponseStatusRefused;

        _handler(self, errorKey ? [NSError errorWithDomain:errorKey code:0 userInfo:@{@"response" : self}] : unknownError);
        return;
    }

    if ([statusKey isEqual:kResponseStatusKeyInProgress]) {
        NSString *nextRetryString = [responseModel objectForKey:kParameterNextRetry];
        _nextRetry = (NSUInteger) [nextRetryString integerValue];
        _status = YMAResponseStatusInProgress;
    } else if ([statusKey isEqual:kResponseStatusHoldForPickup])
        _status = YMAResponseStatusHoldForPickup;
    else if ([statusKey isEqual:kResponseStatusKeyExtAuthRequired])
        _status = YMAResponseStatusExtAuthRequired;
    else if ([statusKey isEqual:kResponseStatusSuccess])
        _status = YMAResponseStatusSuccess;
    else
        _status = YMAResponseStatusUnknown;
}

@end
