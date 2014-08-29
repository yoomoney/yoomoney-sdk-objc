//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAMoneySourceModel.h"

static NSString *const kPaymentCardTypeVISA = @"VISA";
static NSString *const kPaymentCardTypeMasterCard = @"MasterCard";
static NSString *const kPaymentCardTypeAmericanExpress = @"AmericanExpress";
static NSString *const kPaymentCardTypeJCB = @"JCB";

@implementation YMAMoneySourceModel

#pragma mark - Object Lifecycle

- (id)initWithType:(YMAMoneySourceType)type
          cardType:(YMAPaymentCardType)cardType
       panFragment:(NSString *)panFragment
  moneySourceToken:(NSString *)moneySourceToken
{
    self = [super init];

    if (self != nil) {
        _type = type;
        _cardType = cardType;
        _panFragment = [panFragment copy];
        _moneySourceToken = [moneySourceToken copy];
    }

    return self;
}

+ (instancetype)moneySourceWithType:(YMAMoneySourceType)type
                           cardType:(YMAPaymentCardType)cardType
                        panFragment:(NSString *)panFragment
                   moneySourceToken:(NSString *)moneySourceToken
{
    return [[YMAMoneySourceModel alloc] initWithType:type
                                            cardType:cardType
                                         panFragment:panFragment
                                    moneySourceToken:moneySourceToken];
}

#pragma mark - Public methods

+ (YMAPaymentCardType)paymentCardTypeByString:(NSString *)string
{
    if ([string isEqual:kPaymentCardTypeVISA])
        return YMAPaymentCardTypeVISA;

    if ([string isEqual:kPaymentCardTypeMasterCard])
        return YMAPaymentCardTypeMasterCard;

    if ([string isEqual:kPaymentCardTypeAmericanExpress])
        return YMAPaymentCardTypeAmericanExpress;

    if ([string isEqual:kPaymentCardTypeJCB])
        return YMAPaymentCardTypeJCB;

    return YMAPaymentCardUnknown;
}

@end