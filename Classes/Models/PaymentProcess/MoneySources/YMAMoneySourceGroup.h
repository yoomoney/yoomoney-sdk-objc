//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YMAMoneySourceGroup : NSObject

- (id)initWithAllowed:(BOOL)allowed;

@property(nonatomic, assign, readonly) BOOL isAllowed;

@end