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

@property (nonatomic, strong) NSMutableArray *activeConnections;

@end

@implementation YMABaseSession

#pragma mark - Object Lifecycle

- (instancetype)init
{
    self = [super init];

    if (self != nil) {
        _requestQueue      = [[NSOperationQueue alloc] init];
        _responseQueue     = [[NSOperationQueue alloc] init];
        _userAgent         = YMAValueUserAgentDefault;
        _language          = kValueAcceptLanguageDefault;
        _activeConnections = [[NSMutableArray alloc] init];
    }

    return self;
}

- (instancetype)initWithUserAgent:(NSString *)userAgent
{
    self = [self init];

    if (self != nil) {
        _userAgent = [userAgent copy];
    }

    return self;
}

#pragma mark - Public methods

- (void)performRequestWithMethod:(YMARequestMethod)requestMethod
                           token:(NSString *)token
                      parameters:(NSDictionary *)parameters
                   customHeaders:(NSDictionary *)customHeaders
                             url:(NSURL *)url
                      completion:(YMAConnectionHandler)block
{
    [self performRequestWithMethod:requestMethod
                             token:token
                        parameters:parameters
                     customHeaders:customHeaders
                               url:url
                   redirectHandler:NULL
                        completion:block];
}

- (void)performRequestWithMethod:(YMARequestMethod)requestMethod
                           token:(NSString *)token
                      parameters:(NSDictionary *)parameters
                   customHeaders:(NSDictionary *)customHeaders
                             url:(NSURL *)url
                 redirectHandler:(YMAConnectionRedirectHandler)redirectHandler
                      completion:(YMAConnectionHandler)block
{
    YMAConnection *connection = (requestMethod == YMARequestMethodGet) ?
    [YMAConnection connectionForGetRequestWithUrl:url parameters:parameters] :
    [YMAConnection connectionForPostRequestWithUrl:url postParameters:parameters];

    [self sendAsynchronousConnection:connection
                               token:token
                       customHeaders:customHeaders
                     redirectHandler:redirectHandler
                          completion:block];
}

- (void)performAndProcessRequestWithMethod:(YMARequestMethod)requestMethod
                                     token:(NSString *)token
                                parameters:(NSDictionary *)parameters
                             customHeaders:(NSDictionary *)customHeaders
                                       url:(NSURL *)url
                                completion:(YMAConnectionHandler)block
{
    [self performAndProcessRequestWithMethod:requestMethod
                                       token:token
                                  parameters:parameters
                               customHeaders:customHeaders
                                         url:url
                             redirectHandler:NULL
                                  completion:block];
}

- (void)performAndProcessRequestWithMethod:(YMARequestMethod)requestMethod
                                     token:(NSString *)token
                                parameters:(NSDictionary *)parameters
                             customHeaders:(NSDictionary *)customHeaders
                                       url:(NSURL *)url
                            redirectHandler:(YMAConnectionRedirectHandler)redirectHandler
                                completion:(YMAConnectionHandler)block
{
    [self performRequestWithMethod:requestMethod token:token
                        parameters:parameters
                     customHeaders:customHeaders
                               url:url
                   redirectHandler:redirectHandler
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
                       completion:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
                           [self processRequest:urlRequest
                                       response:urlResponse
                                   responseData:responseData
                                          error:error
                                     completion:block];
                       }];
}

- (void)cancelActiveConnections
{
    [self.activeConnections makeObjectsPerformSelector:@selector(cancel)];
    [self.activeConnections removeAllObjects];
}


#pragma mark - Private methods

