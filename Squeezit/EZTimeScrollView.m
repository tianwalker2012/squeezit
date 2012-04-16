//
//  EZTimeScrollView.m
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTimeScrollView.h"
#import "Constants.h"
#import "EZTimeInfo.h"
#import <math.h>

@implementation EZTimeScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // self.autoresizingMask = 
    }
    return self;
}



/** //Comment following out. Because the scroll effect not implemented in the 
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect current rect: %@", NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray* timeInfos = [self getTimeInfo:rect];
    [timeInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EZTimeInfo* info = (EZTimeInfo*) obj;
        [self drawTimeInfo:info context:context];
    }];
    //[self drawLine:context start:CGPointMake(44, 44) end:CGPointMake(self.frame.size.width, 44)];
    NSLog(@"Before release context");
    //CGContextRelease(context);
}
**/



@end
