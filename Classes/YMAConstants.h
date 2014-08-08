//
//  YMAConstants.h
//  YandexMoneySDK
//
//  Created by Alexander Mertvetsov on 29.01.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//
//
//
// Public Constants.

#import <Foundation/Foundation.h>

// p2p parameter name. Identifier the transfer recipient.
extern NSString *const YMAP2PPaymentParameterTo;

// p2p parameter name. Comments for payment, displayed to the recipient.
extern NSString *const YMAP2PPaymentParameterMessage;

// p2p parameter name. Amount to be deducted from a credit card.
extern NSString *const YMAP2PPaymentParameterAmount;

// p2p parameter name. Amount to be credited to the account of Yandex.Money.
extern NSString *const YMAP2PPaymentParameterAmountDue;

// Unknown error code.
extern NSString *const YMAErrorKeyUnknown;

// Redirect uri
extern NSString *const YMAParameterRedirectUri;

// Scope
extern NSString *const YMAParameterScope;

// Header constant = "Content-Type".
extern NSString *const YMAHeaderContentType;


