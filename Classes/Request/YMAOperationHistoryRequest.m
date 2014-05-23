//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAOperationHistoryRequest.h"
#import "YMAHostsProvider.h"
#import "YMAOperationHistoryResponse.h"

static NSString *const kParameterType = @"type";
static NSString *const kKeyTypePayment = @"payment";
static NSString *const kKeyTypeDeposition = @"deposition";
static NSString *const kParameterLabel = @"label";
static NSString *const kParameterFrom = @"from";
static NSString *const kParameterTill = @"till";
static NSString *const kParameterStartRecord = @"start_record";
static NSString *const kParameterRecords = @"records";
static NSString *const kParameterDetails = @"details";

static NSString *const kUrlHistoryOperation = @"api/operation-history";

@interface YMAOperationHistoryRequest ()

@property(nonatomic, assign) YMAHistoryOperationFilter filter;
@property(nonatomic, copy) NSString *label;
@property(nonatomic, strong) NSDate *from;
@property(nonatomic, strong) NSDate *till;
@property(nonatomic, copy) NSString *startRecord;
@property(nonatomic, assign) NSUInteger records;
@property(nonatomic, assign) BOOL details;
@end

@implementation YMAOperationHistoryRequest

- (id)initWithFilter:(YMAHistoryOperationFilter)filter label:(NSString *)label from:(NSDate *)from till:(NSDate *)till startRecord:(NSString *)startRecord records:(NSUInteger)records details:(BOOL)details {
    self = [super self];

    if (self) {
        _filter = filter;
        _label = [label copy];
        _from = from;
        _till = till;
        _records = records;
        _startRecord = [startRecord copy];
        _details = details;
    }

    return self;
}

+ (instancetype)operationHistoryWithFilter:(YMAHistoryOperationFilter)filter label:(NSString *)label from:(NSDate *)from till:(NSDate *)till startRecord:(NSString *)startRecord records:(NSUInteger)records details:(BOOL)details; {
    return [[YMAOperationHistoryRequest alloc] initWithType:filter label:label from:from till:till startRecord:startRecord records:records details:details];
}

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (NSURL *)requestUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@", [YMAHostsProvider sharedManager].moneyUrl, kUrlHistoryOperation];
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DDThh:mm:ss.fZZZZZ"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSMutableString *typeString = [NSMutableString stringWithCapacity:0];

    if (self.type & YMAHistoryOperationTypePayment)
        [typeString appendString:kKeyTypePayment];
    else if (self.type & YMAHistoryOperationTypeDeposition)
        [typeString appendString:kKeyTypeDeposition];

    [dictionary setObject:typeString forKey:kParameterType];
    [dictionary setObject:self.label forKey:kParameterLabel];

    NSString *fromString = [formatter stringFromDate:self.from];
    [dictionary setObject:fromString forKey:kParameterFrom];

    NSString *tillString = [formatter stringFromDate:self.till];
    [dictionary setObject:tillString forKey:kParameterTill];

    [dictionary setObject:self.startRecord forKey:kParameterStartRecord];
    [dictionary setObject:[NSString stringWithFormat:@"%lu", self.records] forKey:kParameterRecords];
    [dictionary setObject:self.details ? @"true" : @"false" forKey:kParameterDetails];

    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAOperationHistoryResponse alloc] initWithData:data andCompletion:handler];
}

@end