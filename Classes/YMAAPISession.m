//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAPISession.h"
#import "YMAUtils.h"

NSString* const kParameterClientId = @"client_id";
NSString* const kParameterResponseType = @"response_type";
NSString* const kParameterRedirectUri = @"redirect_uri";
NSString* const kParameterScope = @"scope";
NSString* const kValueParameterResponseType = @"code";

@implementation YMAAPISession

- (NSURLRequest *)authorizeRequestWithClientId:(NSString *)clientId redirectUrl:(NSString *)redirectUrl andScope:(NSString *)scope
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

    NSString* urlString = [NSString stringWithFormat:@"https://%@/%@", kSpMoneyHost, kAuthorizeUrl];
    NSURL* url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    [request setHTTPMethod:kPostHttpMethod];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:kContentLengthHeader];
    [request setValue:kDefaultContentTypeValue forHTTPHeaderField:kContentTypeHeader];
    [request setHTTPBody:postData];

    return request;
}


@end