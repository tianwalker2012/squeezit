//
//  EZObject.m
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZObject.h"

@implementation EZObject

- (id) init
{
    self = [super init];
    NSLog(@"init:%@", [NSThread callStackSymbols]);
    return self;
}

- (void) dealloc
{
    NSLog(@"deallocted:%@", [NSThread callStackSymbols]);
}

@end
