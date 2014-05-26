//
// Created by Александр Мертвецов on 26.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <__functional_base_03>
#import "YMAOperationDetails.h"
#import "YMADigitalGoods.h"


@implementation YMAOperationDetails

- (id)initWithOperationId:(NSString *)operationId status:(YMAHistoryOperationStatus)status datetime:(NSDate *)datetime title:(NSString *)title patternId:(NSString *)patternId direction:(YMAHistoryOperationDirection)direction amount:(NSString *)amount label:(NSString *)label favourite:(BOOL)favourite type:(YMAHistoryOperationType)type amountDue:(NSString *)amountDue fee:(NSString *)fee sender:(NSString *)sender recipient:(NSString *)recipient recipientType:(YMARecipientType)recipientType message:(NSString *)message comment:(NSString *)comment codepro:(BOOL)codePro protectionCode:(NSString *)protectionCode expires:(NSDate *)expires answerDatetime:(NSDate *)answerDatetime details:(NSString *)details repeatable:(BOOL)repeatable paymentParameters:(NSDictionary *)paymentParameters digitalGoods:(YMADigitalGoods *)digitalGoods {
    self = [super initWithOperationId:operationId status:status datetime:datetime title:title patternId:patternId direction:direction amount:amount label:label favourite:favourite type:type];

    if (self) {
        _amountDue = [amountDue copy];
        _fee = [fee copy];
        _sender = [sender copy];
        _recipient = [recipient copy];
        _recipientType = recipientType;
        _message = [message copy];
        _comment = [comment copy];
        _codepro = codePro;
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

+ (instancetype)operationDetailsWithOperationId:(NSString *)operationId status:(YMAHistoryOperationStatus)status datetime:(NSDate *)datetime title:(NSString *)title patternId:(NSString *)patternId direction:(YMAHistoryOperationDirection)direction amount:(NSString *)amount label:(NSString *)label favourite:(BOOL)favourite type:(YMAHistoryOperationType)type amountDue:(NSString *)amountDue fee:(NSString *)fee sender:(NSString *)sender recipient:(NSString *)recipient recipientType:(YMARecipientType)recipientType message:(NSString *)message comment:(NSString *)comment codepro:(BOOL)codePro protectionCode:(NSString *)protectionCode expires:(NSDate *)expires answerDatetime:(NSDate *)answerDatetime details:(NSString *)details repeatable:(BOOL)repeatable paymentParameters:(NSDictionary *)paymentParameters digitalGoods:(YMADigitalGoods *)digitalGoods {
    return [[YMAOperationDetails alloc] initWithOperationId:operationId status:status datetime:datetime title:title patternId:patternId direction:direction amount:amount label:label favourite:favourite type:type amountDue:amountDue fee:fee sender:sender recipient:recipient recipientType:recipientType message:message comment:comment codepro:codePro protectionCode:protectionCode expires:expires answerDatetime:answerDatetime details:details repeatable:repeatable paymentParameters:paymentParameters digitalGoods:digitalGoods];
}

@end