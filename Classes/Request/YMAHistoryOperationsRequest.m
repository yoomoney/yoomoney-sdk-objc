//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAHistoryOperationsRequest.h"
#import "YMAHostsProvider.h"

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

@interface YMAHistoryOperationsRequest ()

@property(nonatomic, assign) YMAHistoryOperationFilter filter;
@property(nonatomic, copy) NSString *label;
@property(nonatomic, strong) NSDate *from;
@property(nonatomic, strong) NSDate *till;
@property(nonatomic, copy) NSString *startRecord;
@property(nonatomic, assign) NSUInteger records;

@end

@implementation YMAHistoryOperationsRequest

- (id)initWithFilter:(YMAHistoryOperationFilter)filter label:(NSString *)label from:(NSDate *)from till:(NSDate *)till startRecord:(NSString *)startRecord records:(NSUInteger)records {
    self = [super self];

    if (self) {
        _filter = filter;
        _label = [label copy];
        _from = from;
        _till = till;
        _records = records;
        _startRecord = [startRecord copy];
    }

    return self;
}

+ (instancetype)operationHistoryWithFilter:(YMAHistoryOperationFilter)filter label:(NSString *)label from:(NSDate *)from till:(NSDate *)till startRecord:(NSString *)startRecord records:(NSUInteger)records details:(BOOL)details; {
    return [[YMAHistoryOperationsRequest alloc] initWithFilter:filter label:label from:from till:till startRecord:startRecord records:records];
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
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSMutableString *typeString = [NSMutableString stringWithCapacity:0];

    if (self.filter & YMAHistoryOperationFilterPayment)
        [typeString appendString:kKeyTypePayment];
    else if (self.filter & YMAHistoryOperationFilterDeposition)
        [typeString appendString:kKeyTypeDeposition];

    [dictionary setValue:typeString.length ? typeString : nil forKey:kParameterType];
    [dictionary setValue:self.label forKey:kParameterLabel];

    NSString *fromString = [formatter stringFromDate:self.from];
    [dictionary setValue:fromString forKey:kParameterFrom];

    NSString *tillString = [formatter stringFromDate:self.till];
    [dictionary setValue:tillString forKey:kParameterTill];

    [dictionary setValue:self.startRecord forKey:kParameterStartRecord];
    [dictionary setValue:[NSString stringWithFormat:@"%lu", (unsigned long)self.records] forKey:kParameterRecords];

    return dictionary;
}

- (NSOperation *)buildResponseOperationWithData:(NSData *)data andCompletionHandler:(YMAResponseHandler)handler {
    return [[YMAHistoryOperationsResponse alloc] initWithData:data andCompletion:handler];
}

@end