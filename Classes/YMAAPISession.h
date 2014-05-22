//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseSession.h"

extern NSString* const kAuthorizeUrl;
extern NSString* const kTokenUrl;

@interface YMAAPISession : YMABaseSession

- (NSURLRequest *)authorizationRequestWithUrl:(NSString *)relativeUrlString clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params;

- (BOOL)isRequest:(NSURLRequest *)request toRedirectUrl:(NSString *)redirectUrl authorizationInfo:(NSMutableDictionary *)authInfo error:(NSError *)error;

- (void)receiveTokenWithWithUrl:(NSString *)relativeUrlString code:(NSString *)code clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params completion:(YMAIdHandler)block;

- (void)revokeToken:(NSString *)token completion:(YMAHandler)block;

@end