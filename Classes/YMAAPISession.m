//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAPISession.h"
#import "YMAUtils.h"
#import "YMAHostsProvider.h"

NSString* const kAuthorizeUrl = @"oauth/authorize";
NSString* const kParameterClientId = @"client_id";
NSString* const kParameterResponseType = @"response_type";
NSString* const kParameterRedirectUri = @"redirect_uri";
NSString* const kParameterScope = @"scope";
NSString* const kValueParameterResponseType = @"code";

@implementation YMAAPISession

- (NSURLRequest *)authorizationRequestWithClientId:(NSString *)clientId redirectUrl:(NSString *)redirectUrl andScope:(NSString *)scope
{
    NSMutableString* post = [NSMutableString stringWithCapacity:0];

    NSString *clientIdParamKey = [YMAUtils addPercentEscapesForString:kParameterClientId];
    NSString *clientIdParamValue = [YMAUtils addPercentEscapesForString:clientId];

    [post appendString:[NSString stringWithFormat:@"%@=%@&", clientIdParamKey, clientIdParamValue]];

    NSString *responseTypeParamKey = [YMAUtils addPercentEscapesForString:kParameterResponseType];
    NSString *responseTypeParamValue = [YMAUtils addPercentEscapesForString:kValueParameterResponseType];

    [post appendString:[NSString stringWithFormat:@"%@=%@&", responseTypeParamKey, responseTypeParamValue]];

    NSString *redirectUriParamKey = [YMAUtils addPercentEscapesForString:kParameterRedirectUri];
    NSString *redirectUriParamValue = [YMAUtils addPercentEscapesForString:redirectUrl];

    [post appendString:[NSString stringWithFormat:@"%@=%@&", redirectUriParamKey, redirectUriParamValue]];

    NSString *scopeParamKey = [YMAUtils addPercentEscapesForString:kParameterScope];
    NSString *scopeParamValue = [YMAUtils addPercentEscapesForString:scope];

    [post appendString:[NSString stringWithFormat:@"%@=%@", scopeParamKey, scopeParamValue]];

    NSString* urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager], kAuthorizeUrl];
    NSURL* url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPMethod:kMethodPost];
    [request setValue:[NSString stringWithFormat:@"%i", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:kValueContentTypeDefault forHTTPHeaderField:kHeaderContentType];
    [request setHTTPBody:postData];

    return request;
}

- (BOOL)isRequest:(NSURLRequest *)request toRedirectUrl:(NSString *)redirectUrl authorizationInfo:(id)authInfo error:(NSError *)error {

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


        return YES;
    } else
        return NO;
}

@end