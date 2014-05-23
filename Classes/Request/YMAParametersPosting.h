//
// Created by Alexander Mertvetsov on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YMAParametersPosting <NSObject>

/// Request parameters.
@property(nonatomic, strong, readonly) NSDictionary *parameters;

@end