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

- (instancetype)initWithOperationId:(NSString *)operationId
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


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[YMAHistoryOperationModel alloc] initWithOperationId:self.operationId
                                                             status:self.status
                                                           datetime:self.datetime
                                                              title:self.title
                                                          patternId:self.patternId
                                                          direction:self.direction
                                                             amount:self.amount
                                                              label:self.label
                                                          favourite:self.isFavourite
                                                               type:self.type];
    return copy;
}


#pragma mark - Equality

- (BOOL)isEqualToHistoryOperation:(YMAHistoryOperationModel *)historyOperation
{
    if (historyOperation == nil) {
        return NO;
    }
    return [self.operationId isEqualToString:historyOperation.operationId];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if ([object isKindOfClass:[self class]] == NO) {
        return NO;
    }

    return [self isEqualToHistoryOperation:object];
}

- (NSUInteger)hash
{
    return [self.operationId hash];
}


#pragma mark - Public methods

+ (YMAHistoryOperationStatus)historyOperationStatusByString:(NSString *)historyOperationStatusString
{
    if ([historyOperationStatusString isEqualToString:kKeyHistoryOperationStatusSuccess])
        return YMAHistoryOperationStatusSuccess;
    else if ([historyOperationStatusString isEqualToString:kKeyHistoryOperationStatusRefused])
        return YMAHistoryOperationStatusRefused;
    else if ([historyOperationStatusString isEqualToString:kKeyHistoryOperationStatusInProgress])
        return YMAHistoryOperationStatusInProgress;

    return YMAHistoryOperationStatusUnknown;
}

+ (YMAHistoryOperationDirection)historyOperationDirectionByString:(NSString *)historyOperationDirectionString
{
    if ([historyOperationDirectionString isEqualToString:kKeyHistoryOperationDirectionIn])
        return YMAHistoryOperationDirectionIn;
    else if ([historyOperationDirectionString isEqualToString:kKeyHistoryOperationDirectionOut])
        return YMAHistoryOperationDirectionOut;

    return YMAHistoryOperationDirectionUnknown;
}

+ (YMAHistoryOperationType)historyOperationTypeByString:(NSString *)historyOperationTypeString
{
    if ([historyOperationTypeString isEqualToString:kKeyHistoryOperationTypePaymentShop])
        return YMAHistoryOperationTypePaymentShop;
    else if ([historyOperationTypeString isEqualToString:kKeyHistoryOperationTypeOutgoingTransfer])
        return YMAHistoryOperationTypeOutgoingTransfer;
    else if ([historyOperationTypeString isEqualToString:kKeyHistoryOperationTypeDeposition])
        return YMAHistoryOperationTypeDeposition;
    else if ([historyOperationTypeString isEqualToString:kKeyHistoryOperationTypeIncomingTransfer])
        return YMAHistoryOperationTypeIncomingTransfer;
    else if ([historyOperationTypeString isEqualToString:kKeyHistoryOperationTypeIncomingTransferProtected])
        return YMAHistoryOperationTypeIncomingTransferProtected;

    return YMAHistoryOperationTypeUnknown;
}

- (NSComparisonResult)compare:(YMAHistoryOperationModel *)otherObject
{
    return -[self.datetime compare:otherObject.datetime];
}

@end