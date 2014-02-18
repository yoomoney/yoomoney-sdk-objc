//
// Created by Александр Мертвецов on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Values for YMAMoneySourceType
typedef enum {
    /// Unknown money source
            YMAMoneySourceUnknown,
    /// Credit card
            YMAMoneySourcePaymentCard
} YMAMoneySourceType;

/// Values for YMAPaymentCardType
/// Credit card type
typedef enum {
    /// Unknown credit card
            YMAPaymentCardUnknown,
    /// VISA
            YMAPaymentCardTypeVISA,
    /// MasterCard
            YMAPaymentCardTypeMasterCard,
    /// American Express
            YMAPaymentCardTypeAmericanExpress,
    /// JCB
            YMAPaymentCardTypeJCB
} YMAPaymentCardType;

///
/// This class contains info about the money source (type, cardType, panFragment, moneySourceToken).
///
@interface YMAMoneySource : NSObject

/// Constructor. Returns a YMAMoneySource with the specified money source type,
/// credit card type, PAN truncation and money source token.
/// @param type - The money source type.
/// @param cardType - The type of the credit card.
/// @param panFragment - PAN truncation.
/// @param moneySourceToken - Token for repeating payments.
+ (instancetype)moneySourceWithType:(YMAMoneySourceType)type cardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken;

@property(nonatomic, assign, readonly) YMAMoneySourceType type;
@property(nonatomic, assign, readonly) YMAPaymentCardType cardType;
@property(nonatomic, copy, readonly) NSString *panFragment;
@property(nonatomic, copy, readonly) NSString *moneySourceToken;

@end