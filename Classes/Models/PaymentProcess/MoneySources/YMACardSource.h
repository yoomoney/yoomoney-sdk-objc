//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAMoneySource.h"


/// Values for YMAPaymentCardType
/// Credit card type
typedef NS_ENUM(NSInteger, YMAPaymentCardType) {
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
};

///
/// This class contains info about the money source (type, cardType, panFragment, moneySourceToken).
///
@interface YMACardSource : YMAMoneySource

/// Constructor. Returns a YMACardSource with the specified money source type,
/// credit card type, PAN truncation and money source token.
/// @param type - The money source type.
/// @param cardType - The type of the credit card.
/// @param panFragment - PAN truncation.
/// @param moneySourceToken - Token for repeating payments.
+ (instancetype)moneySourceWithCardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken;
+ (instancetype)moneySourceWithCardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken cscRequired:(BOOL)cscRequired allowed:(BOOL)allowed;

@property(nonatomic, assign, readonly) YMAPaymentCardType cardType;
@property(nonatomic, copy, readonly) NSString *panFragment;
@property(nonatomic, copy, readonly) NSString *moneySourceToken;
@property(nonatomic, assign, readonly) BOOL isCscRequired;


@end