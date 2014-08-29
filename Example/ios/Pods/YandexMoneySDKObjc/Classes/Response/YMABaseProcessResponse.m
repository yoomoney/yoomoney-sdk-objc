//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABaseProcessResponse.h"
#import "YMAConstants.h"

static NSString *const kKeyResponseStatusRefused = @"refused";
static NSString *const kKeyResponseStatusInProgress = @"in_progress";
static NSString *const kKeyResponseStatusExtAuthRequired = @"ext_auth_required";
static NSString *const kKeyResponseStatusHoldForPickup = @"hold_for_pickup";
static NSString *const kKeyResponseStatusSuccess = @"success";

static NSString *const kParameterStatus = @"status";
static NSString *const kParameterError = @"error";
static NSString *const kParameterNextRetry = @"next_retry";
static NSString *const kParameterAccountUnblockUri = @"account_unblock_uri";

@implementation YMABaseProcessResponse

#pragma mark - Object Lifecycle

- (id)init
{
    self = [super init];

    if (self != nil) {
        _nextRetry = 0;
    }

    return self;
}

#pragma mark - Overridden methods

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error
{
    NSString *statusKey = responseModel[kParameterStatus];
    NSString *accountUnblockUri = responseModel[kParameterAccountUnblockUri];
    _accountUnblockUri = [accountUnblockUri copy];

    if ([statusKey isEqual:kKeyResponseStatusRefused]) {
        NSString *errorKey = responseModel[kParameterError];
        _status = YMAResponseStatusRefused;

        if (!error) return NO;

        NSError *unknownError = [NSError errorWithDomain:YMAErrorDomainUnknown code:0 userInfo:@{ YMAErrorKeyResponse : self }];
        *error = errorKey ? [NSError errorWithDomain:YMAErrorDomainYaMoneyAPI code:0 userInfo:@{ YMAErrorKey : errorKey, YMAErrorKeyResponse : self }] : unknownError;

        return NO;
    }

    if ([statusKey isEqual:kKeyResponseStatusInProgress]) {
        NSString *nextRetryString = responseModel[kParameterNextRetry];
        _nextRetry = (NSUInteger)[nextRetryString integerValue];
        _status = YMAResponseStatusInProgress;
    }
    else if ([statusKey isEqual:kKeyResponseStatusHoldForPickup])
        _status = YMAResponseStatusHoldForPickup;
    else if ([statusKey isEqual:kKeyResponseStatusExtAuthRequired])
        _status = YMAResponseStatusExtAuthRequired;
    else if ([statusKey isEqual:kKeyResponseStatusSuccess])
        _status = YMAResponseStatusSuccess;
    else
        _status = YMAResponseStatusUnknown;

    return YES;
}

@end
