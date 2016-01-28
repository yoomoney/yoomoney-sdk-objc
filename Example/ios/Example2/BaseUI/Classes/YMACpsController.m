//
//  YMACpsController.m
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 17.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMACpsController.h"

@interface YMACpsController ()

@end

@implementation YMACpsController

- (instancetype)initWithClientId:(NSString *)clientId patternId:(NSString *)patternId paymentParameters:(NSDictionary *)paymentParams {
    _cpsViewController = [[YMACpsViewController alloc] initWithClientId:clientId patternId:patternId paymentParameters:paymentParams];

    return [super initWithRootViewController:_cpsViewController];
}


@end
