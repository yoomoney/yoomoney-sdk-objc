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

- (id)initWithOperation:(YMAHistoryOperationModel *)operation amountDue:(NSString *)amountDue fee:(NSString *)fee sender:(NSString *)sender recipient:(NSString *)recipient recipientType:(YMARecipientType)recipientType message:(NSString *)message comment:(NSString *)comment codepro:(BOOL)codePro protectionCode:(NSString *)protectionCode expires:(NSDate *)expires answerDatetime:(NSDate *)answerDatetime details:(NSString *)details repeatable:(BOOL)repeatable paymentParameters:(NSDictionary *)paymentParameters digitalGoods:(YMADigitalGoodsModel *)digitalGoods {
    self = [super initWithOperationId:operation.operationId status:operation.status datetime:operation.datetime title:operation.title patternId:operation.patternId direction:operation.direction amount:operation.amount label:operation.label favourite:operation.isFavourite type:operation.type];

    if (self) {
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

+ (instancetype)operationDetailsWithOperation:(YMAHistoryOperationModel *)operation amountDue:(NSString *)amountDue fee:(NSString *)fee sender:(NSString *)sender recipient:(NSString *)recipient recipientType:(YMARecipientType)recipientType message:(NSString *)message comment:(NSString *)comment codepro:(BOOL)codePro protectionCode:(NSString *)protectionCode expires:(NSDate *)expires answerDatetime:(NSDate *)answerDatetime details:(NSString *)details repeatable:(BOOL)repeatable paymentParameters:(NSDictionary *)paymentParameters digitalGoods:(YMADigitalGoodsModel *)digitalGoods {
    return [[YMAOperationDetailsModel alloc] initWithOperation:operation amountDue:amountDue fee:fee sender:sender recipient:recipient recipientType:recipientType message:message comment:comment codepro:codePro protectionCode:protectionCode expires:expires answerDatetime:answerDatetime details:details repeatable:repeatable paymentParameters:paymentParameters digitalGoods:digitalGoods];
}

+ (YMARecipientType)recipientTypeByString:(NSString *)recipientTypeString {
    if ([recipientTypeString isEqual:kKeyRecipientTypeAccount])
        return YMARecipientTypeAccount;
    else if ([recipientTypeString isEqual:kKeyRecipientTypePhone])
        return YMARecipientTypePhone;
    else if ([recipientTypeString isEqual:kKeyRecipientTypeEmail])
        return YMARecipientTypeEmail;

    return YMARecipientTypeUnknown;
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"operationId" : self.operationId,
                                              @"status" : [NSNumber numberWithInteger:self.status],
                                              @"datetime" : self.datetime.description,
                                              @"title" : self.title,
                                              @"patternId" : self.patternId,
                                              @"direction" : [NSNumber numberWithInteger:self.direction],
                                              @"amount" : self.amount,
                                              @"label" : self.label,
                                              @"favourite" : self.isFavourite ? @"true" : @"false",
                                              @"amountDue" : self.amountDue,
                                              @"type" : [NSNumber numberWithInteger:self.type],
                                              @"fee" : self.fee,
                                              @"sender" : self.sender,
                                              @"recipientType" : [NSNumber numberWithInteger:self.recipientType],
                                              @"message" : self.message,
                                              @"comment" : self.comment,
                                              @"codePro" : [NSNumber numberWithBool:self.codePro],
                                              @"protectionCode" : self.protectionCode,
                                              @"expires" : self.expires.description,
                                              @"answerDatetime" : self.answerDatetime.description,
                                              @"details" : self.details,
                                              @"repeatable" : [NSNumber numberWithBool:self.repeatable],
                                              @"paymentParameters" : self.paymentParameters.description,
                                              @"digitalGoods" : self.digitalGoods.description
                                      }];
}

@end