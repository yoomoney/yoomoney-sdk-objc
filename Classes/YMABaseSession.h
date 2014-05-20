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

@interface YMABaseSession : NSObject

- (void)performRequestWithToken:(NSString *)token parameters:(NSDictionary *)parameters url:(NSURL *)url andCompletionHandler:(YMAConnectionHandler)handler;

@end