//
// Created by Alexander Mertvetsov on 31.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMASecureStorage.h"
#import "YMAMoneySourceModel.h"

NSString *const kKeychainItemValueEmpty = @"";
static NSString *const kKeychainIdInstance = @"instanceKeychainId";
static NSString *const kKeychainMoneySource = @"moneySourceKeychainId";

@interface YMASecureStorage () {
    NSMutableDictionary *_instanceIdQuery;
    NSMutableDictionary *_moneySourceQuery;
}

@property(nonatomic, strong, readonly) NSDictionary *instanceIdQuery;
@property(nonatomic, strong, readonly) NSDictionary *moneySourceQuery;

@end

@implementation YMASecureStorage

#pragma mark -
#pragma mark *** Public methods ***
#pragma mark -

- (void)saveMoneySource:(YMAMoneySourceModel *)moneySource {
    if (!moneySource || [self hasMoneySource:moneySource])
        return;

    NSMutableDictionary *newSource = [NSMutableDictionary dictionary];

    newSource[(__bridge id) kSecAttrGeneric]     = kKeychainMoneySource;
    newSource[(__bridge id) kSecAttrLabel]       = [NSString stringWithFormat:@"%li", (long)moneySource.type];
    newSource[(__bridge id) kSecAttrDescription] = [NSString stringWithFormat:@"%li", (long)moneySource.cardType];
    newSource[(__bridge id) kSecValueData]       = moneySource.moneySourceToken;
    newSource[(__bridge id) kSecAttrAccount]     = moneySource.panFragment;

    NSMutableDictionary *secItem = [self dictionaryToSecItemFormat:newSource];
    SecItemAdd((__bridge CFDictionaryRef) secItem, NULL);
}

- (void)removeMoneySource:(YMAMoneySourceModel *)moneySource {
    NSMutableDictionary *sourceToRemove = [NSMutableDictionary dictionary];

    sourceToRemove[(__bridge id) kSecAttrAccount]     = moneySource.panFragment;
    sourceToRemove[(__bridge id) kSecAttrLabel]       = [NSString stringWithFormat:@"%li", (long)moneySource.type];
    sourceToRemove[(__bridge id) kSecAttrDescription] = [NSString stringWithFormat:@"%li", (long)moneySource.cardType];
    sourceToRemove[(__bridge id) kSecAttrGeneric]     = kKeychainMoneySource;
    sourceToRemove[(__bridge id) kSecClass]           = (__bridge id) kSecClassGenericPassword;

    SecItemDelete((__bridge CFDictionaryRef) sourceToRemove);
}

- (void)clearSecureStorage {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(__bridge id) kSecClass] = (__bridge id) kSecClassGenericPassword;
    SecItemDelete((__bridge CFDictionaryRef) dict);
}

#pragma mark -
#pragma mark *** Private methods ***
#pragma mark -

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    returnDictionary[(__bridge id) kSecReturnData] = (__bridge id) kCFBooleanTrue;
    returnDictionary[(__bridge id) kSecClass] = (__bridge id) kSecClassGenericPassword;

    CFTypeRef itemDataRef = nil;

    if (!SecItemCopyMatching((__bridge CFDictionaryRef) returnDictionary, &itemDataRef)) {
        NSData *data = (__bridge_transfer NSData *) itemDataRef;

        [returnDictionary removeObjectForKey:(__bridge id) kSecReturnData];
        NSString *itemData = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        returnDictionary[(__bridge id) kSecValueData] = itemData;
    }

    return returnDictionary;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    returnDictionary[(__bridge id) kSecClass] = (__bridge id) kSecClassGenericPassword;
    NSString *secDataString = dictionaryToConvert[(__bridge id) kSecValueData];
    returnDictionary[(__bridge id) kSecValueData] = [secDataString dataUsingEncoding:NSUTF8StringEncoding];

    return returnDictionary;
}

- (CFTypeRef)performQuery:(NSDictionary *)query {
    CFTypeRef outDictionaryRef = NULL;

    if (SecItemCopyMatching((__bridge CFDictionaryRef) query, &outDictionaryRef) == errSecSuccess)
        return outDictionaryRef;

    return NULL;
}

