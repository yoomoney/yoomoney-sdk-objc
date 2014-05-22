//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAPISession.h"
#import "YMAUtils.h"
#import "YMAHostsProvider.h"
#import "YMABaseRequest.h"

NSString* const kAuthorizeUrl = @"oauth/authorize";
NSString* const kTokenUrl = @"oauth/token";
static NSString* const kRevokeUrl = @"api/revoke";
static NSString* const kParameterClientId = @"client_id";
static NSString* const kParameterResponseType = @"response_type";
static NSString* const kValueParameterResponseType = @"code";

@implementation YMAAPISession

- (NSURLRequest *)authorizationRequestWithUrl:(NSString *)relativeUrlString clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params {
    NSMutableString* post = [NSMutableString stringWithCapacity:0];

    NSString *clientIdParamKey = [YMAUtils addPercentEscapesForString:kParameterClientId];
    NSString *clientIdParamValue = [YMAUtils addPercentEscapesForString:clientId];

    [post appendString:[NSString stringWithFormat:@"%@=%@&", clientIdParamKey, clientIdParamValue]];

    NSString *responseTypeParamKey = [YMAUtils addPercentEscapesForString:kParameterResponseType];
    NSString *responseTypeParamValue = [YMAUtils addPercentEscapesForString:kValueParameterResponseType];

    [post appendString:[NSString stringWithFormat:@"%@=%@&", responseTypeParamKey, responseTypeParamValue]];

    for (NSString *key in params.allKeys) {
        
        NSString *paramKey = [YMAUtils addPercentEscapesForString:key];
        NSString *paramValue = [YMAUtils addPercentEscapesForString:[params objectForKey:key]];
        
        [post appendString:[NSString stringWithFormat:@"%@=%@&", paramKey, paramValue]];
    }
    
    NSString* urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].spMoneyUrl, relativeUrlString];
    NSURL* url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPMethod:kMethodPost];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:kValueContentTypeDefault forHTTPHeaderField:kHeaderContentType];
    [request setHTTPBody:postData];

    return request;
}

- (BOOL)isRequest:(NSURLRequest *)request toRedirectUrl:(NSString *)redirectUrl authorizationInfo:(NSMutableDictionary *)authInfo error:(NSError *)error {
    error = nil;
    authInfo = nil;
    NSURL *requestUrl = request.URL;

    if (!requestUrl)
        return NO;

    NSString *scheme = requestUrl.scheme;
    NSString *path = requestUrl.path;
    NSString *host = requestUrl.host;

    NSString *strippedURL = [NSString stringWithFormat:@"%@://%@%@", scheme, host, path];

    if ([strippedURL isEqual:redirectUrl]) {

        NSString *query = requestUrl.query;

        if (!query || query.length == 0) {
            error = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"requestUrl" : request.URL}];
        } else {

            authInfo = [NSMutableDictionary dictionary];

            NSArray *queryComponents = [query componentsSeparatedByString:@"&"];

            for (NSString *keyValuePair in queryComponents) {
                NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
                NSString *key = [pairComponents objectAtIndex:0];
                NSString *value = [pairComponents objectAtIndex:1];

                [authInfo setObject:value forKey:key];
            }
        }

        return YES;
    } else
        return NO;
}

- (void)receiveTokenWithWithUrl:(NSString *)relativeUrlString code:(NSString *)code clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params completion:(YMAIdHandler)block {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:code forKey:kValueParameterResponseType];
    [parameters setObject:clientId forKey:kParameterClientId];
    [parameters addEntriesFromDictionary:params];

    NSString* urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].spMoneyUrl, relativeUrlString];
    NSURL* url = [NSURL URLWithString:urlString];

    [self performRequestWithToken:nil parameters:parameters url:url andCompletionHandler:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
        
        if (error)
        {
            block(nil, error);
            return;
        }
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        id responseModel = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : response, @"request" : request}];
        
        if (error || !responseModel)
        {
            block(nil, (error) ? error : unknownError);
            return;
        }
        
        if (statusCode == YMAStatusCodeOkHTTP) {
            
            NSString* accessToken = [responseModel objectForKey:@"access_token"];
            
            if (accessToken) {
                block(accessToken, nil);
            } else
                block(nil, unknownError);
            
            return;
        }
        
        NSString* errorKey = [responseModel objectForKey:@"error"];
        
        (errorKey) ? block(nil, [NSError errorWithDomain:NSLocalizedString(errorKey, errorKey) code:statusCode userInfo:nil]) : block(nil, unknownError);
    }];
}

- (void)revokeToken:(NSString *)token completion:(YMAHandler)block {
    NSString* urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kRevokeUrl];
    NSURL* url = [NSURL URLWithString:urlString];

    [self performRequestWithToken:token parameters:nil url:url andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        if (error) {
            block(error);
            return;
        }

        block(nil);
    }];
}

- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block {
    NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request}];

    if (!request) {
        block(request, nil, unknownError);
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];

    [self performRequestWithToken:token parameters:parameters url:request.requestUrl andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        if (error) {
            block(request, nil, error);
            return;
        }

        [request buildResponseWithData:responseData queue:_responseQueue andCompletion:block];
    }];
}

@end