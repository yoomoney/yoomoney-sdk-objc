//
//  YMACpsController.h
//  ui-cps-sdk-ios
//
//  Created by Alexander Mertvetsov on 17.02.14.
//  Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMACpsViewController.h"

@interface YMACpsController : UINavigationController

- (instancetype)initWithClientId:(NSString *)clientId patternId:(NSString *)patternId paymentParameters:(NSDictionary *)paymentParams NS_DESIGNATED_INITIALIZER;

@property(nonatomic, strong, readonly) YMACpsViewController *cpsViewController;

@end
