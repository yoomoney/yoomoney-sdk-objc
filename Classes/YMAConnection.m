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
@property (nonatomic, strong) NSURLConnection *connection;

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

#if defined(DEBUG) || defined(ADHOC)
    NSMutableString *debugString = [NSMutableString stringWithFormat:@"Request to URL: %@\nHeaders:%@",
                                    self.request.URL.absoluteString,
                                    self.request.allHTTPHeaderFields];
    
    if (self.request.HTTPBody.length > 0) {
        [debugString appendFormat:@"\nHTTP body:%@", [[NSString alloc] initWithData:self.request.HTTPBody
                                                                           encoding:NSUTF8StringEncoding]];
    }
    NSLog(@"%@", debugString);
#endif

    self.redirectHandler   = redirectHandler;
    self.completionHandler = completionHandler;

    self.response = nil;
    self.responseData = nil;

    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:queue];
    [self.connection start];
}

- (void)addValue:(NSString *)value forHeader:(NSString *)header
{
    [self.request addValue:value forHTTPHeaderField:header];
}

+ (NSString *)bodyStringWithParams:(NSDictionary *)postParams
{
    if (postParams == nil) {
        return [NSString string];
    }

    NSMutableArray *bodyParams = [NSMutableArray array];

    for (NSString *key in postParams.allKeys) {
        id value = postParams[key];
        NSString *stringValue = [self formatToStringValue:value];
        if (stringValue != nil) {
            NSString *encodedValue = [YMAConnection addPercentEscapesForString:stringValue];
            NSString *encodedKey = [YMAConnection addPercentEscapesForString:key];

            [bodyParams addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }
    }

    return [bodyParams componentsJoinedByString:@"&"];
}

+ (NSString *)formatToStringValue:(id)value
{
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return nil;
    }

    NSString *stringValue = nil;
    if ([value isKindOfClass:[NSString class]]) {
        stringValue = value;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        stringValue = [value stringValue];
    }
    else if ([value isKindOfClass:[NSArray class]]) {

        NSMutableString *mutableString = [NSMutableString string];
        NSArray *array = value;

        [mutableString appendString:@"["];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx > 0) {
                [mutableString appendString:@","];
            }
            [mutableString appendString:[self formatToStringValue:obj]];
        }];
        [mutableString appendString:@"]"];

        stringValue = [mutableString copy];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {

        NSMutableString *mutableString = [NSMutableString string];
        NSDictionary *dictionary = value;

        [mutableString appendString:@"{"];
        __block BOOL dictionaryHasValues = NO;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (dictionaryHasValues) {
                [mutableString appendString:@","];
            }
            [mutableString appendString:[NSString stringWithFormat:@"%@:%@", key, [self formatToStringValue:obj]]];
            dictionaryHasValues = YES;
        }];
        [mutableString appendString:@"}"];

        stringValue = [mutableString copy];
    }

    return stringValue;
}

- (void)cancel
{
    [self.connection cancel];
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
