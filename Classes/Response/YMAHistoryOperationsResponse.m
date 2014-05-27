//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAHistoryOperationsResponse.h"
#import "YMAConstants.h"
#import "YMAHistoryOperation.h"
#import "YMAOperationDetails.h"
#import "YMAProcessPaymentResponse.h"

static NSString *const kParameterError = @"error";
static NSString *const kParameterNextRecord = @"next_record";
static NSString *const kParameterOperations = @"operations";

static NSString *const kParameterOperationOperationId = @"operation_id";
static NSString *const kParameterOperationStatus = @"status";
static NSString *const kParameterOperationDatetime = @"datetime";
static NSString *const kParameterOperationTitle = @"title";
static NSString *const kParameterOperationPatternId = @"pattern_id";
static NSString *const kParameterOperationDirection = @"direction";
static NSString *const kParameterOperationAmount = @"amount";
static NSString *const kParameterOperationLabel = @"label";
static NSString *const kParameterOperationFavourite = @"favourite";
static NSString *const kParameterOperationType = @"type";

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

@implementation YMAHistoryOperationsResponse

+ (YMAHistoryOperation *)historyOperationByModel:(id)historyOperationModel {
    NSString *operationId = [historyOperationModel objectForKey:kParameterOperationOperationId];
    NSString *statusString = [historyOperationModel objectForKey:kParameterOperationStatus];
    YMAHistoryOperationStatus status = [YMAHistoryOperation historyOperationStatusByString:statusString];

    NSString *dateTimeString = [historyOperationModel objectForKey:kParameterOperationDatetime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Moscow"]];
    NSDate *dateTime = [formatter dateFromString:dateTimeString];

    NSString *title = [historyOperationModel objectForKey:kParameterOperationTitle];
    NSString *patternId = [historyOperationModel objectForKey:kParameterOperationPatternId];

    NSString *directionString = [historyOperationModel objectForKey:kParameterOperationDirection];
    YMAHistoryOperationDirection direction = [YMAHistoryOperation historyOperationDirectionByString:directionString];

    NSString *amount = [[historyOperationModel objectForKey:kParameterOperationAmount] stringValue];
    NSString *label = [historyOperationModel objectForKey:kParameterOperationLabel];

    BOOL favourite = [[historyOperationModel objectForKey:kParameterOperationFavourite] boolValue];

    NSString *typeString = [historyOperationModel objectForKey:kParameterOperationType];
    YMAHistoryOperationType type = [YMAHistoryOperation historyOperationTypeByString:typeString];

    YMAHistoryOperation *historyOperation = [YMAHistoryOperation historyOperationWithOperationId:operationId status:status datetime:dateTime title:title patternId:patternId direction:direction amount:amount label:label favourite:favourite type:type];

    if (![historyOperationModel objectForKey:kParameterDetails])
        return historyOperation;

    NSString *amountDue = [[historyOperationModel objectForKey:kParameterAmountDue] stringValue];
    NSString *fee = [[historyOperationModel objectForKey:kParameterFee] stringValue];
    NSString *sender = [historyOperationModel objectForKey:kParameterSender];
    NSString *recipient = [historyOperationModel objectForKey:kParameterRecipient];

    NSString *recipientTypeString = [historyOperationModel objectForKey:kParameterRecipientType];
    YMARecipientType recipientType = [YMAOperationDetails recipientTypeByString:recipientTypeString];

    NSString *message = [historyOperationModel objectForKey:kParameterMessage];
    NSString *comment = [historyOperationModel objectForKey:kParameterComment];
    BOOL codePro = [[historyOperationModel objectForKey:kParameterCodePro] boolValue];
    NSString *protectionCode = [historyOperationModel objectForKey:kParameterProtectionCode];

    NSString *expiresString = [historyOperationModel objectForKey:kParameterExpires];
    NSDate *expires = [formatter dateFromString:expiresString];

    NSString *answerDatetimeString = [historyOperationModel objectForKey:kParameterAnswerDatetime];
    NSDate *answerDatetime = [formatter dateFromString:answerDatetimeString];

    NSString *details = [historyOperationModel objectForKey:kParameterDetails];
    BOOL repeatable = [[historyOperationModel objectForKey:kParameterRepeatable] boolValue];

    NSDictionary *paymentParameters = [historyOperationModel objectForKey:kParameterPaymentParameters];

    id digitalGoodsModel = [historyOperationModel objectForKey:kParameterDigitalGoods];
    YMADigitalGoods *digitalGoods = [YMAProcessPaymentResponse digitalGoodsByModel:digitalGoodsModel];

    return [YMAOperationDetails operationDetailsWithOperation:historyOperation amountDue:amountDue fee:fee sender:sender recipient:recipient recipientType:recipientType message:message comment:comment codepro:codePro protectionCode:protectionCode expires:expires answerDatetime:answerDatetime details:details repeatable:repeatable paymentParameters:paymentParameters digitalGoods:digitalGoods];
}


#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    NSString *errorKey = [responseModel objectForKey:kParameterError];

    if (errorKey) {
        if (!error) return;

        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];
        *error = errorKey ? [NSError errorWithDomain:errorKey code:0 userInfo:@{@"response" : self}] : unknownError;

        return;
    }

    NSString *nextRecord = [responseModel objectForKey:kParameterNextRecord];
    _nextRecord = [nextRecord copy];

    id operationsModel = [responseModel objectForKey:kParameterOperations];

    if (!operationsModel)
        return;

    NSMutableArray *historyOperations = [NSMutableArray array];

    for (id historyOperationModel in operationsModel) {
        YMAHistoryOperation *operation = [YMAHistoryOperationsResponse historyOperationByModel:historyOperationModel];
        [historyOperations addObject:operation];
    }

    _operations = historyOperations;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"nextRecord" : self.nextRecord,
                                              @"operations" : self.operations.description
                                      }];
}

@end