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
        // Initialization code
        NSLog(@"Initialize completed");
        //self.delegate = self;
    }
    return self;
}

// The purpose of this is to detect the scroll movement so that we can start draw the back ground.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    NSLog(@"scrollViewDidScroll get called");
    [self setNeedsDisplay];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"ScrollViewWillBeginDragging");
}

//  According to rect and current contentOffset generate a list of Lines which you can draw
- (NSArray*) getTimeInfo:(CGRect)rect
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    CGPoint offset = self.contentOffset;
    CGFloat offsetY = offset.y;
    //CGFloat accumulated = 0;
    int startBar = offsetY/ScrollStep;
    int innerOffset = (int)offsetY % ScrollStep;
    if(innerOffset > 0){
        ++startBar;
    }
    int count = 0;
    while(innerOffset < rect.size.height){
        //innerOffset += ScrollStep;
        // ++count;
        ++startBar;
        if((startBar % 2) == 1){
            EZTimeInfo* info = [[EZTimeInfo alloc] initWith:@"上午" time:[NSString stringWithFormat:@"%i",startBar/2] start:CGPointMake(100, innerOffset) end:CGPointMake(rect.size.width,innerOffset) isDotted:NO];
            [res addObject:info];
        }else{
            EZTimeInfo* info = [[EZTimeInfo alloc] initWith:nil time:nil start:CGPointMake(100, innerOffset) end:CGPointMake(rect.size.width,innerOffset) isDotted:YES];
            [res addObject:info];
        }
        innerOffset += ScrollStep;
    }
    return res;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawLine:(CGContextRef)context start:(CGPoint)start end:(CGPoint)end
{
    CGContextSetRGBStrokeColor(context, 0.4 , 0.4, 0.4, 1);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, start.x , start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextStrokePath(context);
}

- (void) drawTimeInfo:(EZTimeInfo*)info context:(CGContextRef)context
{
    NSLog(@"Draw information, the isDotted is enabled %@", info.isDotted?@"YES":@"NO");
    if(info.isDotted){
        CGContextSetRGBStrokeColor(context, 0.8 , 0.8, 0.8, 1);
    }else{
        CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2, 1);
    }
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, info.start.x , info.start.y);
    CGContextAddLineToPoint(context, info.end.x, info.end.y);
    CGContextStrokePath(context);
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
