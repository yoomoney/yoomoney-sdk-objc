//
//  YMAConstants.h
//  YandexMoneySDK
//
//  Created by mertvetcov on 29.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//
//
//
// Public Constants.

#import <Foundation/Foundation.h>

// p2p parameter name. Identifier the transfer recipient.
extern NSString *const kP2PPaymentParameterTo;

// p2p parameter name. Type identifier the transfer recipient. Optional.
// Default value - account number in the Yandex.Money.
extern NSString *const kP2PPaymentParameterIdentifierType;

// p2p parameter name. Amount to be deducted from a credit card.
extern NSString *const kP2PPaymentParameterAmount;

// p2p parameter name. Amount to be credited to the account of Yandex.Money.
extern NSString *const kP2PPaymentParameterAmountDue;

// Unknown error code.
extern NSString *const kErrorKeyUnknown;




