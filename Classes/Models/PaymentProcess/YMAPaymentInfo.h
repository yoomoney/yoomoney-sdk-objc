//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAMoneySources;

typedef NS_ENUM(NSInteger, YMAAccountStatus) {
    YMAAccountStatusAnonymous,
    YMAAccountStatusNamed,
    YMAAccountStatusIdentified
};

typedef NS_ENUM(NSInteger, YMAAccountType) {
    YMAAccountTypePersonal,
    YMAAccountTypeProfessional
};

@interface YMAPaymentInfo : NSObject

@property(nonatomic, copy, readonly) NSString *requestId;
@property(nonatomic, strong, readonly) YMAMoneySources *moneySources;
@property(nonatomic, copy, readonly) NSString *contractAmount;
@property(nonatomic, copy, readonly) NSString *balance;
@property(nonatomic, assign, readonly) YMAAccountStatus recipientAccountStatus;
@property(nonatomic, assign, readonly) YMAAccountType recipientAccountType;
@property(nonatomic, copy, readonly) NSString *protectionCode;
@property(nonatomic, copy, readonly) NSString *accountUnblockUri;
@property(nonatomic, copy, readonly) NSString *extActionUri;

+ (instancetype)paymentRequestInfoWithMoneySources:(YMAMoneySources *)moneySources requestId:(NSString *)requestId contractAmount:(NSString *)contractAmount balance:(NSString *)balance recipientAccountStatus:(YMAAccountStatus)recipientAccountStatus recipientAccountType:(YMAAccountType)recipientAccountType protectionCode:(NSString *)protectionCode accountUnblockUri:(NSString *)accountUnblockUri extActionUri:(NSString *)extActionUri;

@end