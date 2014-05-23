//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseSession.h"
#import "YMABaseRequest.h"

extern NSString *const kParameterResponseType;
extern NSString *const kValueParameterResponseType;

@interface YMAAPISession : YMABaseSession

- (NSURLRequest *)authorizationRequestWithClientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params;

- (NSURLRequest *)authorizationRequestWithUrl:(NSString *)relativeUrlString clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params;

- (BOOL)isRequest:(NSURLRequest *)request redirectToUrl:(NSString *)redirectUrl authorizationInfo:(NSMutableDictionary * __autoreleasing *)authInfo error:(NSError * __autoreleasing *)error;

- (void)receiveTokenWithWithCode:(NSString *)code clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params completion:(YMAIdHandler)block;

- (void)receiveTokenWithWithUrl:(NSString *)relativeUrlString code:(NSString *)code clientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params completion:(YMAIdHandler)block;

- (void)revokeToken:(NSString *)token completion:(YMAHandler)block;

- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block;

@end