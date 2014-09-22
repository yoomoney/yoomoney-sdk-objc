//
// Created by Alexander Mertvetsov on 20.05.14.
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

// Header constant = "User-Agent".
extern NSString *const YMAHeaderUserAgent;
// Method constant = "POST".
extern NSString *const YMAMethodPost;
// Default content type.
extern NSString *const YMAValueContentTypeDefault;
// Default content type.
extern NSString *const YMAValueUserAgentDefault;

/// Values for YMAConnectHTTPStatusCodes
/// HTTP status codes
typedef NS_ENUM(NSInteger, YMAConnectHTTPStatusCodes) {
    YMAStatusCodeOkHTTP = 200,
    YMAStatusCodeInvalidRequestHTTP = 400,
    YMAStatusCodeInvalidTokenHTTP = 401,
    YMAStatusCodeInsufficientScopeHTTP = 403,
    YMAStatusCodeInternalServerErrorHTTP = 500
};

///
/// Abstract session class.
///
@interface YMABaseSession : NSObject {
@protected
    NSString *_userAgent;
}

/// Initialize session object with specified user agent.
/// @param userAgent - user agent (if you want to set default user agent you can use constructor - (id)init)
- (id)initWithUserAgent:(NSString *)userAgent;

/// Send request used token.
/// @param requestMethod - request method.
/// @param token - an access token is a string representing an authorization issued to the client (see OAuth 2.0)
/// @param parameters - request parameters.
/// @param customHeaders - used for define custom headers of request.
/// @param url -  request url.
/// @param block - completion of block is used to get the response.
- (void)performRequestWithMethod:(YMARequestMethod)requestMethod
                           token:(NSString *)token
                      parameters:(NSDictionary *)parameters
                   customHeaders:(NSDictionary *)customHeaders
                             url:(NSURL *)url
                      completion:(YMAConnectionHandler)block;

/// Send request used token and analyzed HTTP status code of response.
/// @param requestMethod - request method.
/// @param token - an access token is a string representing an authorization issued to the client (see OAuth 2.0)
/// @param parameters - request parameters.
/// @param customHeaders - used for define custom headers of request.
/// @param url -  request url.
/// @param block - completion of block is used to get the response.
- (void)performAndProcessRequestWithMethod:(YMARequestMethod)requestMethod
                                     token:(NSString *)token
                                parameters:(NSDictionary *)parameters
                             customHeaders:(NSDictionary *)customHeaders
                                       url:(NSURL *)url
                                completion:(YMAConnectionHandler)block;

/// Send request used token and analyzed HTTP status code of response.
/// @param token - an access token is a string representing an authorization issued to the client (see OAuth 2.0)
/// @param data - request data.
/// @param customHeaders - used for define custom headers of request.
/// @param url -  request url.
/// @param block - completion of block is used to get the response.
- (void)performAndProcessRequestWithToken:(NSString *)token
                                     data:(NSData *)data
                            customHeaders:(NSDictionary *)customHeaders
                                      url:(NSURL *)url
                               completion:(YMAConnectionHandler)block;

/// Get the header value by name
/// @param headerName - response header name
/// @param response -
- (NSString *)valueOfHeader:(NSString *)headerName forResponse:(NSURLResponse *)response;

/// You can set language for response data (for example: "en" - English, "ru" - Russian). Russian is default language.
@property (nonatomic, copy) NSString *language;
@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, strong) NSOperationQueue *responseQueue;

@end