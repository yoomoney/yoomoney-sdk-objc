//
//  YMAConnection.h
//
//  Created by Alexander Mertvetsov on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void
(^YMAConnectionHandler)(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error);
typedef NSURLRequest * (^YMAConnectionRedirectHandler)(NSURLRequest *request, NSURLResponse *redirectResponse);

@interface YMAConnection : NSObject

+ (instancetype)connectionForPostRequestWithUrl:(NSURL *)url
                                 postParameters:(NSDictionary *)postParams;

+ (instancetype)connectionForPostRequestWithUrl:(NSURL *)url
                                       bodyData:(NSData *)bodyData;

+ (instancetype)connectionForGetRequestWithUrl:(NSURL *)url
                                     parameters:(NSDictionary *)postParams;

+ (NSString *)addPercentEscapesForString:(NSString *)string;

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue
                       completion:(YMAConnectionHandler)handler;

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue
                  redirectHandler:(YMAConnectionRedirectHandler)redirectHandler
                       completion:(YMAConnectionHandler)completionHandler;

- (void)addValue:(NSString *)value forHeader:(NSString *)header;

- (void)cancel;

@end
