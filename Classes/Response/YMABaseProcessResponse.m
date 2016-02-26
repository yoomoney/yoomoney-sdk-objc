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
    }

    return self;
}


#pragma mark - Overridden methods

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error
{
    _status = [self statusForResponseModel:responseModel];

    if (_status != YMAResponseStatusUnknown) {
        NSString *accountUnblockUri = responseModel[kParameterAccountUnblockUri];
        _accountUnblockUri = [accountUnblockUri copy];
    }
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

    return YES;
}


#pragma mark - Private methods

- (YMAResponseStatus)statusForResponseModel:(id)responseModel
{
    YMAResponseStatus status = YMAResponseStatusUnknown;
    if ([responseModel isKindOfClass:[NSDictionary class]]) {
        NSString *statusKey = responseModel[kParameterStatus];
        if ([statusKey isEqualToString:kKeyResponseStatusInProgress]) {
            status = YMAResponseStatusSuccess;
        }
        else if ([statusKey isEqualToString:kKeyResponseStatusInProgress]) {
            status = YMAResponseStatusRefused;
        }
        else if ([statusKey isEqualToString:kKeyResponseStatusRefused]) {
            status = YMAResponseStatusRefused;
        }
        else if ([statusKey isEqualToString:kKeyResponseStatusExtAuthRequired]) {
            status = YMAResponseStatusExtAuthRequired;
        }
        else if ([statusKey isEqualToString:kKeyResponseStatusHoldForPickup]) {
            status = YMAResponseStatusHoldForPickup;
        }
    }
    return status;
}

@end
