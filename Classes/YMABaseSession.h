//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAConnection.h"

/// Completion of block is used to get the ID of an installed copy of the application.
/// @param instanceId - ID of an installed copy of the application.
typedef void (^YMAInstanceHandler)(NSString *instanceId, NSError *error);

/// Completion block used by several methods of YMACpsSession.
/// @param error - Error information or nil.
typedef void (^YMAHandler)(NSError *error);

extern NSString* const kValueHeaderAuthorizationFormat;
extern NSString* const kHeaderAuthorization;
extern NSString *const kHeaderWWWAuthenticate;
extern NSString *const kHeaderContentType;
extern NSString *const kHeaderUserAgent;
extern NSString *const kMethodPost;
extern NSString *const kValueContentTypeDefault;

typedef NS_ENUM(NSInteger, YMAConnectHTTPStatusCodes) {
    YMAStatusCodeOkHTTP = 200,
    YMAStatusCodeInvalidRequestHTTP = 400,
    YMAStatusCodeInvalidTokenHTTP = 401,
    YMAStatusCodeInsufficientScopeHTTP = 403,
    YMAStatusCodeInternalServerErrorHTTP = 500
};

@interface YMABaseSession : NSObject {
    NSOperationQueue *_requestQueue;
    NSOperationQueue *_responseQueue;
}

- (void)performRequestWithToken:(NSString *)token parameters:(NSDictionary *)parameters url:(NSURL *)url andCompletionHandler:(YMAConnectionHandler)handler;

@end