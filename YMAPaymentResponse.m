//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAPaymentResponse.h"
#import "YMAPaymentInfo.h"
#import "YMAMoneySources.h"
#import "YMAWalletSource.h"
#import "YMACardSource.h"

static NSString *const kParameterRequestId = @"request_id";
static NSString *const kParameterMoneySource = @"money_source";
static NSString *const kParameterContractAmount = @"contract_amount";
static NSString *const kParameterBalance = @"balance";
static NSString *const kParameterRecipientAccountStatus = @"recipient_account_status";
static NSString *const kParameterRecipientAccountType = @"recipient_account_type";
static NSString *const kParameterProtectionCode = @"protection_code";
static NSString *const kParameterExtActionUri = @"ext_action_uri";
static NSString *const kParameterMoneySourceWallet = @"wallet";
static NSString *const kParameterMoneySourceCard = @"card";
static NSString *const kParameterMoneySourceCards = @"сards";
static NSString *const kParameterMoneySourceItems = @"items";
static NSString *const kParameterMoneySourceId = @"id";
static NSString *const kParameterMoneySourcePanFragment = @"pan_fragment";
static NSString *const kParameterMoneySourceType = @"type";
static NSString *const kParameterMoneySourceAllowed = @"allowed";
static NSString *const kParameterMoneySourceCscRequired = @"csc_required";

static NSString *const kKeyAccountStatusAnonymous = @"anonymous";
static NSString *const kKeyAccountStatusNamed = @"named";
static NSString *const kKeyAccountStatusIdentified = @"identified";

static NSString *const kKeyAccountTypePersonal = @"personal";
static NSString *const kKeyAccountTypeProfessional = @"professional";

@implementation YMAPaymentResponse

+ (YMAAccountStatus)accountStatusByString:(NSString *)accountStatusString {
    if ([accountStatusString isEqual:kKeyAccountStatusAnonymous])
        return YMAAccountStatusAnonymous;
    else if ([accountStatusString isEqual:kKeyAccountStatusIdentified])
        return YMAAccountStatusIdentified;
    else if ([accountStatusString isEqual:kKeyAccountStatusNamed])
        return YMAAccountStatusNamed;

    return YMAAccountStatusUnknown;
}

+ (YMAAccountType)accountTypeByString:(NSString *)accountTypeString {
    if ([accountTypeString isEqual:kKeyAccountTypePersonal])
        return YMAAccountTypePersonal;
    else if ([accountTypeString isEqual:kKeyAccountTypeProfessional])
        return YMAAccountTypeProfessional;

    return YMAAccountTypeUnknown;
}

+ (YMAMoneySources *)moneySourcesFromModel:(id)moneySourcesModel {
    if (!moneySourcesModel)
        return nil;

    id walletModel = [moneySourcesModel objectForKey:kParameterMoneySourceWallet];
    BOOL walletAllowed = (walletModel) ? [[walletModel objectForKey:kParameterMoneySourceAllowed] boolValue] : NO;

    YMAWalletSource *wallet = [YMAWalletSource walletMoneySourceWithAllowed:walletAllowed];

    id defaultCardModel = [moneySourcesModel objectForKey:kParameterMoneySourceCard];
    NSString *defaultCardId = (defaultCardModel) ? [defaultCardModel objectForKey:kParameterMoneySourceId] : nil;

    YMACardSource *defaultCard = nil;
    NSMutableArray *cards = [NSMutableArray array];
    id cardsModel = [moneySourcesModel objectForKey:kParameterMoneySourceCards];
    YMAMoneySources *defaultMoneySources = [YMAMoneySources moneySourcesWithWallet:wallet cards:cards andDefaultCard:nil];

    if (!cardsModel)
        return defaultMoneySources;

    BOOL cardsAllowed = [[cardsModel objectForKey:kParameterMoneySourceAllowed] boolValue];
    BOOL isCscRequired = [[cardsModel objectForKey:kParameterMoneySourceCscRequired] boolValue];

    NSArray *cardsModelItems = [cardsModel objectForKey:kParameterMoneySourceItems];

    if (!cardsModelItems)
        return defaultMoneySources;

    for (id cardModel in cardsModelItems) {
        NSString *cardId = [cardModel objectForKey:kParameterMoneySourceId];
        NSString *panFragment = [cardModel objectForKey:kParameterMoneySourcePanFragment];
        NSString *cardTypeString = [cardModel objectForKey:kParameterMoneySourceType];
        YMAPaymentCardType cardType = [YMACardSource paymentCardTypeByString:cardTypeString];
        YMACardSource *card = [YMACardSource cardSourceWithCardType:cardType panFragment:panFragment moneySourceToken:cardId cscRequired:isCscRequired allowed:cardsAllowed];
        if ([cardId isEqualToString:defaultCardId])
            defaultCard = card;
        [cards addObject:card];
    }

    defaultCard = (defaultCard) ? defaultCard : (cards.count ? cards[0] : nil);

    return [YMAMoneySources moneySourcesWithWallet:wallet cards:cards andDefaultCard:defaultCard];
}


#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    [super parseJSONModel:responseModel];

    NSString *requestId = [responseModel objectForKey:kParameterRequestId];
    NSString *contractAmount = [[responseModel objectForKey:kParameterContractAmount] stringValue];
    NSString *balance = [[responseModel objectForKey:kParameterBalance] stringValue];

    NSString *accountStatusString = [responseModel objectForKey:kParameterRecipientAccountStatus];
    YMAAccountStatus accountStatus = [YMAPaymentResponse accountStatusByString:accountStatusString];

    NSString *accountTypeString = [responseModel objectForKey:kParameterRecipientAccountType];
    YMAAccountType accountType = [YMAPaymentResponse accountTypeByString:accountTypeString];

    NSString *protectionCode = [responseModel objectForKey:kParameterProtectionCode];
    NSString *extActionUri = [responseModel objectForKey:kParameterExtActionUri];

    id moneySourcesModel = [responseModel objectForKey:kParameterMoneySource];
    YMAMoneySources *moneySources = [YMAPaymentResponse moneySourcesFromModel:moneySourcesModel];

    _paymentInfo = [YMAPaymentInfo paymentInfoWithMoneySources:moneySources requestId:requestId contractAmount:contractAmount balance:balance recipientAccountStatus:accountStatus recipientAccountType:accountType protectionCode:protectionCode extActionUri:extActionUri];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"paymentInfo" : self.paymentInfo.description
                                      }];
}

@end