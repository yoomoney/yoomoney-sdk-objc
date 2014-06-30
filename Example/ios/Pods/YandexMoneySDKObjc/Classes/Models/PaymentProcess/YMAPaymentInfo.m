//
// Created by Alexander Mertvetsov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentInfo.h"
#import "YMAMoneySources.h"


@implementation YMAPaymentInfo

- (id)initWithMoneySources:(YMAMoneySources *)moneySources requestId:(NSString *)requestId contractAmount:(NSString *)contractAmount balance:(NSString *)balance recipientAccountStatus:(YMAAccountStatus)recipientAccountStatus recipientAccountType:(YMAAccountType)recipientAccountType protectionCode:(NSString *)protectionCode extActionUri:(NSURL *)extActionUri {
    self = [super init];

    if (self) {
        _moneySources = moneySources;
        _requestId = [requestId copy];
        _contractAmount = [contractAmount copy];
        _balance = [balance copy];
        _recipientAccountStatus = recipientAccountStatus;
        _recipientAccountType = recipientAccountType;
        _protectionCode = [protectionCode copy];
        _extActionUri = extActionUri;
    }

    return self;
}

+ (instancetype)paymentInfoWithMoneySources:(YMAMoneySources *)moneySources requestId:(NSString *)requestId contractAmount:(NSString *)contractAmount balance:(NSString *)balance recipientAccountStatus:(YMAAccountStatus)recipientAccountStatus recipientAccountType:(YMAAccountType)recipientAccountType protectionCode:(NSString *)protectionCode extActionUri:(NSURL *)extActionUri {
    return [[YMAPaymentInfo alloc] initWithMoneySources:moneySources requestId:requestId contractAmount:contractAmount balance:balance recipientAccountStatus:recipientAccountStatus recipientAccountType:recipientAccountType protectionCode:protectionCode extActionUri:extActionUri];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"moneySources" : self.moneySources.description,
                                              @"requestId" : self.requestId,
                                              @"contractAmount" : self.contractAmount,
                                              @"balance" : self.balance,
                                              @"recipientAccountStatus" : [NSNumber numberWithInteger:self.recipientAccountStatus],
                                              @"recipientAccountType" : [NSNumber numberWithInteger:self.recipientAccountType],
                                              @"protectionCode" : self.protectionCode,
                                              @"extActionUri" : self.extActionUri.description
                                      }];
}

@end