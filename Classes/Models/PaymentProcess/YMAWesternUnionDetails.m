
#import "YMAWesternUnionDetails.h"

static NSString *const kMtcnKey = @"mtcn";
static NSString *const kRecevierAmountKey = @"receiver_amount";
static NSString *const kReceiverCurrencyKey = @"receiver_currency";

@implementation YMAWesternUnionDetails

- (instancetype)initWithMtcn:(nullable NSString *)mtcn
              receiverAmount:(NSString *)receiverAmount
            receiverCurrency:(NSString *)receiverCurrency
{
    self = [super init];
    if (self != nil) {
        _mtcn = [mtcn copy];
        _receiverAmount = [receiverAmount copy];
        _receiverCurrency = [receiverCurrency copy];
    }
    return self;
}

+ (instancetype)westernUnionDetailsWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary
{
    return [[self alloc] initWithMtcn:dictionary[kMtcnKey]
                       receiverAmount:dictionary[kRecevierAmountKey]
                     receiverCurrency:dictionary[kReceiverCurrencyKey]];
}

@end