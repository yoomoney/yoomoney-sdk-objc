//
//  YMABaseRequest.m
//
//  Created by Александр Мертвецов on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABaseRequest.h"
#import "YMABaseResponse.h"
#import "YMAConstants.h"

@implementation YMABaseRequest

- (void)buildResponseWithData:(NSData *)data queue:(NSOperationQueue *)queue andCompletionHandler:(YMARequestHandler)handler {
    NSOperation *operation = [self buildResponseOperationWithData:data andCompletionHandler:^(YMABaseResponse *response, NSError *error) {
        handler(self, response, error);
    }];

    if (!operation) {
        handler(self, nil, [NSError errorWithDomain:@"technicalError" code:0 userInfo:nil]);
        return;
    }

    [queue addOperation:operation];
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
