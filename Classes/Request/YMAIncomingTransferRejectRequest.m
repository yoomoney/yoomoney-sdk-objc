//
// Created by Alexander Mertvetsov on 27.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAIncomingTransferRejectRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlIncomingTransferReject = @"api/incoming-transfer-reject";
static NSString *const kParameterOperationId = @"operation_id";

@interface YMAIncomingTransferRejectRequest ()

@property(nonatomic, copy) NSString *operationId;

@end

@implementation YMAIncomingTransferRejectRequest

- (id)initWithOperationId:(NSString *)operationId {
    self = [super init];

    if (self) {
        _operationId = [operationId copy];
    }

    return self;
}

+ (instancetype)rejectIncomingTransferWithOperationId:(NSString *)operationId {
    return [[YMAIncomingTransferRejectRequest alloc] initWithOperationId:operationId];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlIncomingTransferReject];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.operationId forKey:kParameterOperationId];
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMABaseProcessResponse alloc] initWithData:data andCompletion:handler];
}

@end