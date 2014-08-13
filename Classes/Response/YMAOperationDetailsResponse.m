//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAOperationDetailsResponse.h"
#import "YMAConstants.h"
#import "YMAHistoryOperationsResponse.h"
#import "YMAProcessPaymentResponse.h"

static NSString *const kParameterError = @"error";

static NSString *const kParameterAmountDue = @"amount_due";
static NSString *const kParameterFee = @"fee";
static NSString *const kParameterSender = @"sender";
static NSString *const kParameterRecipient = @"recipient";
static NSString *const kParameterRecipientType = @"recipient_type";
static NSString *const kParameterMessage = @"message";
static NSString *const kParameterComment = @"comment";
static NSString *const kParameterCodePro = @"codepro";
static NSString *const kParameterProtectionCode = @"protection_code";
static NSString *const kParameterExpires = @"expires";
static NSString *const kParameterAnswerDatetime = @"answer_datetime";
static NSString *const kParameterDetails = @"details";
static NSString *const kParameterRepeatable = @"repeatable";
static NSString *const kParameterPaymentParameters = @"payment_parameters";
static NSString *const kParameterDigitalGoods = @"digital_goods";

@implementation YMAOperationDetailsResponse

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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];

    YMAHistoryOperationModel *historyOperation = [YMAHistoryOperationsResponse historyOperationByModel:responseModel];

    NSString *amountDue = [[responseModel objectForKey:kParameterAmountDue] stringValue];
    NSString *fee = [[responseModel objectForKey:kParameterFee] stringValue];
    NSString *sender = [responseModel objectForKey:kParameterSender];
    NSString *recipient = [responseModel objectForKey:kParameterRecipient];

    NSString *recipientTypeString = [responseModel objectForKey:kParameterRecipientType];
    YMARecipientType recipientType = [YMAOperationDetailsModel recipientTypeByString:recipientTypeString];

    NSString *message = [responseModel objectForKey:kParameterMessage];
    NSString *comment = [responseModel objectForKey:kParameterComment];
    BOOL codePro = [[responseModel objectForKey:kParameterCodePro] boolValue];
    NSString *protectionCode = [responseModel objectForKey:kParameterProtectionCode];

    NSString *expiresString = [responseModel objectForKey:kParameterExpires];
    NSDate *expires = [formatter dateFromString:expiresString];

    NSString *answerDatetimeString = [responseModel objectForKey:kParameterAnswerDatetime];
    NSDate *answerDatetime = [formatter dateFromString:answerDatetimeString];

    NSString *details = [responseModel objectForKey:kParameterDetails];
    BOOL repeatable = [[responseModel objectForKey:kParameterRepeatable] boolValue];

    NSDictionary *paymentParameters = [responseModel objectForKey:kParameterPaymentParameters];

    id digitalGoodsModel = [responseModel objectForKey:kParameterDigitalGoods];
    YMADigitalGoodsModel *digitalGoods = [YMAProcessPaymentResponse digitalGoodsByModel:digitalGoodsModel];

    _operationDetails = [YMAOperationDetailsModel operationDetailsWithOperation:historyOperation
                                                                      amountDue:amountDue
                                                                            fee:fee
                                                                         sender:sender
                                                                      recipient:recipient
                                                                  recipientType:recipientType
                                                                        message:message
                                                                        comment:comment
                                                                        codepro:codePro
                                                                 protectionCode:protectionCode
                                                                        expires:expires
                                                                 answerDatetime:answerDatetime
                                                                        details:details
                                                                     repeatable:repeatable
                                                              paymentParameters:paymentParameters
                                                                   digitalGoods:digitalGoods];

    return YES;
}

@end