//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAChangeAvatarRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlAvatar = @"api/avatar-set";
static NSString *const kContentType = @"image/png";

@implementation YMAChangeAvatarRequest

@synthesize data = _data;
@synthesize contentType = _contentType;

#pragma mark - Object Lifecycle

- (id)initWithImageData:(NSData *)imageData
{
    self = [super init];

    if (self != nil) {
        _data = imageData;
        _contentType = kContentType;
    }

    return self;
}

+ (instancetype)changeAvatarWithImageData:(NSData *)imageData
{
    return [[YMAChangeAvatarRequest alloc] initWithImageData:imageData];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString =
        [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlAvatar];
    return [NSURL URLWithString:urlString];
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler
{
    return [[YMABaseProcessResponse alloc] initWithData:data andCompletion:handler];
}

@end