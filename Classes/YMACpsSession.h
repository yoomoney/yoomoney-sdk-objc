//
// Created by Alexander Mertvetsov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMABaseRequest.h"
#import "YMABaseSession.h"


///
/// Session object to access Yandex.Money.
///
@interface YMACpsSession : YMABaseSession

/// ID of an installed copy of the application. Used when you perform requests as parameter.
@property(nonatomic, copy) NSString *instanceId;

/// Register your application using clientId and obtaining instanceId.
/// @param clientId - application Identifier.
/// @param block - completion of block is used to get the ID of an installed copy of the application.
- (void)authorizeWithClientId:(NSString *)clientId token:(NSString *)token completion:(YMAInstanceHandler)block;

/// Perform some request and obtaining response in block.
/// @param request - request inherited from YMABaseRequest.
/// @param block - completion of block is used to get the response.
- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block;

@end