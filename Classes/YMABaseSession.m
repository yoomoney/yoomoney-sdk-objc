//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseSession.h"

NSString* const kValueHeaderAuthorizationFormat = @"Bearer %@";
NSString* const kHeaderAuthorization = @"Authorization";
NSString *const kHeaderWWWAuthenticate = @"WWW-Authenticate";
NSString *const kHeaderContentType = @"Content-Type";
NSString *const kHeaderUserAgent = @"User-Agent";
NSString *const kMethodPost = @"POST";
NSString *const kValueContentTypeDefault = @"application/x-www-form-urlencoded;charset=UTF-8";

@implementation YMABaseSession

- (id)init {
    self = [super init];

    if (self) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _responseQueue = [[NSOperationQueue alloc] init];
    }

    return self;
}

- (void)performRequestWithToken:(NSString *)token parameters:(NSDictionary *)parameters url:(NSURL *)url andCompletionHandler:(YMAConnectionHandler)handler {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end