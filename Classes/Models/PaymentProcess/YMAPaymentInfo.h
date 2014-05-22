//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAMoneySources;

typedef NS_ENUM(NSInteger, YMAAccountStatus) {
    YMAAccountStatusUnknown,
    YMAAccountStatusAnonymous,
    YMAAccountStatusNamed,
    YMAAccountStatusIdentified
};

typedef NS_ENUM(NSInteger, YMAAccountType) {
    YMAAccountTypeUnknown,
    YMAAccountTypePersonal,
    YMAAccountTypeProfessional
};

@interface YMAPaymentInfo : NSObject

+ (instancetype)paymentInfoWithMoneySources:(YMAMoneySources *)moneySources requestId:(NSString *)requestId contractAmount:(NSString *)contractAmount balance:(NSString *)balance recipientAccountStatus:(YMAAccountStatus)recipientAccountStatus recipientAccountType:(YMAAccountType)recipientAccountType protectionCode:(NSString *)protectionCode extActionUri:(NSString *)extActionUri;

@property(nonatomic, copy, readonly) NSString *requestId;
@property(nonatomic, strong, readonly) YMAMoneySources *moneySources;
@property(nonatomic, copy, readonly) NSString *contractAmount;
@property(nonatomic, copy, readonly) NSString *balance;
@property(nonatomic, assign, readonly) YMAAccountStatus recipientAccountStatus;
@property(nonatomic, assign, readonly) YMAAccountType recipientAccountType;
@property(nonatomic, copy, readonly) NSString *protectionCode;
@property(nonatomic, copy, readonly) NSString *extActionUri;

@end