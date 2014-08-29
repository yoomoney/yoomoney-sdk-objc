//
//  YMAConnection.h
//
//  Created by Alexander Mertvetsov on 31.10.13.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void
(^YMAConnectionHandler)(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error);

@interface YMAConnection : NSObject

+ (instancetype)connectionForPostRequestWithUrl:(NSURL *)url
                                      andParams:(NSDictionary *)postParams;

+ (instancetype)connectionForPostRequestWithUrl:(NSURL *)url
                                      andDta:(NSData *)bodyData;

+ (instancetype)connectionForGetRequestWithUrl:(NSURL *)url
                                     andParams:(NSDictionary *)postParams;

+ (NSString *)addPercentEscapesForString:(NSString *)string;

- (void)sendAsynchronousWithQueue:(NSOperationQueue *)queue
                completionHandler:(YMAConnectionHandler)handler;

- (void)addValue:(NSString *)value forHeader:(NSString *)header;

@end
