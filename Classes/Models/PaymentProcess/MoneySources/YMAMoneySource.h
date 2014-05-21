//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Values for YMAMoneySourceType
typedef NS_ENUM(NSInteger, YMAMoneySourceType) {
    /// Unknown money source
            YMAMoneySourceUnknown,
    /// Credit card
            YMAMoneySourcePaymentCard,
    /// Wallet
            YMAMoneySourceWallet
};

@interface YMAMoneySource : NSObject

- (id)initWithSourceType:(YMAMoneySourceType)type;

@property(nonatomic, assign, readonly) YMAMoneySourceType type;

@end