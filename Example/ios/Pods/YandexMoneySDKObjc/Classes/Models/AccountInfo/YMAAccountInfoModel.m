//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAccountInfoModel.h"

static NSString *const kKeyAccountStatusAnonymous = @"anonymous";
static NSString *const kKeyAccountStatusNamed = @"named";
static NSString *const kKeyAccountStatusIdentified = @"identified";

static NSString *const kKeyAccountTypePersonal = @"personal";
static NSString *const kKeyAccountTypeProfessional = @"professional";

@implementation YMAAccountInfoModel

#pragma mark - Object Lifecycle

- (id)initWithAccount:(NSString *)account
              balance:(NSString *)balance
             currency:(NSString *)currency
        accountStatus:(YMAAccountStatus)accountStatus
          accountType:(YMAAccountType)accountType
               avatar:(YMAAvatarModel *)avatar
       balanceDetails:(YMABalanceDetailsModel *)balanceDetails
          cardsLinked:(NSArray *)cardsLinked
   servicesAdditional:(NSArray *)servicesAdditional
{
    self = [super init];

    if (self != nil) {
        _account = [account copy];
        _balance = [balance copy];
        _currency = [currency copy];
        _accountStatus = accountStatus;
        _accountType = accountType;
        _avatar = avatar;
        _balanceDetails = balanceDetails;
        _cardsLinked = cardsLinked;
        _servicesAdditional = servicesAdditional;
    }

    return self;
}

+ (instancetype)accountInfoWithAccount:(NSString *)account
                               balance:(NSString *)balance
                              currency:(NSString *)currency
                         accountStatus:(YMAAccountStatus)accountStatus
                           accountType:(YMAAccountType)accountType
                                avatar:(YMAAvatarModel *)avatar
                        balanceDetails:(YMABalanceDetailsModel *)balanceDetails
                           cardsLinked:(NSArray *)cardsLinked
                    servicesAdditional:(NSArray *)servicesAdditional
{
    return [[YMAAccountInfoModel alloc] initWithAccount:account
                                                balance:balance
                                               currency:currency
                                          accountStatus:accountStatus
                                            accountType:accountType
                                                 avatar:avatar
                                         balanceDetails:balanceDetails
                                            cardsLinked:cardsLinked
                                     servicesAdditional:servicesAdditional];
}

#pragma mark - Public methods

+ (YMAAccountStatus)accountStatusByString:(NSString *)accountStatusString
{
    if ([accountStatusString isEqual:kKeyAccountStatusAnonymous])
        return YMAAccountStatusAnonymous;
    else if ([accountStatusString isEqual:kKeyAccountStatusIdentified])
        return YMAAccountStatusIdentified;
    else if ([accountStatusString isEqual:kKeyAccountStatusNamed])
        return YMAAccountStatusNamed;

    return YMAAccountStatusUnknown;
}

+ (YMAAccountType)accountTypeByString:(NSString *)accountTypeString
{
    if ([accountTypeString isEqual:kKeyAccountTypePersonal])
        return YMAAccountTypePersonal;
    else if ([accountTypeString isEqual:kKeyAccountTypeProfessional])
        return YMAAccountTypeProfessional;

    return YMAAccountTypeUnknown;
}

@end