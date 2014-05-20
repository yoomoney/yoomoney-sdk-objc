//
// Created by mertvetcov on 20.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAUtils.h"


@implementation YMAUtils

+ (NSString *)addPercentEscapesForString:(NSString *)string {
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
            (__bridge CFStringRef)string,
            NULL,
            (CFStringRef)@";/?:@&=+$,",
            kCFStringEncodingUTF8));
}

@end