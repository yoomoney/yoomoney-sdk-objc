//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"

@interface YMABaseResponse ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSDictionary *headers;
@property (nonatomic, copy) YMAResponseHandler block;

@end

@implementation YMABaseResponse

#pragma mark - Object Lifecycle

- (id)initWithData:(NSData *)data headers:(NSDictionary *)headers andCompletion:(YMAResponseHandler)block
{
    self = [self init];

    if (self != nil) {
        _data = data;
        _block = [block copy];
        _headers = [headers copy];
    }

    return self;
}

#pragma mark - NSOperation

- (void)main
{
    NSError *error;

    @try {
        id responseModel =
            [NSJSONSerialization JSONObjectWithData:_data options:(NSJSONReadingOptions)kNilOptions error:&error];

        if (error) {
            self.block(self, error);
            return;
        }

        [self parseJSONModel:responseModel headers:self.headers error:&error];
        self.block(self, error);
    }
    @catch (NSException *exception) {
        self.block(self, [NSError errorWithDomain:exception.name code:0 userInfo:exception.userInfo]);
    }
}

#pragma mark - Public methods

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error
{
    NSString *reason = [NSString stringWithFormat:@"%@ must be ovverriden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
