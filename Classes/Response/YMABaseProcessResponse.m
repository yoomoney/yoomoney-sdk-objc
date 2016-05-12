//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABaseProcessResponse.h"
#import "YMAConstants.h"

static NSString *const kKeyResponseStatusRefused         = @"refused";
static NSString *const kKeyResponseStatusInProgress      = @"in_progress";
static NSString *const kKeyResponseStatusExtAuthRequired = @"ext_auth_required";
static NSString *const kKeyResponseStatusHoldForPickup   = @"hold_for_pickup";
static NSString *const kKeyResponseStatusSuccess         = @"success";

static NSString *const kParameterStatus            = @"status";
static NSString *const kParameterError             = @"error";
static NSString *const kParameterNextRetry         = @"next_retry";
static NSString *const kParameterAccountUnblockUri = @"account_unblock_uri";

@implementation YMABaseProcessResponse


#pragma mark - Object Lifecycle

- (instancetype)init
{
    self = [super init];

    if (self != nil) {
        _nextRetry = 0;
        _status = YMAResponseStatusUnknown;
    }

    return self;
}


#pragma mark - Overridden methods

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error
{
    if ([responseModel isKindOfClass:[NSDictionary class]]) {
        NSString *statusKey = responseModel[kParameterStatus];
        _status = [self statusFromString:statusKey];
        NSString *accountUnblockUri = responseModel[kParameterAccountUnblockUri];
        _accountUnblockUri = [accountUnblockUri copy];

        if (_status == YMAResponseStatusInProgress) {
            NSString *nextRetryString = responseModel[kParameterNextRetry];
            _nextRetry = (NSUInteger)[nextRetryString integerValue];
        }
        else if (_status == YMAResponseStatusRefused) {
            NSString *errorKey = responseModel[kParameterError];

            if (error != NULL) {
                if (errorKey != nil) {
                    *error = [NSError errorWithDomain:YMAErrorDomainYaMoneyAPI
                                                 code:0
                                             userInfo:@{YMAErrorKey : errorKey, YMAErrorKeyResponse : self}];
                }
                else  {
                    *error = [NSError errorWithDomain:YMAErrorDomainUnknown
                                                 code:0
                                             userInfo:@{YMAErrorKeyResponse : self}];
                }
            }
        }
    }

    return YES;
}


#pragma mark - Public methods

- (YMAResponseStatus)statusFromString:(NSString *)statusString
{
    YMAResponseStatus status = YMAResponseStatusUnknown;

    if ([statusString isEqualToString:kKeyResponseStatusSuccess]) {
        status = YMAResponseStatusSuccess;
    }
    else if ([statusString isEqualToString:kKeyResponseStatusInProgress]) {
        status = YMAResponseStatusInProgress;
    }
    else if ([statusString isEqualToString:kKeyResponseStatusRefused]) {
        status = YMAResponseStatusRefused;
    }
    else if ([statusString isEqualToString:kKeyResponseStatusExtAuthRequired]) {
        status = YMAResponseStatusExtAuthRequired;
    }
    else if ([statusString isEqualToString:kKeyResponseStatusHoldForPickup]) {
        status = YMAResponseStatusHoldForPickup;
    }

    return status;
}

@end
