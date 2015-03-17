//
//  YMAConnection.m
//
//  Created by Alexander Mertvetsov on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAConnection.h"

static NSString *const kRequestMethodPost = @"POST";
static NSString *const kRequestMethodGet = @"GET";

static NSInteger const kRequestTimeoutIntervalDefault = 60;
static NSString *const kHeaderContentLength = @"Content-Length";

@interface YMAConnection () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;


@property (nonatomic, copy) YMAConnectionRedirectHandler redirectHandler;
@property (nonatomic, copy) YMAConnectionHandler completionHandler;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation YMAConnection

#pragma mark - Object Lifecycle

- (instancetype)initWithUrl:(NSURL *)url parameters:(NSDictionary *)params requestMethod:(NSString *)requestMethod
{
    self = [super init];
    
    if (self != nil) {
        NSURL *requestUrl = url;
        NSString *paramString = [YMAConnection bodyStringWithParams:params];
        
        if ([requestMethod isEqualToString:kRequestMethodGet]) {
            NSString *urlWithQuery = [NSString stringWithFormat:@"%@?%@", [url absoluteString], paramString];
            requestUrl = [NSURL URLWithString:urlWithQuery];
        }
        
        _request = [[NSMutableURLRequest alloc] initWithURL:requestUrl
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:kRequestTimeoutIntervalDefault];
        _request.HTTPMethod = requestMethod;
        
        if ([requestMethod isEqualToString:kRequestMethodPost])
            _request.HTTPBody = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return self;
}

- (instancetype)initWithUrl:(NSURL *)url bodyData:(NSData *)bodyData
{
    self = [super init];
    
    if (self != nil) {
        NSURL *requestUrl = url;
        _request = [[NSMutableURLRequest alloc] initWithURL:requestUrl
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:kRequestTimeoutIntervalDefault];
        _request.HTTPMethod = kRequestMethodPost;
        _request.HTTPBody = bodyData;
    }
    
    return self;
}

+ (instancetype)connectionForPostRequestWithUrl:(NSURL *)url
                                      postParameters:(NSDictionary *)postParams
{
    return [[YMAConnection alloc] initWithUrl:url parameters:postParams requestMethod:kRequestMethodPost];
}

+ (instancetype)connectionForPostRequestWithUrl:(NSURL *)url
                                         bodyData:(NSData *)bodyData
{
    return [[YMAConnection alloc] initWithUrl:url bodyData:bodyData];
}

+ (instancetype)connectionForGetRequestWithUrl:(NSURL *)url
                                     parameters:(NSDictionary *)postParams
{
    return [[YMAConnection alloc] initWithUrl:url parameters:postParams requestMethod:kRequestMethodGet];
}

#pragma mark - Public methods

+ (NSString *)addPercentEscapesForString:(NSString *)string
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
        (__bridge CFStringRef)string,
        NULL,
        (CFStringRef)@";/?:@&=+$,",
        kCFStringEncodingUTF8));
}

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue completion:(YMAConnectionHandler)handler
{
    [self sendAsynchronousWithQueue:queue redirectHandler:NULL completion:handler];
}

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue
                  redirectHandler:(YMAConnectionRedirectHandler)redirectHandler
                       completion:(YMAConnectionHandler)completionHandler
{
    NSString *value = [NSString stringWithFormat:@"%lu", (unsigned long)self.request.HTTPBody.length];
    [self.request addValue:value forHTTPHeaderField:kHeaderContentLength];

#ifdef DEBUG
    NSLog(@"<<<< Request to URL: %@ >>> %@", self.request.URL.absoluteString,
          [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding]);
#endif

    if (redirectHandler == NULL) {
        [NSURLConnection sendAsynchronousRequest:self.request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   completionHandler(self.request, response, data, connectionError);
                               }];
    }
    else {
        self.redirectHandler   = redirectHandler;
        self.completionHandler = completionHandler;

        self.response = nil;
        self.responseData = nil;

        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        [connection setDelegateQueue:queue];
        [connection start];

    }
}

- (void)addValue:(NSString *)value forHeader:(NSString *)header
{
    [self.request addValue:value forHTTPHeaderField:header];
}

+ (NSString *)bodyStringWithParams:(NSDictionary *)postParams
{
    if (!postParams)
        return [NSString string];
    
    NSMutableArray *bodyParams = [NSMutableArray array];
    
    for (NSString *key in postParams.allKeys) {
        id value = postParams[key];
        NSString *paramValue = [value isKindOfClass:[NSNumber class]] ? [value stringValue] : value;
        
        NSString *encodedValue = [YMAConnection addPercentEscapesForString:paramValue];
        NSString *encodedKey = [YMAConnection addPercentEscapesForString:key];
        
        [bodyParams addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }
    
    return [bodyParams componentsJoinedByString:@"&"];
}

#pragma mark - NSURLConnectionDataDelegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSURLRequest *resultRequest = request;
    if (self.redirectHandler != NULL) {
        resultRequest = self.redirectHandler(request, response);
        if (resultRequest == nil) {
            [connection cancel];
        }
    }
    return resultRequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.completionHandler != NULL) {
        self.completionHandler(self.request, self.response, self.responseData, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.completionHandler != NULL) {
        self.completionHandler(self.request, self.response, self.responseData, error);
    }
}


#pragma mark - Getters and setters

- (NSMutableData *)responseData
{
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    return _responseData;
}

@end
