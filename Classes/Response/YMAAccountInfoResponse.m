//
// Created by Alexander Mertvetsov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAAccountInfoResponse.h"
#import "YMAAccountInfo.h"
#import "YMAAvatar.h"
#import "YMABalanceDetails.h"
#import "YMAMoneySource.h"

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

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    NSString *account = [responseModel objectForKey:kParameterAccount];
    NSString *balance = [[responseModel objectForKey:kParameterBalance] stringValue];
    NSString *currency = [responseModel objectForKey:kParameterCurrency];

    NSString *accountStatusString = [responseModel objectForKey:kParameterAccountStatus];
    YMAAccountStatus accountStatus = [YMAAccountInfo accountStatusByString:accountStatusString];

    NSString *accountTypeString = [responseModel objectForKey:kParameterAccountType];
    YMAAccountType accountType = [YMAAccountInfo accountTypeByString:accountTypeString];

    id avatarModel = [responseModel objectForKey:kParameterAvatar];
    YMAAvatar *avatar = nil;

    if (avatarModel) {
        NSString *avatarUrlString = [avatarModel objectForKey:kParameterAvatarUrl];
        NSURL *avatarUrl = [NSURL URLWithString:avatarUrlString];
        NSString *timeStampString = [avatarModel objectForKey:kParameterAvatarTs];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-DDThh:mm:ss.fZZZZZ"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Moscow"]];
        NSDate *timeStamp = [formatter dateFromString:timeStampString];

        avatar = [YMAAvatar avatarWithUrl:avatarUrl timeStamp:timeStamp];
    }

    id balanceDetailsModel = [responseModel objectForKey:kParameterBalanceDetails];
    YMABalanceDetails *balanceDetails = nil;

    if (balanceDetailsModel) {
        NSString *total = [balanceDetailsModel objectForKey:kParameterBalanceTotal];
        NSString *available = [balanceDetailsModel objectForKey:kParameterBalanceAvailable];
        NSString *depositionPending = [balanceDetailsModel objectForKey:kParameterBalanceDepositionPending];
        NSString *blocked = [balanceDetailsModel objectForKey:kParameterBalanceBlocked];
        NSString *debt = [balanceDetailsModel objectForKey:kParameterBalanceDebt];

        balanceDetails = [YMABalanceDetails balanceDetailsWithTotal:total available:available depositionPending:depositionPending blocked:blocked debt:debt];
    }

    id cardsLinkedModel = [responseModel objectForKey:kParameterCardsLinked];
    NSMutableArray *cardsLinked = nil;

    if (cardsLinkedModel) {
        cardsLinked = [NSMutableArray array];

        for (id card in cardsLinkedModel) {
            NSString *panFragment = [card objectForKey:kParameterCardsLinkedPanFragment];
            NSString *cardTypeString = [card objectForKey:kParameterCardsLinkedType];
            YMAPaymentCardType cardType = [YMAMoneySource paymentCardTypeByString:cardTypeString];
            [cardsLinked addObject:[YMAMoneySource moneySourceWithType:YMAMoneySourcePaymentCard cardType:cardType panFragment:panFragment moneySourceToken:nil]];
        }
    }

    id servicesAdditionalModel = [responseModel objectForKey:kParameterServicesAdditional];
    NSMutableArray *servicesAdditional = nil;

    if (servicesAdditionalModel) {
        servicesAdditional = [NSMutableArray array];

        for (NSString *service in servicesAdditionalModel)
            [servicesAdditional addObject:service];
    }

    _accountInfo = [YMAAccountInfo accountInfoWithAccount:account balance:balance currency:currency accountStatus:accountStatus accountType:accountType avatar:avatar balanceDetails:balanceDetails cardsLinked:cardsLinked servicesAdditional:servicesAdditional];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"paymentInfo" : self.accountInfo.description
                                      }];
}

@end