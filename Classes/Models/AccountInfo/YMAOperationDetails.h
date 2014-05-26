//
// Created by Александр Мертвецов on 26.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAHistoryOperation.h"

@class YMADigitalGoods;

typedef NS_ENUM(NSInteger, YMARecipientType) {
    YMARecipientTypeUnknown,
    YMARecipientTypeAccount,
    YMARecipientTypePhone,
    YMARecipientTypeEmail
};

@interface YMAOperationDetails : YMAHistoryOperation

+ (instancetype)operationDetailsWithOperationId:(NSString *)operationId status:(YMAHistoryOperationStatus)status datetime:(NSDate *)datetime title:(NSString *)title patternId:(NSString *)patternId direction:(YMAHistoryOperationDirection)direction amount:(NSString *)amount label:(NSString *)label favourite:(BOOL)favourite type:(YMAHistoryOperationType)type amountDue:(NSString *)amountDue fee:(NSString *)fee sender:(NSString *)sender recipient:(NSString *)recipient recipientType:(YMARecipientType)recipientType message:(NSString *)message comment:(NSString *)comment codepro:(BOOL)codePro protectionCode:(NSString *)protectionCode expires:(NSDate *)expires answerDatetime:(NSDate *)answerDatetime details:(NSString *)details repeatable:(BOOL)repeatable paymentParameters:(NSDictionary *)paymentParameters digitalGoods:(YMADigitalGoods *)digitalGoods;

@property(nonatomic, copy, readonly) NSString *amountDue;
@property(nonatomic, copy, readonly) NSString *fee;
@property(nonatomic, copy, readonly) NSString *sender;
@property(nonatomic, copy, readonly) NSString *recipient;
@property(nonatomic, assign, readonly) YMARecipientType recipientType;
@property(nonatomic, copy, readonly) NSString *message;
@property(nonatomic, copy, readonly) NSString *comment;
@property(nonatomic, assign, readonly) BOOL codepro;
@property(nonatomic, copy, readonly) NSString *protectionCode;
@property(nonatomic, strong, readonly) NSDate *expires;
@property(nonatomic, strong, readonly) NSDate *answerDatetime;
@property(nonatomic, copy, readonly) NSString *details;
@property(nonatomic, assign, readonly) BOOL repeatable;
@property(nonatomic, strong, readonly) NSDictionary *paymentParameters;
@property(nonatomic, strong, readonly) YMADigitalGoods *digitalGoods;

@end