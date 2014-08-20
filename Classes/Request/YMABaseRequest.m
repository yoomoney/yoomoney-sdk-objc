//
//  YMABaseRequest.m
//
//  Created by Alexander Mertvetsov on 01.11.13.
//  Copyright (c) 2013 Yandex.Money. All rights reserved.
//

#import "YMABaseRequest.h"
#import "YMABaseResponse.h"

@implementation YMABaseRequest

- (void)buildResponseWithData:(NSData *)data headers:(NSDictionary *)headers queue:(NSOperationQueue *)queue andCompletion:(YMARequestHandler)block
{
    NSOperation *operation =
        [self buildResponseOperationWithData:data headers:(NSDictionary *)headers andCompletionHandler:^(YMABaseResponse *response, NSError *error) {
            block(self, response, error);
        }];

    if (operation == nil) {
        block(self, nil, [NSError errorWithDomain:YMAErrorDomainUnknown code:0 userInfo:nil]);
        return;
    }

    [queue addOperation:operation];
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data headers:(NSDictionary *)headers andCompletionHandler:(YMAResponseHandler)handler
{
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (YMARequestMethod)requestMethod
{
    return YMARequestMethodPost;
}

@end
