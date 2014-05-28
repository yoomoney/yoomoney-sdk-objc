//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentResultInfo.h"
#import "YMAAsc.h"
#import "YMADigitalGoods.h"


@implementation YMAPaymentResultInfo

- (id)initWithPaymentId:(NSString *)paymentId balance:(NSString *)balance invoiceId:(NSString *)invoiceId payer:(NSString *)payer payee:(NSString *)payee creditAmount:(NSString *)creditAmount payeeUid:(NSString *)payeeUid holdForPickupLink:(NSURL *)holdForPickupLink asc:(YMAAsc *)asc digitalGoods:(YMADigitalGoods *)digitalGoods {
    self = [super init];

    if (self) {
        _paymentId = [paymentId copy];
        _balance = [balance copy];
        _invoiceId = [invoiceId copy];
        _payer = [payer copy];
        _payee = [payee copy];
        _creditAmount = [creditAmount copy];
        _payeeUid = [payeeUid copy];
        _holdForPickupLink = holdForPickupLink;
        _asc = asc;
        _digitalGoods = digitalGoods;
    }

    return self;
}

+ (instancetype)paymentResultWithPaymentId:(NSString *)paymentId balance:(NSString *)balance invoiceId:(NSString *)invoiceId payer:(NSString *)payer payee:(NSString *)payee creditAmount:(NSString *)creditAmount payeeUid:(NSString *)payeeUid holdForPickupLink:(NSURL *)holdForPickupLink asc:(YMAAsc *)asc digitalGoods:(YMADigitalGoods *)digitalGoods {
    return [[YMAPaymentResultInfo alloc] initWithPaymentId:paymentId balance:balance invoiceId:invoiceId payer:payer payee:payee creditAmount:creditAmount payeeUid:payeeUid holdForPickupLink:holdForPickupLink asc:asc digitalGoods:digitalGoods];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"paymentId" : self.paymentId,
                                              @"balance" : self.balance,
                                              @"invoiceId" : self.invoiceId,
                                              @"payer" : self.payer,
                                              @"payee" : self.payee,
                                              @"creditAmount" : self.creditAmount,
                                              @"payeeUid" : self.payeeUid,
                                              @"holdForPickupLink" : self.holdForPickupLink.description,
                                              @"asc" : self.asc.description,
                                              @"digitalGoods" : self.digitalGoods.description
                                      }];
}


@end