//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAChangeAvatarResponse.h"
#import "YMAConstants.h"

@implementation YMAChangeAvatarResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    [super parseJSONModel:responseModel error:error];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"status" : [NSNumber numberWithInteger:self.status]
                                      }];
}

@end