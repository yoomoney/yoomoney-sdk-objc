//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAHistoryOperationModel.h"

static NSString *const kKeyHistoryOperationStatusSuccess = @"success";
static NSString *const kKeyHistoryOperationStatusRefused = @"refused";
static NSString *const kKeyHistoryOperationStatusInProgress = @"in_progress";

static NSString *const kKeyHistoryOperationDirectionIn = @"in";
static NSString *const kKeyHistoryOperationDirectionOut = @"out";

static NSString *const kKeyHistoryOperationTypePaymentShop = @"payment-shop";
static NSString *const kKeyHistoryOperationTypeOutgoingTransfer = @"outgoing-transfer";
static NSString *const kKeyHistoryOperationTypeDeposition = @"deposition";
static NSString *const kKeyHistoryOperationTypeIncomingTransfer = @"incoming-transfer";
static NSString *const kKeyHistoryOperationTypeIncomingTransferProtected = @"incoming-transfer-protected";

@implementation YMAHistoryOperationModel

#pragma mark - Object Lifecycle

- (id)initWithOperationId:(NSString *)operationId
                   status:(YMAHistoryOperationStatus)status
                 datetime:(NSDate *)datetime
                    title:(NSString *)title
                patternId:(NSString *)patternId
                direction:(YMAHistoryOperationDirection)direction
                   amount:(NSString *)amount
                    label:(NSString *)label
                favourite:(BOOL)favourite
                     type:(YMAHistoryOperationType)type
{
    self = [super init];

    if (self != nil) {
        _operationId = [operationId copy];
        _status = status;
        _datetime = datetime;
        _title = [title copy];
        _patternId = [patternId copy];
        _direction = direction;
        _amount = [amount copy];
        _label = [label copy];
        _isFavourite = favourite;
        _type = type;
    }

    return self;
}

+ (instancetype)historyOperationWithOperationId:(NSString *)operationId
                                         status:(YMAHistoryOperationStatus)status
                                       datetime:(NSDate *)datetime
                                          title:(NSString *)title
                                      patternId:(NSString *)patternId
                                      direction:(YMAHistoryOperationDirection)direction
                                         amount:(NSString *)amount
                                          label:(NSString *)label
                                      favourite:(BOOL)favourite
                                           type:(YMAHistoryOperationType)type
{
    return [[YMAHistoryOperationModel alloc] initWithOperationId:operationId
                                                          status:status
                                                        datetime:datetime
                                                           title:title
                                                       patternId:patternId
                                                       direction:direction
                                                          amount:amount
                                                           label:label
                                                       favourite:favourite
                                                            type:type];
}

#pragma mark - Public methods

+ (YMAHistoryOperationStatus)historyOperationStatusByString:(NSString *)historyOperationStatusString
{
    if ([historyOperationStatusString isEqual:kKeyHistoryOperationStatusSuccess])
        return YMAHistoryOperationStatusSuccess;
    else if ([historyOperationStatusString isEqual:kKeyHistoryOperationStatusRefused])
        return YMAHistoryOperationStatusRefused;
    else if ([historyOperationStatusString isEqual:kKeyHistoryOperationStatusInProgress])
        return YMAHistoryOperationStatusInProgress;

    return YMAHistoryOperationStatusUnknown;
}

+ (YMAHistoryOperationDirection)historyOperationDirectionByString:(NSString *)historyOperationDirectionString
{
    if ([historyOperationDirectionString isEqual:kKeyHistoryOperationDirectionIn])
        return YMAHistoryOperationDirectionIn;
    else if ([historyOperationDirectionString isEqual:kKeyHistoryOperationDirectionOut])
        return YMAHistoryOperationDirectionOut;

    return YMAHistoryOperationDirectionUnknown;
}

+ (YMAHistoryOperationType)historyOperationTypeByString:(NSString *)historyOperationTypeString
{
    if ([historyOperationTypeString isEqual:kKeyHistoryOperationTypePaymentShop])
        return YMAHistoryOperationTypePaymentShop;
    else if ([historyOperationTypeString isEqual:kKeyHistoryOperationTypeOutgoingTransfer])
        return YMAHistoryOperationTypeOutgoingTransfer;
    else if ([historyOperationTypeString isEqual:kKeyHistoryOperationTypeDeposition])
        return YMAHistoryOperationTypeDeposition;
    else if ([historyOperationTypeString isEqual:kKeyHistoryOperationTypeIncomingTransfer])
        return YMAHistoryOperationTypeIncomingTransfer;
    else if ([historyOperationTypeString isEqual:kKeyHistoryOperationTypeIncomingTransferProtected])
        return YMAHistoryOperationTypeIncomingTransferProtected;

    return YMAHistoryOperationTypeUnknown;
}

- (NSComparisonResult)compare:(YMAHistoryOperationModel *)otherObject
{
    return -[self.datetime compare:otherObject.datetime];
}

@end