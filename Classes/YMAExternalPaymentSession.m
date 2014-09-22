//
// Created by Alexander Mertvetsov on 27.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAExternalPaymentSession.h"
#import "YMAHostsProvider.h"

static NSString *const kInstanceUrl = @"api/instance-id";

static NSString *const kParameterInstanceId = @"instance_id";
static NSString *const kParameterClientId = @"client_id";
static NSString *const kParameterStatus = @"status";
static NSString *const kValueParameterStatusSuccess = @"success";

@implementation YMAExternalPaymentSession

#pragma mark - Public methods

- (void)instanceWithClientId:(NSString *)clientId token:(NSString *)token completion:(YMAIdHandler)block
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:clientId forKey:kParameterClientId];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/%@",
                                                                 [YMAHostsProvider sharedManager].moneyUrl,
                                                                 kInstanceUrl]];

    [self performRequestWithMethod:YMARequestMethodPost
                             token:token
                        parameters:parameters
                     customHeaders:nil
                               url:url
                        completion:^(NSURLRequest *request, NSURLResponse *response, NSData *responseData, NSError *error) {
                           
                           if (error != nil) {
                               block(nil, error);
                               return;
                           }

                           NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;

                           id responseModel =
                               [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:(NSJSONReadingOptions)kNilOptions
                                                                 error:&error];

                           NSError *unknownError = [NSError errorWithDomain:YMAErrorDomainUnknown
                                                                       code:0
                                                                   userInfo:@{
                                                                       YMAErrorKeyResponse : response,
                                                                       YMAErrorKeyRequest : request
                                                                   }];

                           if (error != nil || responseModel == nil) {
                               block(nil, (error) ? error : unknownError);
                               return;
                           }

                           if (statusCode == YMAStatusCodeOkHTTP) {
                               NSString *status = responseModel[kParameterStatus];

                               if ([status isEqual:kValueParameterStatusSuccess]) {
                                   self.instanceId = responseModel[@"instance_id"];
                                   block(self.instanceId, self.instanceId ? nil : unknownError);
                                   return;
                               }
                           }

                           NSString *errorKey = responseModel[@"error"];

                           if (errorKey == nil)
                               block(nil, unknownError);
                           else {
                               block(nil, [NSError errorWithDomain:YMAErrorDomainYaMoneyAPI code:statusCode userInfo:@{YMAErrorKey: errorKey, YMAErrorKeyResponse: response}]);
                           }
                       }];
}



- (void)performRequest:(YMABaseRequest *)request token:(NSString *)token completion:(YMARequestHandler)block
{
    NSError *unknownError = [NSError errorWithDomain:YMAErrorDomainUnknown code:0 userInfo:@{ YMAErrorKeyRequest : request }];

    if (request == nil || self.instanceId == nil) {
        block(request, nil, unknownError);
        return;
    }

    if ([request conformsToProtocol:@protocol(YMAParametersPosting)]) {
        YMABaseRequest<YMAParametersPosting> *paramsRequest = (YMABaseRequest<YMAParametersPosting> *)request;
        NSMutableDictionary *parameters = [paramsRequest.parameters mutableCopy];

        [parameters setValue:self.instanceId forKey:kParameterInstanceId];

        [self performAndProcessRequestWithMethod:YMARequestMethodPost
                                           token:token
                                      parameters:parameters
                                   customHeaders:paramsRequest.customHeaders
                                             url:request.requestUrl
                                      completion:^(NSURLRequest *urlRequest, NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
                                         if (error != nil) {
                                             block(request, nil, error);
                                             return;
                                         }
                                         
                                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;
                                         NSDictionary *headers =  httpResponse.allHeaderFields;

                                         [request buildResponseWithData:responseData
                                                                headers:headers
                                                                  queue:self.responseQueue
                                                          andCompletion:block];
                                     }];
    }
}

@end