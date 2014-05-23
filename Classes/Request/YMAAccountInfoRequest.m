//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAccountInfoRequest.h"
#import "YMAHostsProvider.h"
#import "YMAAccountInfoResponse.h"

static NSString *const kUrlAccountInfo = @"api/account-info";

@implementation YMAAccountInfoRequest

@synthesize parameters;

+ (instancetype)accountInfoRequest {
    return [[YMAAccountInfoRequest alloc] init];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlAccountInfo];
    return [NSURL URLWithString:urlString];
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAAccountInfoResponse alloc] initWithData:data andCompletion:handler];
}

@end