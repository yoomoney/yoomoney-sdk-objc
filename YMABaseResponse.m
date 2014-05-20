//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"

static NSInteger const kResponseParseErrorCode = 2503;

@interface YMABaseResponse ()

@property(nonatomic, copy) YMAResponseHandler handler;
@property(nonatomic, retain) NSData *data;

@end

@implementation YMABaseResponse

- (id)initWithData:(NSData *)data andCompletion:(YMAResponseHandler)block {
    self = [self init];

    if (self) {
        _data = data;
        _handler = [block copy];
    }

    return self;
}

#pragma mark -
#pragma mark *** NSOperation ***
#pragma mark -

- (void)main {

    NSError *error;

    @try {

        id responseModel = [NSJSONSerialization JSONObjectWithData:_data options:(NSJSONReadingOptions) kNilOptions error:&error];

        if (error) {
            self.handler(self, error);
            return;
        }

        [self parseJSONModel:responseModel];
        self.handler(self, nil);
    }
    @catch (NSException *exception) {
        self.handler(self, [NSError errorWithDomain:exception.name code:kResponseParseErrorCode userInfo:exception.userInfo]);
    }
}

- (void)parseJSONModel:(id)responseModel {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end