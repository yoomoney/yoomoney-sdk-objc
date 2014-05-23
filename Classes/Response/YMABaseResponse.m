//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"
#import "YMAConstants.h"

static NSInteger const kResponseParseErrorCode = 2503;

@interface YMABaseResponse ()

@property(nonatomic, strong) NSData *data;
@property(nonatomic, copy) YMAResponseHandler block;

@end

@implementation YMABaseResponse

- (id)initWithData:(NSData *)data andCompletion:(YMAResponseHandler)block {
    self = [self init];

    if (self) {
        _data = data;
        _block = [block copy];
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
            _block(self, error);
            return;
        }

        [self parseJSONModel:responseModel error:&error];
        _block(self, error);
    }
    @catch (NSException *exception) {
        _block(self, [NSError errorWithDomain:exception.name code:kResponseParseErrorCode userInfo:exception.userInfo]);
    }
}

- (void)parseJSONModel:(id)responseModel error:(NSError * __autoreleasing *)error {
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];

//    if (!responseModel) {
//        NSError *unknownError = [NSError errorWithDomain:kErrorKeyUnknown code:0 userInfo:@{@"response" : self}];
//        _handler(self, unknownError);
//        return;
//    }
}

@end