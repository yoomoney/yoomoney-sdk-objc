//
// Created by Alexander Mertvetsov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsSession.h"
#import "YMAConstants.h"

static NSString *const kInstanceUrl = @"https://money.yandex.ru/api/instance-id";

static NSString *const kParameterInstanceId = @"instance_id";
static NSString *const kParameterClientId = @"client_id";
static NSString *const kParameterStatus = @"status";
static NSString *const kValueParameterStatusSuccess = @"success";
static NSString *const kValueUserAgentDefault = @"Yandex.Money.SDK/iOS";

@implementation YMACpsSession

#pragma mark -
#pragma mark *** Public methods ***
#pragma mark -

- (void)authorizeWithClientId:(NSString *)clientId token:(NSString *)token completion:(YMAInstanceHandler)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:clientId forKey:kParameterClientId];

    NSURL *url = [NSURL URLWithString:kInstanceUrl];

    [self performRequestWithToken:token parameters:parameters url:url andCompletionHandler:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;

        id responseModel = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:parameters];

        if (error || !responseModel) {
            block(nil, (error) ? error : unknownError);
            return;
        }

        if (statusCode == YMAStatusCodeOkHTTP) {

            NSString *status = [responseModel objectForKey:kParameterStatus];

            if ([status isEqual:kValueParameterStatusSuccess]) {

                self.instanceId = [responseModel objectForKey:@"instance_id"];

                block(self.instanceId, self.instanceId ? nil : unknownError);

                return;
            }
        }

        NSString *errorKey = [responseModel objectForKey:@"error"];

        (errorKey) ? block(nil, [NSError errorWithDomain:errorKey code:statusCode userInfo:parameters]) : block(nil, unknownError);
    }];
}

- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block {
    NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request}];

    if (!request || !self.instanceId) {
        block(request, nil, unknownError);
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];

    [parameters setObject:self.instanceId forKey:kParameterInstanceId];


    [self performRequestWithToken:nil parameters:parameters url:request.requestUrl andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        if (error) {
            block(request, nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) urlResponse).statusCode;
        NSError *technicalError = [NSError errorWithDomain:kErrorKeyUnknown code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}];

        switch (statusCode) {
            case YMAStatusCodeOkHTTP:
                [request buildResponseWithData:responseData queue:_responseQueue andCompletion:block];
                break;
            case YMAStatusCodeInsufficientScopeHTTP:
            case YMAStatusCodeInvalidTokenHTTP:
                block(request, nil, [NSError errorWithDomain:[self valueOfHeader:kHeaderWWWAuthenticate forResponse:urlResponse] code:statusCode userInfo:@{@"request" : urlRequest, @"response" : urlResponse}]);
                break;
            case YMAStatusCodeInvalidRequestHTTP:
                block(request, nil, technicalError);
                break;
            default:
                block(request, nil, unknownError);
                break;
        }
    }];
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (NSString *)valueOfHeader:(NSString *)headerName forResponse:(NSURLResponse *)response {
    NSDictionary *headers = [((NSHTTPURLResponse *) response) allHeaderFields];

    for (NSString *header in headers.allKeys) {
        if ([header caseInsensitiveCompare:headerName] == NSOrderedSame)
            return [headers objectForKey:header];
    }

    return nil;
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

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

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self, @{@"instanceId" : self.instanceId}];
}

@end