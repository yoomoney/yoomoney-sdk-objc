//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"
#import "YMAConstants.h"

static NSInteger const kResponseParseErrorCode = 2503;

@interface YMABaseResponse ()

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
            _handler(self, error);
            return;
        }

        [self parseJSONModel:responseModel];
        _handler(self, nil);
    }
    @catch (NSException *exception) {
        _handler(self, [NSError errorWithDomain:exception.name code:kResponseParseErrorCode userInfo:exception.userInfo]);
    }
}

- (void)parseJSONModel:(id)responseModel {
    NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];

    if (!responseModel) {
        _handler(self, unknownError);
        return;
    }
}

@end