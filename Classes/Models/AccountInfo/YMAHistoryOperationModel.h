//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YMAHistoryOperationStatus) {
    YMAHistoryOperationStatusUnknown,
    YMAHistoryOperationStatusSuccess,
    YMAHistoryOperationStatusRefused,
    YMAHistoryOperationStatusInProgress
};

typedef NS_ENUM(NSInteger, YMAHistoryOperationDirection) {
    YMAHistoryOperationDirectionUnknown,
    YMAHistoryOperationDirectionIn,
    YMAHistoryOperationDirectionOut
};

typedef NS_ENUM(NSInteger, YMAHistoryOperationType) {
    YMAHistoryOperationTypeUnknown,
    YMAHistoryOperationTypePaymentShop,
    YMAHistoryOperationTypeOutgoingTransfer,
    YMAHistoryOperationTypeDeposition,
    YMAHistoryOperationTypeIncomingTransfer,
    YMAHistoryOperationTypeIncomingTransferProtected
};

@interface YMAHistoryOperationModel : NSObject

- (id)initWithOperationId:(NSString *)operationId
                   status:(YMAHistoryOperationStatus)status
                 datetime:(NSDate *)datetime
                    title:(NSString *)title
                patternId:(NSString *)patternId
                direction:(YMAHistoryOperationDirection)direction
                   amount:(NSString *)amount
                    label:(NSString *)label
                favourite:(BOOL)favourite
                     type:(YMAHistoryOperationType)type;

+ (instancetype)historyOperationWithOperationId:(NSString *)operationId
                                         status:(YMAHistoryOperationStatus)status
                                       datetime:(NSDate *)datetime
                                          title:(NSString *)title
                                      patternId:(NSString *)patternId
                                      direction:(YMAHistoryOperationDirection)direction
                                         amount:(NSString *)amount
                                          label:(NSString *)label
                                      favourite:(BOOL)favourite
                                           type:(YMAHistoryOperationType)type;

+ (YMAHistoryOperationStatus)historyOperationStatusByString:(NSString *)historyOperationStatusString;

+ (YMAHistoryOperationDirection)historyOperationDirectionByString:(NSString *)historyOperationDirectionString;

+ (YMAHistoryOperationType)historyOperationTypeByString:(NSString *)historyOperationTypeString;

- (NSComparisonResult)compare:(YMAHistoryOperationModel *)otherObject;

@property (nonatomic, copy, readonly) NSString *operationId;
@property (nonatomic, assign, readonly) YMAHistoryOperationStatus status;
@property (nonatomic, strong, readonly) NSDate *datetime;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *patternId;
@property (nonatomic, assign, readonly) YMAHistoryOperationDirection direction;
@property (nonatomic, copy, readonly) NSString *amount;
@property (nonatomic, copy, readonly) NSString *label;
@property (nonatomic, assign, readonly) BOOL isFavourite;
@property (nonatomic, assign, readonly) YMAHistoryOperationType type;

@end