- (BOOL)hasMoneySource:(YMAMoneySourceModel *)moneySource {
    for (YMAMoneySourceModel *source in self.moneySources) {
        if ([source.panFragment isEqual:moneySource.panFragment])
            return YES;
    }

    return NO;
}

#pragma mark -
#pragma mark *** Getters and setters ***
#pragma mark -

- (NSDictionary *)instanceIdQuery {
    if (!_instanceIdQuery) {
        _instanceIdQuery = [[NSMutableDictionary alloc] init];
        _instanceIdQuery[(__bridge id) kSecClass] = (__bridge id) kSecClassGenericPassword;
        _instanceIdQuery[(__bridge id) kSecAttrGeneric] = kKeychainIdInstance;
        _instanceIdQuery[(__bridge id) kSecMatchLimit] = (__bridge id) kSecMatchLimitOne;
        _instanceIdQuery[(__bridge id) kSecReturnAttributes] = (__bridge id) kCFBooleanTrue;
    }

    return _instanceIdQuery;
}

- (NSDictionary *)moneySourceQuery {
    if (!_moneySourceQuery) {
        _moneySourceQuery = [[NSMutableDictionary alloc] init];
        _moneySourceQuery[(__bridge id) kSecClass] = (__bridge id) kSecClassGenericPassword;
        _moneySourceQuery[(__bridge id) kSecAttrGeneric] = kKeychainMoneySource;
        _moneySourceQuery[(__bridge id) kSecMatchLimit] = (__bridge id) kSecMatchLimitAll;
        _moneySourceQuery[(__bridge id) kSecReturnAttributes] = (__bridge id) kCFBooleanTrue;
    }

    return _moneySourceQuery;
}

- (NSArray *)moneySources {
    NSMutableArray *sources = [NSMutableArray array];
    CFArrayRef outArrayRef = [self performQuery:self.moneySourceQuery];

    if (outArrayRef == NULL)
        return sources;

    for (int i = 0; i < CFArrayGetCount(outArrayRef); i++) {
        SecIdentityRef item = (SecIdentityRef) CFArrayGetValueAtIndex(outArrayRef, i);

        NSMutableDictionary *outDictionary = (__bridge_transfer NSMutableDictionary *) item;
        NSDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];

        NSString *panFragment = queryResult[(__bridge id) kSecAttrAccount];
        NSString *sourceTypeString = queryResult[(__bridge id) kSecAttrLabel];
        NSString *cardTypeString = queryResult[(__bridge id) kSecAttrDescription];
        NSString *moneySourceToken = queryResult[(__bridge id) kSecValueData];
        YMAMoneySourceType sourceType = (YMAMoneySourceType) [sourceTypeString integerValue];
        YMAPaymentCardType cardType = (YMAPaymentCardType) [cardTypeString integerValue];

        YMAMoneySourceModel *moneySource = [YMAMoneySourceModel moneySourceWithType:sourceType cardType:cardType panFragment:panFragment moneySourceToken:moneySourceToken];

        [sources addObject:moneySource];
    };

    return sources;
}

- (NSString *)instanceId {
    CFTypeRef outDictionaryRef = [self performQuery:self.instanceIdQuery];

    if (outDictionaryRef != NULL) {
        NSMutableDictionary *outDictionary = (__bridge_transfer NSMutableDictionary *) outDictionaryRef;
        NSDictionary *queryResult = [self secItemFormatToDictionary:outDictionary];

        return queryResult[(__bridge id) kSecValueData];
    }

    return nil;
}

- (void)setInstanceId:(NSString *)instanceId {
    
    NSMutableDictionary *secItem = [self dictionaryToSecItemFormat:@{(__bridge id) kSecValueData : instanceId}];
    secItem[(__bridge id) kSecAttrGeneric] = kKeychainIdInstance;
    SecItemAdd((__bridge CFDictionaryRef) secItem, NULL);
}

@end