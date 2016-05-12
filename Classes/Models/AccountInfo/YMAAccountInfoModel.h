//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAAvatarModel.h"
#import "YMABalanceDetailsModel.h"

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

@interface YMAAccountInfoModel : NSObject

+ (instancetype)accountInfoWithAccount:(NSString *)account
                               balance:(NSString *)balance
                              currency:(NSString *)currency
                         accountStatus:(YMAAccountStatus)accountStatus
                           accountType:(YMAAccountType)accountType
                                avatar:(YMAAvatarModel *)avatar
                        balanceDetails:(YMABalanceDetailsModel *)balanceDetails
                           cardsLinked:(NSArray *)cardsLinked
                    servicesAdditional:(NSArray *)servicesAdditional
                          yamoneyCards:(NSArray *)yamoneyCards;

+ (YMAAccountStatus)accountStatusByString:(NSString *)accountStatusString;

+ (YMAAccountType)accountTypeByString:(NSString *)accountTypeString;

@property (nonatomic, copy, readonly) NSString *account;
@property (nonatomic, copy, readonly) NSString *balance;
@property (nonatomic, copy, readonly) NSString *currency;
@property (nonatomic, assign, readonly) YMAAccountStatus accountStatus;
@property (nonatomic, assign, readonly) YMAAccountType accountType;
@property (nonatomic, strong, readonly) YMAAvatarModel *avatar;
@property (nonatomic, strong, readonly) YMABalanceDetailsModel *balanceDetails;
@property (nonatomic, strong, readonly) NSArray *cardsLinked;
@property (nonatomic, strong, readonly) NSArray *servicesAdditional;
@property (nonatomic, strong, readonly) NSArray *yamoneyCards;

@end