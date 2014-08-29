//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAOperationDetailsRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kParameterOperationId = @"operation_id";
static NSString *const kParameterFavouriteId = @"favourite_id";
static NSString *const kParameterRequestRepeatInfo = @"request_repeat_info";

static NSString *const kUrlOperationDetails = @"api/operation-details";

@interface YMAOperationDetailsRequest ()

@property (nonatomic, copy) NSString *operationId;
@property (nonatomic, copy) NSString *favouriteId;
@property (nonatomic, assign) BOOL requestRepeatInfo;

@end

@implementation YMAOperationDetailsRequest

#pragma mark - Object Lifecycle

- (id)initWithOperationId:(NSString *)operationId
              favouriteId:(NSString *)favouriteId
        requestRepeatInfo:(BOOL)requestRepeatInfo
{
    self = [super init];

    if (self != nil) {
        _operationId = [operationId copy];
        _favouriteId = [favouriteId copy];
        _requestRepeatInfo = requestRepeatInfo;
    }

    return self;
}

+ (instancetype)operationDetailsWithRepeatInfoByOperationId:(NSString *)operationId
{
    return [[YMAOperationDetailsRequest alloc] initWithOperationId:operationId favouriteId:nil requestRepeatInfo:YES];
}

+ (instancetype)operationDetailsWithOperationId:(NSString *)operationId
{
    return [[YMAOperationDetailsRequest alloc] initWithOperationId:operationId favouriteId:nil requestRepeatInfo:NO];
}

+ (instancetype)operationDetailsWithFavouriteId:(NSString *)favouriteId
{
    return [[YMAOperationDetailsRequest alloc] initWithOperationId:nil favouriteId:favouriteId requestRepeatInfo:YES];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString =
        [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlOperationDetails];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.operationId forKey:kParameterOperationId];
    [dictionary setValue:self.favouriteId forKey:kParameterFavouriteId];
    [dictionary setValue:self.requestRepeatInfo ? @"true" : @"false" forKey:kParameterRequestRepeatInfo];

    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data headers:(NSDictionary *)headers andCompletionHandler:(YMAResponseHandler)handler
{
    return [[YMAOperationDetailsResponse alloc] initWithData:data headers:headers andCompletion:handler];
}

@end