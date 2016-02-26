//
//  YMABaseRequest.h
//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAConstants.h"
#import "YMABaseSession.h"

@class YMABaseRequest;
@class YMABaseResponse;

@protocol YMADataPosting<NSObject>

/// Request data
@property (nonatomic, strong, readonly) NSData *data;

@end

@protocol YMAParametersPosting<NSObject>

/// Request parameters.
@property (nonatomic, strong, readonly) NSDictionary *parameters;

@end

/// Completion of block is used to get the response.
/// @param request - request inherited from abstract class YMABaseRequest.
/// @param response - response inherited from abstract class YMABaseResponse.
/// @param error - Error information or nil.
typedef void (^YMARequestHandler)(YMABaseRequest *request, YMABaseResponse *response, NSError *error);

typedef BOOL (^YMARedirectHandler)(NSURLRequest *request, NSURLResponse *response);

///
/// Abstract class of request. This class contains common info about the request (requestUrl, parameters).
///
@interface YMABaseRequest : NSObject

/// Request url
@property (nonatomic, strong, readonly) NSURL *requestUrl;
@property (nonatomic, strong) id context;

@property (nonatomic, assign, readonly) YMARequestMethod requestMethod;
/// Used for define custom headers of request.
@property (nonatomic, strong, readonly) NSDictionary *customHeaders;

/// Method is used for parse response data.
/// @param data - response data.
/// @param headers - response headers.
/// @param httpStatusCode - response http status ceode.
/// @param queue - operation queue.
/// @param block - completion of block is used to get the response.
- (void)buildResponseWithData:(NSData *)data
                      headers:(NSDictionary *)headers
               httpStatusCode:(YMAConnectHTTPStatusCodes)statusCode
                        queue:(NSOperationQueue *)queue
                   completion:(YMARequestHandler)block;

@end
