//
// Created by mertvetcov on 22.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMAAvatar : NSObject

+ (instancetype)avatarWithUrl:(NSURL *)url timeStamp:(NSDate *)timeStamp;

@property(nonatomic, strong, readonly) NSURL *url;
@property(nonatomic, strong, readonly) NSDate *timeStamp;

@end