//
// Created by Александр Мертвецов on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAProcessPaymentResponse.h"
#import "YMAPaymentResultInfo.h"
#import "YMAAsc.h"
#import "YMADigitalGoods.h"
#import "YMAGoods.h"

static NSString *const kParameterPaymentId = @"payment_id";
static NSString *const kParameterBalance = @"balance";
static NSString *const kParameterInvoiceId = @"invoice_id";
static NSString *const kParameterPayer = @"payer";
static NSString *const kParameterPayee = @"payee";
static NSString *const kParameterCreditAmount = @"credit_amount";
static NSString *const kParameterPayeeUid = @"payee_uid";
static NSString *const kParameterHoldForPickupLink = @"hold_for_pickup_link";
static NSString *const kParameterAcsUri = @"acs_uri";
static NSString *const kParameterAcsParams = @"acs_params";

static NSString *const kParameterDigitalGoods = @"digital_goods";
static NSString *const kParameterDigitalGoodsArticle = @"article";
static NSString *const kParameterDigitalGoodsBonus = @"bonus";
static NSString *const kParameterDigitalGoodsMerchantArticleId = @"merchantArticleId";
static NSString *const kParameterDigitalGoodsSerial = @"serial";
static NSString *const kParameterDigitalGoodsSecret = @"secret";

@implementation YMAProcessPaymentResponse

+ (NSArray *)goodsByModel:(id)goodsModel {
    if (!goodsModel)
        return nil;

    NSMutableArray *goods = [NSMutableArray array];

    for (id article in goodsModel) {
        NSString *merchantArticleId = [article objectForKey:kParameterDigitalGoodsMerchantArticleId];
        NSString *serial = [article objectForKey:kParameterDigitalGoodsSerial];
        NSString *secret = [article objectForKey:kParameterDigitalGoodsSecret];
        [goods addObject:[YMAGoods goodsWithId:merchantArticleId serial:serial secret:secret]];
    }

    return goods;
}


#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    [super parseJSONModel:responseModel error:error];

    if (error && *error) return;

    NSString *paymentId = [responseModel objectForKey:kParameterPaymentId];
    NSString *balance = [[responseModel objectForKey:kParameterBalance] stringValue];
    NSString *invoiceId = [responseModel objectForKey:kParameterInvoiceId];
    NSString *payer = [responseModel objectForKey:kParameterPayer];
    NSString *creditAmount = [[responseModel objectForKey:kParameterCreditAmount] stringValue];
    NSString *payeeUid = [responseModel objectForKey:kParameterPayeeUid];
    NSString *payee = [responseModel objectForKey:kParameterPayee];
    NSString *holdForPickupLinkString = [responseModel objectForKey:kParameterHoldForPickupLink];
    NSURL *holdForPickupLink = [NSURL URLWithString:holdForPickupLinkString];

    NSString *acsUrl = [responseModel objectForKey:kParameterAcsUri];
    YMAAsc *asc = nil;

    if (acsUrl) {
        NSDictionary *acsParams = [responseModel objectForKey:kParameterAcsParams];
        asc = [YMAAsc ascWithUrl:[NSURL URLWithString:acsUrl] andParams:acsParams];
    }

    id digitalGoodsModel = [responseModel objectForKey:kParameterDigitalGoods];
    YMADigitalGoods *digitalGoods = nil;

    if (digitalGoodsModel) {
        NSArray *articleModel = [digitalGoodsModel objectForKey:kParameterDigitalGoodsArticle];
        NSArray *article = [YMAProcessPaymentResponse goodsByModel:articleModel];

        NSArray *bonusModel = [digitalGoodsModel objectForKey:kParameterDigitalGoodsBonus];
        NSArray *bonus = [YMAProcessPaymentResponse goodsByModel:bonusModel];

        digitalGoods = [YMADigitalGoods digitalGoodsWithArticle:article bonus:bonus];
    }

    _paymentResultInfo = [YMAPaymentResultInfo paymentResultWithPaymentId:paymentId balance:balance invoiceId:invoiceId payer:payer payee:payee creditAmount:creditAmount payeeUid:payeeUid holdForPickupLink:holdForPickupLink asc:asc digitalGoods:digitalGoods];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"paymentInfo" : self.paymentResultInfo.description
                                      }];
}

@end