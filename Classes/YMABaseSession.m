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

static NSString *const kValueUserAgentDefault = @"Yandex.Money.SDK/iOS";

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
    YMAConnection *connection = [[YMAConnection alloc] initWithUrl:url];
    connection.requestMethod = kMethodPost;
    [connection addValue:kValueContentTypeDefault forHeader:kHeaderContentType];
    [connection addValue:kValueUserAgentDefault forHeader:kHeaderUserAgent];

    if (token)
        [connection addValue:[NSString stringWithFormat:kValueHeaderAuthorizationFormat, token] forHeader:kHeaderAuthorization];

    [connection addPostParams:parameters];

    [connection sendAsynchronousWithQueue:_requestQueue completionHandler:handler];
}

- (void)performAndProcessRequestWithToken:(NSString *)token parameters:(NSDictionary *)parameters url:(NSURL *)url andCompletionHandler:(YMAConnectionHandler)handler {
    [self performRequestWithToken:token parameters:parameters url:url andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        if (error) {
            handler(urlRequest, urlResponse, responseData, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) urlResponse).statusCode;
        NSError *technicalError = [NSError errorWithDomain:kErrorKeyUnknown code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}];

        switch (statusCode) {
            case YMAStatusCodeOkHTTP:
                handler(urlRequest, urlResponse, responseData, nil);
                break;
            case YMAStatusCodeInsufficientScopeHTTP:
            case YMAStatusCodeInvalidTokenHTTP:
                handler(urlRequest, urlResponse, responseData, [NSError errorWithDomain:[self valueOfHeader:kHeaderWWWAuthenticate forResponse:urlResponse] code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}]);
                break;
            default:
                handler(urlRequest, urlResponse, responseData, technicalError);
                break;
        }
    }];
}

- (NSString *)valueOfHeader:(NSString *)headerName forResponse:(NSURLResponse *)response {
    NSDictionary *headers = [((NSHTTPURLResponse *) response) allHeaderFields];

    for (NSString *header in headers.allKeys) {
        if ([header caseInsensitiveCompare:headerName] == NSOrderedSame)
            return [headers objectForKey:header];
    }

    return nil;
}

@end