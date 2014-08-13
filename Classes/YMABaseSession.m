//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseSession.h"

static NSString *const kValueHeaderAuthorizationFormat = @"Bearer %@";
static NSString *const kHeaderAuthorization = @"Authorization";
static NSString *const kHeaderWWWAuthenticate = @"WWW-Authenticate";
static NSString *const kValueContentTypeImage = @"image/png";
static NSString *const kHeaderAcceptEncoding = @"Accept-Encoding";
static NSString *const kValueAcceptEncoding = @"gzip";
static NSString *const kHeaderAcceptLanguage = @"Accept-Language";
static NSString *const kValueAcceptLanguageDefault = @"ru";
static NSString *const kValueContentTypePNG = @"image/png";

NSString *const YMAValueUserAgentDefault = @"Yandex.Money.SDK/iOS";
NSString *const YMAHeaderUserAgent = @"User-Agent";
NSString *const YMAMethodPost = @"POST";
NSString *const YMAValueContentTypeDefault = @"application/x-www-form-urlencoded;charset=UTF-8";

@interface YMABaseSession ()

@property (nonatomic, strong) NSDictionary *defaultHeaders;

@end

@implementation YMABaseSession

#pragma mark - Object Lifecycle

- (id)init
{
    self = [super init];

    if (self != nil) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _responseQueue = [[NSOperationQueue alloc] init];
        _userAgent = YMAValueUserAgentDefault;
        _language = kValueAcceptLanguageDefault;
    }

    return self;
}

- (id)initWithUserAgent:(NSString *)userAgent
{
    self = [self init];

    if (self != nil) {
        _userAgent = [userAgent copy];
    }

    return self;
}

#pragma mark - Public methods

- (void)performRequestWithToken:(NSString *)token
                     parameters:(NSDictionary *)parameters
                  customHeaders:(NSDictionary *)customHeaders
                            url:(NSURL *)url
                     completion:(YMAConnectionHandler)block
{
    YMAConnection *connection = [self connectionWithUrl:url customHeaders:customHeaders andToken:token];
    [connection addPostParams:parameters];

    [connection sendAsynchronousWithQueue:_requestQueue completionHandler:block];
}

- (void)performAndProcessRequestWithToken:(NSString *)token
                               parameters:(NSDictionary *)parameters
                            customHeaders:(NSDictionary *)customHeaders
                                      url:(NSURL *)url
                               completion:(YMAConnectionHandler)block
{
    [self performRequestWithToken:token
                       parameters:parameters
                    customHeaders:customHeaders
                              url:url
                       completion:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
                           [self processRequest:urlRequest
                                       response:urlResponse
                                   responseData:responseData
                                          error:error
                                     completion:block];
                       }];
}

- (void)performAndProcessRequestWithToken:(NSString *)token
                                     data:(NSData *)data
                            customHeaders:(NSDictionary *)customHeaders
                                      url:(NSURL *)url
                               completion:(YMAConnectionHandler)block
{
    [self performRequestWithToken:token
                             data:data
                    customHeaders:customHeaders
                              url:url
             andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
                 [self processRequest:urlRequest
                             response:urlResponse
                         responseData:responseData
                                error:error
                           completion:block];
             }];
}

#pragma mark - Private methods

- (void)performRequestWithToken:(NSString *)token
                           data:(NSData *)data
                  customHeaders:(NSDictionary *)customHeaders
                            url:(NSURL *)url
           andCompletionHandler:(YMAConnectionHandler)handler
{
    YMAConnection *connection = [self connectionWithUrl:url customHeaders:customHeaders andToken:token];
    [connection addBodyData:data];

    [connection sendAsynchronousWithQueue:_requestQueue completionHandler:handler];
}

- (void)processRequest:(NSURLRequest *)urlRequest
              response:(NSURLResponse *)urlResponse
          responseData:(NSData *)responseData
                 error:(NSError *)error
            completion:(YMAConnectionHandler)block
{
    if (error != nil) {
        block(urlRequest, urlResponse, responseData, error);
        return;
    }

    NSLog(@"--------------------- Response data: %@",
          [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

    NSInteger statusCode = ((NSHTTPURLResponse *)urlResponse).statusCode;


    switch (statusCode) {
        case YMAStatusCodeOkHTTP:
            block(urlRequest, urlResponse, responseData, nil);
            break;
        case YMAStatusCodeInsufficientScopeHTTP:
        case YMAStatusCodeInvalidTokenHTTP: {
            NSError *oAuthError = [NSError errorWithDomain:YMAErrorDomainOAuth
                                                      code:statusCode
                                                  userInfo:@{ YMAErrorKeyRequest : urlRequest, YMAErrorKeyResponse : urlResponse }];

            block(urlRequest, urlResponse, responseData, oAuthError);
        }
            break;
        default: {
            NSError *technicalError = [NSError errorWithDomain:YMAErrorDomainUnknown
                                                          code:statusCode
                                                      userInfo:@{ YMAErrorKeyRequest : urlRequest, YMAErrorKeyResponse : urlResponse }];

            block(urlRequest, urlResponse, responseData, technicalError);
        }
            break;
    }
}

- (YMAConnection *)connectionWithUrl:(NSURL *)url customHeaders:(NSDictionary *)customHeaders andToken:(NSString *)token
{
    NSMutableDictionary *headers = [self.defaultHeaders mutableCopy];

    headers[YMAHeaderUserAgent] = _userAgent;
    headers[kHeaderAcceptLanguage] = self.language;

    if (token)
        headers[kHeaderAuthorization] = [NSString stringWithFormat:kValueHeaderAuthorizationFormat, token];

    for (NSString *key in customHeaders.allKeys) {
        headers[key] = customHeaders[key];
    }

    YMAConnection *connection = [[YMAConnection alloc] initWithUrl:url];
    connection.requestMethod = YMAMethodPost;

    for (NSString *key in headers.allKeys) {
        [connection addValue:headers[key] forHeader:key];
    }

    return connection;
}

- (NSString *)valueOfHeader:(NSString *)headerName forResponse:(NSURLResponse *)response
{
    NSDictionary *headers = [((NSHTTPURLResponse *)response) allHeaderFields];

    for (NSString *header in headers.allKeys) {
        if ([header caseInsensitiveCompare:headerName] == NSOrderedSame)
            return headers[header];
    }

    return nil;
}

#pragma mark - Getters and setters

- (NSDictionary *)defaultHeaders
{
    if (_defaultHeaders == nil) {
        _defaultHeaders =
            @{ YMAHeaderContentType : YMAValueContentTypeDefault, kHeaderAcceptEncoding : kValueAcceptEncoding };
    }

    return _defaultHeaders;
}

@end