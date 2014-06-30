//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@class YMAAvatar;
@class YMABalanceDetails;

@interface YMAAccountInfo : NSObject

+ (instancetype)accountInfoWithAccount:(NSString *)account balance:(NSString *)balance currency:(NSString *)currency accountStatus:(YMAAccountStatus)accountStatus accountType:(YMAAccountType)accountType avatar:(YMAAvatar *)avatar balanceDetails:(YMABalanceDetails *)balanceDetails cardsLinked:(NSArray *)cardsLinked servicesAdditional:(NSArray *)servicesAdditional;

+ (YMAAccountStatus)accountStatusByString:(NSString *)accountStatusString;

+ (YMAAccountType)accountTypeByString:(NSString *)accountTypeString;

@property(nonatomic, copy, readonly) NSString *account;
@property(nonatomic, copy, readonly) NSString *balance;
@property(nonatomic, copy, readonly) NSString *currency;
@property(nonatomic, assign, readonly) YMAAccountStatus accountStatus;
@property(nonatomic, assign, readonly) YMAAccountType accountType;
@property(nonatomic, strong, readonly) YMAAvatar *avatar;
@property(nonatomic, strong, readonly) YMABalanceDetails *balanceDetails;
@property(nonatomic, strong, readonly) NSArray *cardsLinked;
@property(nonatomic, strong, readonly) NSArray *servicesAdditional;

@end