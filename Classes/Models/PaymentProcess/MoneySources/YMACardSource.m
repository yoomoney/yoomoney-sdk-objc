//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACardSource.h"
#import "YMAMoneySource.h"

@implementation YMACardSource

- (id)initWithCardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken cscRequired:(BOOL)cscRequired allowed:(BOOL)allowed {
    self = [super initWithSourceType:YMAMoneySourcePaymentCard allowed:allowed];

    if (self) {
        _cardType = cardType;
        _panFragment = [panFragment copy];
        _moneySourceToken = [moneySourceToken copy];
        _isCscRequired = cscRequired;
    }

    return self;
}

+ (instancetype)moneySourceWithCardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken cscRequired:(BOOL)cscRequired allowed:(BOOL)allowed {
    return [[YMACardSource alloc] initWithCardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken cscRequired:cscRequired allowed:allowed];
}

+ (instancetype)moneySourceWithType:(YMAMoneySourceType)type cardType:(YMAPaymentCardType)cardType panFragment:(NSString *)panFragment moneySourceToken:(NSString *)moneySourceToken {
    return [[YMACardSource alloc] initWithCardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken cscRequired:NO allowed:YES];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"type" : [NSNumber numberWithInt:self.type],
                                              @"cardType" : [NSNumber numberWithInt:self.cardType],
                                              @"panFragment" : self.panFragment,
                                              @"moneySourceToken" : self.moneySourceToken,
                                              @"isCscRequired" : (self.isCscRequired) ? @"YES" : @"NO",
                                              @"isAllowed" : (self.isAllowed) ? @"YES" : @"NO"
                                      }];
}

@end