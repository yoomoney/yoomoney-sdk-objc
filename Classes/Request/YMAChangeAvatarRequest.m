//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAChangeAvatarRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlAvatar = @"api/avatar-set";

@implementation YMAChangeAvatarRequest

@synthesize data = _data;

- (id)initWithImageData:(NSData *)imageData {
    self = [super init];

    if (self) {
        _data = imageData;
    }

    return self;
}

+ (instancetype)changeAvatarWithImageData:(NSData *)imageData {
    return [[YMAChangeAvatarRequest alloc] initWithImageData:imageData];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlAvatar];
    return [NSURL URLWithString:urlString];
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAChangeAvatarResponse alloc] initWithData:data andCompletion:handler];
}

@end