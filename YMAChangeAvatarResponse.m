//
// Created by Александр Мертвецов on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAChangeAvatarResponse.h"
#import "YMAConstants.h"

static NSString *const kParameterStatus = @"status";
static NSString *const kParameterError = @"error";
static NSString *const kKeyResponseStatusSuccess = @"success";

@implementation YMAChangeAvatarResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    NSString *statusKey = [responseModel objectForKey:kParameterStatus];

    if ([statusKey isEqual:kKeyResponseStatusSuccess]) {
        _status = YMAResponseStatusSuccess;
        return;
    }

    _status = YMAResponseStatusRefused;

    if (!error) return;

    NSString *errorKey = [responseModel objectForKey:kParameterError];
    NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];
    *error = errorKey ? [NSError errorWithDomain:errorKey code:0 userInfo:@{@"response" : self}] : unknownError;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"status" : [NSNumber numberWithInteger:self.status]
                                      }];
}

@end