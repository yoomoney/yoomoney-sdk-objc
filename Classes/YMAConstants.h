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

/// Values for AXRequestMethod
/// Request method
typedef NS_ENUM(NSInteger, YMARequestMethod) {
    YMARequestMethodPost,
    YMARequestMethodGet
};

// p2p parameter name. Identifier the transfer recipient.
extern NSString *const YMAP2PPaymentParameterTo;

// p2p parameter name. Payment message to the recipient.
extern NSString *const YMAP2PPaymentParameterMessage;

// p2p parameter name. Payment comment.
extern NSString *const YMAP2PPaymentParameterComment;

// p2p parameter name. Amount to be deducted from a credit card.
extern NSString *const YMAP2PPaymentParameterAmount;

// p2p parameter name. Amount to be credited to the account of Yandex.Money.
extern NSString *const YMAP2PPaymentParameterAmountDue;

// p2p parameter name. Not required.
extern NSString *const YMAP2PPaymentParameterLabel;

// payment parameter patternId
extern NSString *const YMAPaymentParameterPatternId;

// API error.
extern NSString *const YMAErrorDomainYaMoneyAPI;

// Unknown error.
extern NSString *const YMAErrorDomainUnknown;

// OAuth error.
extern NSString *const YMAErrorDomainOAuth;

// Error key.
extern NSString *const YMAErrorKey;

// Response error key.
extern NSString *const YMAErrorKeyResponse;

// Request error key.
extern NSString *const YMAErrorKeyRequest;

// Redirect uri.
extern NSString *const YMAParameterRedirectUri;

// Scope.
extern NSString *const YMAParameterScope;

// Header constant = "Content-Type".
extern NSString *const YMAHeaderContentType;

//API Error code - technical_error
extern NSString *const YMATechnicalErrorCode;

//API Error code - illegal_param_request_id
extern NSString *const YMAIllegalParamRequestIdCode;

//API Error code - illegal_param_id
extern NSString *const YMAIllegalParamIdCode;

//API Error code - illegal_params
extern NSString *const YMAIllegalParams;

//API Error code - illegal_param_device_id
NSString *const YMAIllegalParamDeviceIdCode;

//API Error code - already_exists
NSString *const YMAAlreadyExistsCode;

//API Error code - limit_exceeded
NSString *const YMALimitExceededCode;
