//
// Created by mertvetcov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAccountInfo.h"
#import "YMAAvatar.h"
#import "YMABalanceDetails.h"

static NSString *const kKeyAccountStatusAnonymous = @"anonymous";
static NSString *const kKeyAccountStatusNamed = @"named";
static NSString *const kKeyAccountStatusIdentified = @"identified";

static NSString *const kKeyAccountTypePersonal = @"personal";
static NSString *const kKeyAccountTypeProfessional = @"professional";

@implementation YMAAccountInfo

- (id)initWithAccount:(NSString *)account balance:(NSString *)balance currency:(NSString *)currency accountStatus:(YMAAccountStatus)accountStatus accountType:(YMAAccountType)accountType avatar:(YMAAvatar *)avatar balanceDetails:(YMABalanceDetails *)balanceDetails cardsLinked:(NSArray *)cardsLinked servicesAdditional:(NSArray *)servicesAdditional {
    self = [super init];

    if (self) {
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

+ (instancetype)accountInfoWithAccount:(NSString *)account balance:(NSString *)balance currency:(NSString *)currency accountStatus:(YMAAccountStatus)accountStatus accountType:(YMAAccountType)accountType avatar:(YMAAvatar *)avatar balanceDetails:(YMABalanceDetails *)balanceDetails cardsLinked:(NSArray *)cardsLinked servicesAdditional:(NSArray *)servicesAdditional {
    return [[YMAAccountInfo alloc] initWithAccount:account balance:balance currency:currency accountStatus:accountStatus accountType:accountType avatar:avatar balanceDetails:balanceDetails cardsLinked:cardsLinked servicesAdditional:servicesAdditional];
}

+ (YMAAccountStatus)accountStatusByString:(NSString *)accountStatusString {
    if ([accountStatusString isEqual:kKeyAccountStatusAnonymous])
        return YMAAccountStatusAnonymous;
    else if ([accountStatusString isEqual:kKeyAccountStatusIdentified])
        return YMAAccountStatusIdentified;
    else if ([accountStatusString isEqual:kKeyAccountStatusNamed])
        return YMAAccountStatusNamed;

    return YMAAccountStatusUnknown;
}

+ (YMAAccountType)accountTypeByString:(NSString *)accountTypeString {
    if ([accountTypeString isEqual:kKeyAccountTypePersonal])
        return YMAAccountTypePersonal;
    else if ([accountTypeString isEqual:kKeyAccountTypeProfessional])
        return YMAAccountTypeProfessional;

    return YMAAccountTypeUnknown;
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"account" : self.account,
                                              @"balance" : self.balance,
                                              @"currency" : self.currency,
                                              @"accountStatus" : [NSNumber numberWithInteger:self.accountStatus],
                                              @"accountType" : [NSNumber numberWithInteger:self.accountType],
                                              @"avatar" : self.avatar.description,
                                              @"balanceDetails" : self.balanceDetails.description,
                                              @"cardsLinked" : self.cardsLinked.description,
                                              @"servicesAdditional" : self.servicesAdditional.description
                                      }];
}

@end