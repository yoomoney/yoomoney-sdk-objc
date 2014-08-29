//
// Created by Alexander Mertvetsov on 26.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAOperationDetailsModel.h"
#import "YMADigitalGoodsModel.h"

static NSString *const kKeyRecipientTypeAccount = @"account";
static NSString *const kKeyRecipientTypePhone = @"phone";
static NSString *const kKeyRecipientTypeEmail = @"email";

@implementation YMAOperationDetailsModel

#pragma mark - Object Lifecycle

- (id)initWithOperation:(YMAHistoryOperationModel *)operation
              amountDue:(NSString *)amountDue
                    fee:(NSString *)fee
                 sender:(NSString *)sender
              recipient:(NSString *)recipient
          recipientType:(YMARecipientType)recipientType
                message:(NSString *)message
                comment:(NSString *)comment
                codepro:(BOOL)codePro
         protectionCode:(NSString *)protectionCode
                expires:(NSDate *)expires
         answerDatetime:(NSDate *)answerDatetime
                details:(NSString *)details
             repeatable:(BOOL)repeatable
      paymentParameters:(NSDictionary *)paymentParameters
           digitalGoods:(YMADigitalGoodsModel *)digitalGoods
{
    self = [super initWithOperationId:operation.operationId
                               status:operation.status
                             datetime:operation.datetime
                                title:operation.title
                            patternId:operation.patternId
                            direction:operation.direction
                               amount:operation.amount
                                label:operation.label
                            favourite:operation.isFavourite
                                 type:operation.type];

    if (self != nil) {
        _amountDue = [amountDue copy];
        _fee = [fee copy];
        _sender = [sender copy];
        _recipient = [recipient copy];
        _recipientType = recipientType;
        _message = [message copy];
        _comment = [comment copy];
        _codePro = codePro;
        _protectionCode = [protectionCode copy];
        _expires = expires;
        _answerDatetime = answerDatetime;
        _details = [details copy];
        _repeatable = repeatable;
        _paymentParameters = paymentParameters;
        _digitalGoods = digitalGoods;
    }

    return self;
}

+ (instancetype)operationDetailsWithOperation:(YMAHistoryOperationModel *)operation
                                    amountDue:(NSString *)amountDue
                                          fee:(NSString *)fee
                                       sender:(NSString *)sender
                                    recipient:(NSString *)recipient
                                recipientType:(YMARecipientType)recipientType
                                      message:(NSString *)message
                                      comment:(NSString *)comment
                                      codepro:(BOOL)codePro
                               protectionCode:(NSString *)protectionCode
                                      expires:(NSDate *)expires
                               answerDatetime:(NSDate *)answerDatetime
                                      details:(NSString *)details
                                   repeatable:(BOOL)repeatable
                            paymentParameters:(NSDictionary *)paymentParameters
                                 digitalGoods:(YMADigitalGoodsModel *)digitalGoods
{
    return [[YMAOperationDetailsModel alloc] initWithOperation:operation
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
}

#pragma mark - Public methods

+ (YMARecipientType)recipientTypeByString:(NSString *)recipientTypeString
{
    if ([recipientTypeString isEqual:kKeyRecipientTypeAccount])
        return YMARecipientTypeAccount;
    else if ([recipientTypeString isEqual:kKeyRecipientTypePhone])
        return YMARecipientTypePhone;
    else if ([recipientTypeString isEqual:kKeyRecipientTypeEmail])
        return YMARecipientTypeEmail;

    return YMARecipientTypeUnknown;
}

@end