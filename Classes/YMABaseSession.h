//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAConnection.h"
#import "YMAConstants.h"

/// Completion of block is used to get the ID of an installed copy of the application.
/// @param Id - ID of an installed copy of the application.
typedef void (^YMAIdHandler)(NSString *Id, NSError *error);

/// Completion block used by several methods of YMAExternalPaymentSession.
/// @param error - Error information or nil.
typedef void (^YMAHandler)(NSError *error);

extern NSString *const kHeaderContentType;
extern NSString *const kHeaderUserAgent;
extern NSString *const kMethodPost;
extern NSString *const kValueContentTypeDefault;
extern NSString *const kValueUserAgentDefault;

typedef NS_ENUM(NSInteger, YMAConnectHTTPStatusCodes) {
    YMAStatusCodeOkHTTP = 200,
    YMAStatusCodeInvalidRequestHTTP = 400,
    YMAStatusCodeInvalidTokenHTTP = 401,
    YMAStatusCodeInsufficientScopeHTTP = 403,
    YMAStatusCodeInternalServerErrorHTTP = 500
};

@interface YMABaseSession : NSObject {
@protected
    NSOperationQueue *_requestQueue;
    NSOperationQueue *_responseQueue;
    NSString *_userAgent;
}

- (id)initWithUserAgent:(NSString *)userAgent;

- (void)performRequestWithToken:(NSString *)token parameters:(NSDictionary *)parameters url:(NSURL *)url completion:(YMAConnectionHandler)block;

- (void)performAndProcessRequestWithToken:(NSString *)token parameters:(NSDictionary *)parameters url:(NSURL *)url completion:(YMAConnectionHandler)block;

- (void)performAndProcessRequestWithToken:(NSString *)token data:(NSData *)data url:(NSURL *)url completion:(YMAConnectionHandler)block;

- (NSString *)valueOfHeader:(NSString *)headerName forResponse:(NSURLResponse *)response;

@property(nonatomic, copy) NSString *language;

@end