//
// Created by Alexander Mertvetsov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMABaseResponse.h"

@interface YMABaseResponse ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSDictionary *headers;
@property (nonatomic, copy) YMAResponseHandler block;
@property (nonatomic, assign) YMAConnectHTTPStatusCodes statusCode;

@end

@implementation YMABaseResponse

#pragma mark - Object Lifecycle

- (instancetype)initWithData:(NSData *)data
                     headers:(NSDictionary *)headers
              httpStatusCode:(YMAConnectHTTPStatusCodes)statusCode
                  completion:(YMAResponseHandler)block
{
    self = [self init];
    if (self != nil) {
        _data = data;
        _block = [block copy];
        _headers = [headers copy];
        _statusCode = statusCode;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
                     headers:(NSDictionary *)headers
                  completion:(YMAResponseHandler)block
{
    return [self initWithData:data
                      headers:headers
               httpStatusCode:YMAStatusCodeUnkwownHTTP
                   completion:block];
}



#pragma mark - NSOperation

- (void)main
{
    @try {
        id responseModel = nil;
        NSError *error = NULL;

        if (self.data.length > 0) {
            responseModel = [NSJSONSerialization JSONObjectWithData:_data
                                                            options:(NSJSONReadingOptions)kNilOptions
                                                              error:&error];
        }

        if (error == NULL) {
            [self parseJSONModel:responseModel headers:self.headers error:&error];
        }

        if (self.block != NULL ) {
            self.block(self, error);
        }
    }
    @catch (NSException *exception) {
        self.block(self, [NSError errorWithDomain:exception.name code:0 userInfo:exception.userInfo]);
    }
}

#pragma mark - Public methods

- (BOOL)parseJSONModel:(id)responseModel headers:(NSDictionary *)headers error:(NSError * __autoreleasing *)error
{
    NSString *reason = [NSString stringWithFormat:@"%@ must be overridden", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
