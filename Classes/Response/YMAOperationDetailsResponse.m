//
// Created by mertvetcov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAOperationDetailsResponse.h"
#import "YMAOperationDetails.h"
#import "YMAConstants.h"
#import "YMAHistoryOperationsResponse.h"

static NSString *const kParameterError = @"error";

@implementation YMAOperationDetailsResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    NSString *errorKey = [responseModel objectForKey:kParameterError];

    if (errorKey) {
        if (!error) return;

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];
        *error = errorKey ? [NSError errorWithDomain:errorKey code:0 userInfo:@{@"response" : self}] : unknownError;

        return;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];

    _operationDetails = [YMAHistoryOperationsResponse historyOperationByModel:responseModel];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"operationDetails" : self.operationDetails.description
                                      }];
}

@end