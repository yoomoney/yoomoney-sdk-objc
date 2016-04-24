/*!
 @class YMAWesternUnionDetails
 @version 4.5
 @author Dmitry Shakolo
 @creation_date 04.03.16
 @copyright Copyright (c) 2016 NBCO Yandex.Money LLC. All rights reserved.
 @discussion Western Union details model
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface YMAWesternUnionDetails : NSObject

@property (nonatomic, copy, nullable, readonly) NSString *mtcn;
@property (nonatomic, copy, readonly) NSString *receiverAmount;
@property (nonatomic, copy, readonly) NSString *receiverCurrency;
@property (nonatomic, copy, readonly) NSString *myWu;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMtcn:(nullable NSString *)mtcn
              receiverAmount:(NSString *)receiverAmount
            receiverCurrency:(NSString *)receiverCurrency
                        myWu:(NSString *)myWu NS_DESIGNATED_INITIALIZER;

+ (instancetype)westernUnionDetailsWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary;

@end

NS_ASSUME_NONNULL_END