- (void)sendAsynchronousConnection:(YMAConnection *)connection
                             token:(NSString *)token
                     customHeaders:(NSDictionary *)customHeaders
                   redirectHandler:(YMAConnectionRedirectHandler)redirectHandler
                        completion:(YMAConnectionHandler)block
{
    BOOL result = [self addHeaders:customHeaders token:token forConnection:&connection];
    if (result) {
        __weak __typeof(self) weakSelf       = self;
        __weak YMAConnection *weakConnection = connection;
        [connection sendAsynchronousWithQueue:self.requestQueue
                              redirectHandler:redirectHandler
                                   completion:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
                                       if (block != NULL) {
                                           block(request, response, responseData, error);
                                       }
                                       [weakSelf.activeConnections removeObject:weakConnection];
                                   }];
        [self.activeConnections addObject:connection];
    }
    else if (block != NULL) {
        NSError *technicalError = [NSError errorWithDomain:YMAErrorDomainUnknown
                                                      code:0
                                                  userInfo:nil];
        block(nil, nil, nil, technicalError);
    }
}

- (void)performRequestWithToken:(NSString *)token
                           data:(NSData *)data
                  customHeaders:(NSDictionary *)customHeaders
                            url:(NSURL *)url
                     completion:(YMAConnectionHandler)block
{
    YMAConnection *connection = [YMAConnection connectionForPostRequestWithUrl:url bodyData:data];
    [self sendAsynchronousConnection:connection
                               token:token
                       customHeaders:customHeaders
                     redirectHandler:NULL
                          completion:block];
}

- (void)processRequest:(NSURLRequest *)urlRequest
              response:(NSURLResponse *)urlResponse
          responseData:(NSData *)responseData
                 error:(NSError *)error
            completion:(YMAConnectionHandler)block
{
    NSInteger statusCode = ((NSHTTPURLResponse *)urlResponse).statusCode;
    
#if defined(DEBUG) || defined(ADHOC)
    NSMutableString *debugString = [NSMutableString stringWithFormat:@"Response URL: %@\nStatus code:%ld\nData: %@",
                                    urlRequest.URL.absoluteString,
                                    (long)statusCode,
                                    [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];
    
    if (error != nil) {
        [debugString appendFormat:@"\nError:%@", error.localizedDescription];
    }
    NSLog(@"%@", debugString);
#endif
    
    NSError *responseError = nil;
    if (error != nil) {
        responseError = error;
    }
    else {
        switch (statusCode) {
            case YMAStatusCodeOkHTTP:
            case YMAStatusCodeMultipleChoicesHTTP:
            case YMAStatusCodeMovedPermanentlyHTTP:
            case YMAStatusCodeNotModifiedHTTP:
                responseError = nil;
                break;
                
            case YMAStatusCodeInsufficientScopeHTTP:
            case YMAStatusCodeInvalidTokenHTTP: {
                responseError = [NSError errorWithDomain:YMAErrorDomainOAuth
                                                    code:statusCode
                                                userInfo:@{ YMAErrorKeyRequest : urlRequest, YMAErrorKeyResponse : urlResponse }];
                
            }
                break;
                
            default: {
                responseError = [NSError errorWithDomain:YMAErrorDomainUnknown
                                                    code:statusCode
                                                userInfo:@{ YMAErrorKeyRequest : urlRequest, YMAErrorKeyResponse : urlResponse }];
                
            }
                break;
        }
    }

    if (block != NULL) {
        block(urlRequest, urlResponse, responseData, responseError);
    }
}

- (BOOL)addHeaders:(NSDictionary *)customHeaders token:(NSString *)token forConnection:(YMAConnection * __autoreleasing *)connection {
    if (connection == nil || *connection == nil)
        return NO;
    
    NSMutableDictionary *headers = [self.defaultHeaders mutableCopy];

    if (_userAgent != nil) {
        headers[YMAHeaderUserAgent] = _userAgent;
    }
    if (self.language != nil) {
        headers[kHeaderAcceptLanguage] = self.language;
    }

    if (token != nil) {
        headers[kHeaderAuthorization] = [NSString stringWithFormat:kValueHeaderAuthorizationFormat, token];
    }
    
    for (NSString *key in customHeaders.allKeys) {
        headers[key] = customHeaders[key];
    }
    
    for (NSString *key in headers.allKeys) {
        [*connection addValue:headers[key] forHeader:key];
    }
    
    return YES;
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