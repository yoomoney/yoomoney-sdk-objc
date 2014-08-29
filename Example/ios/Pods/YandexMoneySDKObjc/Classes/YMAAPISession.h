//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseSession.h"
#import "YMABaseRequest.h"

/// Response type (used in authorization request)
extern NSString *const YMAParameterResponseType;
/// Default value of response type (used in authorization request)
extern NSString *const YMAValueParameterResponseType;

@interface YMAAPISession : YMABaseSession

/// get authorization request
/// @param clientId - your client Id.
/// @param params - additional authorization params (response type, redirect url, scope etc.)
- (NSURLRequest *)authorizationRequestWithClientId:(NSString *)clientId andAdditionalParams:(NSDictionary *)params;

- (NSURLRequest *)authorizationRequestWithUrl:(NSString *)relativeUrlString
                                     clientId:(NSString *)clientId
                          andAdditionalParams:(NSDictionary *)params;

/// This method used, when WebView is redirected to request, for check redirect url.
/// If the received redirect url matches the url you passed in the request authorization we obtain authorization info.
/// @param request - redirect request
/// @param redirectUrl - redirect url passed in the authorization request
/// @param authInfo - return value of authorization info
/// @param error -
- (BOOL)isRequest:(NSURLRequest *)request
    toRedirectUrl:(NSString *)redirectUrl
authorizationInfo:(NSMutableDictionary * __autoreleasing *)authInfo
            error:(NSError * __autoreleasing *)error;

// get authorization token
- (void)receiveTokenWithWithCode:(NSString *)code
                        clientId:(NSString *)clientId
             andAdditionalParams:(NSDictionary *)params
                      completion:(YMAIdHandler)block;

- (void)receiveTokenWithWithUrl:(NSString *)relativeUrlString
                           code:(NSString *)code
                       clientId:(NSString *)clientId
            andAdditionalParams:(NSDictionary *)params
                     completion:(YMAIdHandler)block;

- (void)revokeToken:(NSString *)token completion:(YMAHandler)block;

- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block;

@end