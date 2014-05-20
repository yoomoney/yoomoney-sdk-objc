//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseSession.h"

//extern NSString* const kAuthorizeUrl;
//extern NSString* const kParameterClientId;
//extern NSString* const kParameterResponseType;
//extern NSString* const kParameterRedirectUri;
//extern NSString* const kParameterScope;
//extern NSString* const kValueParameterResponseType;

@interface YMAAPISession : YMABaseSession

- (NSURLRequest *)authorizationRequestWithClientId:(NSString *)clientId redirectUrl:(NSString *)redirectUrl andScope:(NSString *)scope;



@end