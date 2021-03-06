//
//  NSDictionary+YMATools.m
//  YooMoney
//
//  Created by Александр О. Кургин on 02.04.15.
//  Copyright (c) 2020 NBCO YooMoney LLC. All rights reserved.
//

#import "NSDictionary+YMATools.h"

@implementation NSDictionary (YMATools)

- (id)yma_objectForKey:(id)aKey
{
    return [self yma_objectForKey:aKey defaultValue:nil];
}

- (nullable id)yma_objectForKey:(id)aKey defaultValue:(nullable id)defaultValue
{
    id object = [self objectForKey:aKey];
    object = [object isKindOfClass:[NSNull class]] ? defaultValue : object;
    return object;
}

@end
