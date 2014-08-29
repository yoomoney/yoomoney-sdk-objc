//
// Created by Alexander Mertvetsov on 27.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAIncomingTransferAcceptRequest.h"
#import "YMAHostsProvider.h"

static NSString *const kUrlIncomingTransferAccept = @"api/incoming-transfer-accept";
static NSString *const kParameterOperationId = @"operation_id";
static NSString *const kParameterProtectionCode = @"protection_code";

@interface YMAIncomingTransferAcceptRequest ()

@property (nonatomic, copy) NSString *operationId;
@property (nonatomic, copy) NSString *protectionCode;

@end

@implementation YMAIncomingTransferAcceptRequest

#pragma mark - Object Lifecycle

- (id)initWithOperationId:(NSString *)operationId protectionCode:(NSString *)protectionCode
{
    self = [super init];

    if (self != nil) {
        _operationId = [operationId copy];
        _protectionCode = [protectionCode copy];
    }

    return self;
}

+ (instancetype)acceptIncomingTransferWithOperationId:(NSString *)operationId protectionCode:(NSString *)protectionCode
{
    return [[YMAIncomingTransferAcceptRequest alloc] initWithOperationId:operationId protectionCode:protectionCode];
}

#pragma mark - Overridden methods

- (NSURL *)requestUrl
{
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@",
                                                     [YMAHostsProvider sharedManager].moneyUrl,
                                                     kUrlIncomingTransferAccept];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.operationId forKey:kParameterOperationId];
    [dictionary setValue:self.protectionCode forKey:kParameterProtectionCode];
    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data headers:(NSDictionary *)headers andCompletionHandler:(YMAResponseHandler)handler
{
    return [[YMAIncomingTransferAcceptResponse alloc] initWithData:data headers:headers andCompletion:handler];
}

@end