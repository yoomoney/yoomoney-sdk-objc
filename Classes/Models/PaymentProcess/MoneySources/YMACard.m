//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACard.h"
#import "YMAMoneySource.h"

static NSString *const kPaymentCardTypeVISA = @"VISA";
static NSString *const kPaymentCardTypeMasterCard = @"MasterCard";
static NSString *const kPaymentCardTypeAmericanExpress = @"AmericanExpress";
static NSString *const kPaymentCardTypeJCB = @"JCB";

@implementation YMACard

- (id)initWithCardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken {
    self = [super initWithSourceType:YMAMoneySourcePaymentCard];

    if (self) {
        _cardType = cardType;
        _panFragment = [panFragment copy];
        _moneySourceToken = [moneySourceToken copy];
    }

    return self;
}

+ (instancetype)cardSourceWithCardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken cscRequired:(BOOL)cscRequired allowed:(BOOL)allowed {
    return [[YMACard alloc] initWithCardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken];
}

+ (instancetype)moneySourceWithType:(YMAMoneySourceType)type cardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken {
    return [[YMACard alloc] initWithCardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken];
}

+ (YMAPaymentCardType)paymentCardTypeByString:(NSString *)string {
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

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"cardType" : [NSNumber numberWithInt:self.cardType],
                                              @"panFragment" : self.panFragment,
                                              @"moneySourceToken" : self.moneySourceToken
                                      }];
}

@end