//
// Created by Alexander Mertvetsov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsSession.h"
#import "YMAHostsProvider.h"

static NSString *const kInstanceUrl = @"api/instance-id";

static NSString *const kParameterInstanceId = @"instance_id";
static NSString *const kParameterClientId = @"client_id";
static NSString *const kParameterStatus = @"status";
static NSString *const kValueParameterStatusSuccess = @"success";

@implementation YMACpsSession

#pragma mark -
#pragma mark *** Public methods ***
#pragma mark -

- (void)instanceWithClientId:(NSString *)clientId token:(NSString *)token completion:(YMAIdHandler)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:clientId forKey:kParameterClientId];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kInstanceUrl]];

    [self performRequestWithToken:token parameters:parameters url:url andCompletionHandler:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            block(nil, error);
            return;
        }

        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;

        id responseModel = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : response, @"request" : request}];

        if (error || !responseModel) {
            block(nil, (error) ? error : unknownError);
            return;
        }

        if (statusCode == YMAStatusCodeOkHTTP) {

            NSString *status = [responseModel objectForKey:kParameterStatus];

            if ([status isEqual:kValueParameterStatusSuccess]) {

                self.instanceId = [responseModel objectForKey:@"instance_id"];

                block(self.instanceId, self.instanceId ? nil : unknownError);

                return;
            }
        }

        NSString *errorKey = [responseModel objectForKey:@"error"];

        (errorKey) ? block(nil, [NSError errorWithDomain:errorKey code:statusCode userInfo:parameters]) : block(nil, unknownError);
    }];
}

- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block {
    NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"request" : request}];

    if (!request || !self.instanceId) {
        block(request, nil, unknownError);
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];

    [parameters setObject:self.instanceId forKey:kParameterInstanceId];

    [self performRequestWithToken:token parameters:parameters url:request.requestUrl andCompletionHandler:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        if (error) {
            block(request, nil, error);
            return;
        }

        [request buildResponseWithData:responseData queue:_responseQueue andCompletion:block];
    }];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self, @{@"instanceId" : self.instanceId}];
}

@end