//
// Created by Александр Мертвецов on 23.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YMADataPosting <NSObject>

/// Request data.
@property(nonatomic, strong, readonly) NSData *data;

@end