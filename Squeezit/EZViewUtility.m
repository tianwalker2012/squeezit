//
//  EZViewUtility.m
//  Squeezit
//
//  Created by Apple on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZViewUtility.h"

@implementation EZViewUtility

/**
    UIViewAutoresizingNone                 = 0,
    UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
    UIViewAutoresizingFlexibleWidth        = 1 << 1,
    UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
    UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
    UIViewAutoresizingFlexibleHeight       = 1 << 4,
    UIViewAutoresizingFlexibleBottomMargin = 1 << 5
**/

+ (NSString*) printAutoResizeMask:(UIView*)view
{
    static int masks[] = {1, 2, 4, 8, 16, 32};
    static NSString* maskNames[] = {@"LeftMargin",@"Width", @"RightMargin",
        @"TopMargin", @"Height"
        @"BottomMargin"};
    NSMutableArray* res = [[NSMutableArray alloc] init];
    for(int i=0; i < 6; i++){
        if((masks[i] & view.autoresizingMask) > 0){
            [res addObject:maskNames[i]];
        }
    }
    if([res count] == 0){
        [res addObject:@"None"];
    }
    NSMutableString* resStr = [[NSMutableString alloc] init];
    for(NSString* str in res){
        [resStr appendString:[NSString stringWithFormat:@"%@,",str]];
    }
    
    return resStr;
}

@end
