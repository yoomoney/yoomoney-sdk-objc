//
//  YMALocalization.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 06.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMALocalization.h"


static NSBundle *stringBundle = nil;
static NSBundle *imageBundle = nil;

@implementation YMALocalization

+ (NSString *)stringByKey:(NSString *)key {

    if (stringBundle == nil) {
        NSString *libraryBundlePath = [[NSBundle mainBundle] pathForResource:@"uiymcpssdkios"
                                                                      ofType:@"bundle"];

        NSBundle *libraryBundle = [NSBundle bundleWithPath:libraryBundlePath];
        NSString *langID = [NSLocale preferredLanguages][0];
        NSString *path = [libraryBundle pathForResource:[langID substringToIndex:2] ofType:@"lproj"];
        stringBundle = [NSBundle bundleWithPath:path];

    }

    NSString *result = [stringBundle localizedStringForKey:key value:@"" table:nil];
    if (result == nil) {
        result = key;
    }
    
    return result;
}

+ (UIImage *)imageByKey:(NSString *)key {

    if (!imageBundle) {
        NSString *libraryBundlePath = [[NSBundle mainBundle] pathForResource:@"uiymcpssdkios"
                                                                      ofType:@"bundle"];

        imageBundle = [NSBundle bundleWithPath:libraryBundlePath];
    }

    NSString *imagePath = [imageBundle pathForResource:key ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
