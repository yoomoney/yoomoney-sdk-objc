//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAccountInfoResponse.h"
#import "YMAMoneySourceModel.h"
#import "YMAConstants.h"

static NSString *const kParameterError = @"error";

static NSString *const kParameterAccount = @"account";
static NSString *const kParameterBalance = @"balance";
static NSString *const kParameterCurrency = @"currency";
static NSString *const kParameterAccountStatus = @"account_status";
static NSString *const kParameterAccountType = @"account_type";

static NSString *const kParameterAvatar = @"avatar";
static NSString *const kParameterAvatarUrl = @"url";
static NSString *const kParameterAvatarTs = @"ts";

static NSString *const kParameterBalanceDetails = @"balance_details";
static NSString *const kParameterBalanceTotal = @"total";
static NSString *const kParameterBalanceAvailable = @"available";
static NSString *const kParameterBalanceDepositionPending = @"deposition_pending";
static NSString *const kParameterBalanceBlocked = @"blocked";
static NSString *const kParameterBalanceDebt = @"debt";

static NSString *const kParameterCardsLinked = @"cards_linked";
static NSString *const kParameterCardsLinkedPanFragment = @"pan_fragment";
static NSString *const kParameterCardsLinkedType = @"type";

static NSString *const kParameterServicesAdditional = @"services_additional";

@implementation YMAAccountInfoResponse

#pragma mark - Overridden methods

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error
{
    NSString *errorKey = [responseModel objectForKey:kParameterError];

    if (errorKey != nil) {
        if (error == nil) return NO;

        NSError *unknownError = [NSError errorWithDomain:YMAErrorDomainUnknown code:0 userInfo:@{ YMAErrorKeyResponse : self }];
        *error = errorKey ? [NSError errorWithDomain:YMAErrorDomainYaMoneyAPI code:0 userInfo:@{YMAErrorKey : errorKey, YMAErrorKeyResponse : self }] : unknownError;

        return NO;
    }

    NSString *account = [responseModel objectForKey:kParameterAccount];
    NSString *balance = [[responseModel objectForKey:kParameterBalance] stringValue];
    NSString *currency = [responseModel objectForKey:kParameterCurrency];

    NSString *accountStatusString = [responseModel objectForKey:kParameterAccountStatus];
    YMAAccountStatus accountStatus = [YMAAccountInfoModel accountStatusByString:accountStatusString];

    NSString *accountTypeString = [responseModel objectForKey:kParameterAccountType];
    YMAAccountType accountType = [YMAAccountInfoModel accountTypeByString:accountTypeString];

    id avatarModel = [responseModel objectForKey:kParameterAvatar];
    YMAAvatarModel *avatar = nil;

    if (avatarModel != nil) {
        NSString *avatarUrlString = [avatarModel objectForKey:kParameterAvatarUrl];
        NSURL *avatarUrl = [NSURL URLWithString:avatarUrlString];
        NSString *timeStampString = [avatarModel objectForKey:kParameterAvatarTs];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
        NSDate *timeStamp = [formatter dateFromString:timeStampString];
        avatar = [YMAAvatarModel avatarWithUrl:avatarUrl timeStamp:timeStamp];
    }

    id balanceDetailsModel = [responseModel objectForKey:kParameterBalanceDetails];
    YMABalanceDetailsModel *balanceDetails = nil;

    if (balanceDetailsModel != nil) {
        NSString *total = [[balanceDetailsModel objectForKey:kParameterBalanceTotal] stringValue];
        NSString *available = [[balanceDetailsModel objectForKey:kParameterBalanceAvailable] stringValue];
        NSString *depositionPending = [[balanceDetailsModel objectForKey:kParameterBalanceDepositionPending] stringValue];
        NSString *blocked = [[balanceDetailsModel objectForKey:kParameterBalanceBlocked] stringValue];
        NSString *debt = [[balanceDetailsModel objectForKey:kParameterBalanceDebt] stringValue];

        balanceDetails = [YMABalanceDetailsModel balanceDetailsWithTotal:total
                                                               available:available
                                                       depositionPending:depositionPending
                                                                 blocked:blocked
                                                                    debt:debt];
    }

    id cardsLinkedModel = [responseModel objectForKey:kParameterCardsLinked];
    NSMutableArray *cardsLinked = nil;

    if (cardsLinkedModel != nil) {
        cardsLinked = [NSMutableArray array];

        for (id card in cardsLinkedModel) {
            NSString *panFragment = [card objectForKey:kParameterCardsLinkedPanFragment];
            NSString *cardTypeString = [card objectForKey:kParameterCardsLinkedType];
            YMAPaymentCardType cardType = [YMAMoneySourceModel paymentCardTypeByString:cardTypeString];
            [cardsLinked addObject:[YMAMoneySourceModel moneySourceWithType:YMAMoneySourcePaymentCard
                                                                   cardType:cardType
                                                                panFragment:panFragment
                                                           moneySourceToken:nil]];
        }
    }

    id servicesAdditionalModel = [responseModel objectForKey:kParameterServicesAdditional];
    NSMutableArray *servicesAdditional = nil;

    if (servicesAdditionalModel != nil) {
        servicesAdditional = [NSMutableArray array];

        for (NSString *service in servicesAdditionalModel)
            [servicesAdditional addObject:service];
    }

    _accountInfo = [YMAAccountInfoModel accountInfoWithAccount:account
                                                       balance:balance
                                                      currency:currency
                                                 accountStatus:accountStatus
                                                   accountType:accountType
                                                        avatar:avatar
                                                balanceDetails:balanceDetails
                                                   cardsLinked:cardsLinked
                                            servicesAdditional:servicesAdditional];

    return YES;
}

@end