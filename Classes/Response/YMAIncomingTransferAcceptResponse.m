//
// Created by Alexander Mertvetsov on 27.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAIncomingTransferAcceptResponse.h"

static NSString *const kParameterProtectionCodeAttemptsAvailable = @"protection_code_attempts_available";
static NSString *const kParameterExtActionUri = @"ext_action_uri";

@implementation YMAIncomingTransferAcceptResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    [super parseJSONModel:responseModel error:error];

    _protectionCodeAttemptsAvailable = [[responseModel objectForKey:kParameterProtectionCodeAttemptsAvailable] integerValue];
    NSString *extActionUriString = [responseModel objectForKey:kParameterExtActionUri];
    _extActionUri = [NSURL URLWithString:extActionUriString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"protectionCodeAttemptsAvailable" : [NSNumber numberWithInteger:self.protectionCodeAttemptsAvailable],
                                              @"extActionUri" : self.extActionUri
                                      }];
}

@end