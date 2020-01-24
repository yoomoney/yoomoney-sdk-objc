#import "NSData+HtmlEscapeFixing.h"

@implementation NSData (HtmlEscapeFixing)

- (NSData *)yma_fixHtmlEscapeWithEncoding:(NSStringEncoding)encoding {
    static NSDictionary *mapping = nil;
    static NSNumberFormatter *unicodeParser = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{
                @"&amp;": @"&",
                @"&#153;": @"\u2122"
        };
        unicodeParser = [[NSNumberFormatter alloc] init];
    });

    NSMutableString *stringData = [[NSMutableString alloc] initWithData:self
                                                               encoding:encoding];

    NSUInteger escapeIndexStart = NSUIntegerMax;

    for (NSUInteger i = 0; i < stringData.length; ++i) {
        if ([stringData characterAtIndex:i] == '&') {
            escapeIndexStart = i;
        } else if ([stringData characterAtIndex:i] == ';' && escapeIndexStart != NSUIntegerMax) {
            NSRange range = NSMakeRange(escapeIndexStart, i - escapeIndexStart + 1);
            NSString *escapeString = [stringData substringWithRange:range];
            NSString *replaceString = mapping[escapeString];

            if (replaceString == nil && [escapeString length] <= 7 && [escapeString characterAtIndex:1] == '#') {
                NSCharacterSet *nonDigitSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                NSRange digitRange = NSMakeRange(2, escapeString.length - 3);
                NSString *digitString = [escapeString substringWithRange:digitRange];
                if (digitString.length > 0 && [digitString rangeOfCharacterFromSet:nonDigitSet].location == NSNotFound) {
                    unichar symbol = [[unicodeParser numberFromString:digitString] unsignedShortValue];
                    replaceString = [NSString stringWithFormat:@"%C", symbol];
                }
            }

            if (replaceString != nil) {
                [stringData replaceCharactersInRange:range withString:replaceString];
                i = escapeIndexStart + replaceString.length - 1;
            }

            escapeIndexStart = NSUIntegerMax;
        }
    }

    return [stringData dataUsingEncoding:encoding];

}

@end