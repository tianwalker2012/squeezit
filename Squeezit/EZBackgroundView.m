//
//  EZBackgroundView.m
//  Squeezit
//
//  Created by Apple on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBackgroundView.h"
#import "Constants.h"
#import "EZTimeInfo.h"
#import "EZGlobalLocalize.h"

@implementation EZBackgroundView

static NSString* timeText[] = {@"Morning",@"Morning"};


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


//  According to rect and current contentOffset generate a list of Lines which you can draw
- (NSArray*) getTimeInfo:(CGRect)rect
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    CGFloat offsetY = PAGE_HEAD;
    //CGFloat accumulated = 0;
    //int startBar = offsetY/ScrollStep;
    int startBar = 0;
    int innerOffset = offsetY;
    
    while(startBar < 49){
        if((startBar % 2) == 0){
            int time = (49-startBar)/2;
            NSString* morningSign = EZLocalizedString(@"Morning", @"Morning");
            if(time > 12){
                morningSign = EZLocalizedString(@"Afternoon", @"Afternoon");
                time = time - 12;
            }else if(time == 12){
                morningSign = EZLocalizedString(@"Noon", @"Noon");
            }
            
            NSString* keyStr = [NSString stringWithFormat:EZLocalizedString(@"%dclock",@""),time];
            NSString* timeStr = EZLocalizedString(keyStr,@"Time");
            NSLog(@"Time:%@, morningSign:%@",timeStr, morningSign);
            EZTimeInfo* info = [[EZTimeInfo alloc] initWith:morningSign time:timeStr start:CGPointMake(100, innerOffset) end:CGPointMake(rect.size.width,innerOffset) isDotted:NO];
            [res addObject:info];
        }else{
            EZTimeInfo* info = [[EZTimeInfo alloc] initWith:nil time:nil start:CGPointMake(100, innerOffset) end:CGPointMake(rect.size.width,innerOffset) isDotted:YES];
            [res addObject:info];
        }
        innerOffset += ScrollStep;
        ++startBar;
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

- (void) drawText:(CGContextRef)context position:(CGPoint)pos text:(NSString*)text
{
    CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 1.0);
   
    //Let's experiment difference of different mode
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
    // Next we set the text matrix to flip our text upside down. We do this because the context itself
    // is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    // And now we actually draw some text. This screen will demonstrate the typical drawing modes used.
    CGContextSetTextDrawingMode(context, kCGTextFill);
    //char* cText = [text cStringUsingEncoding:NSMacOSRomanStringEncoding];
    CGContextShowTextAtPoint(context, pos.x, pos.y, [text cStringUsingEncoding:NSMacOSRomanStringEncoding], [text lengthOfBytesUsingEncoding:NSMacOSRomanStringEncoding]);
}

- (void) drawTimeInfo:(EZTimeInfo*)info context:(CGContextRef)context
{
    //NSLog(@"Draw information, the isDotted is enabled %@", info.isDotted?@"YES":@"NO");
    if(info.isDotted){
        CGContextSaveGState(context);
        CGContextSetRGBStrokeColor(context, 0.8 , 0.8, 0.8, 1);
        CGFloat patterns[] = {1,1};
        CGContextSetLineDash(context, 1, patterns, 2);
        CGContextSetLineWidth(context, 1);
        
        CGContextMoveToPoint(context, info.start.x , info.start.y);
        CGContextAddLineToPoint(context, info.end.x, info.end.y);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        return;
    }else{
        CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2, 1);
        [self drawText:context position:CGPointMake(5, info.start.y) text:info.timeStr];
    }
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, info.start.x , info.start.y);
    CGContextAddLineToPoint(context, info.end.x, info.end.y);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect current rect: %@", NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    //[self drawText:context position:CGPointMake(20, 50) text:@"I love you"];
    NSArray* timeInfos = [self getTimeInfo:rect];
    [timeInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EZTimeInfo* info = (EZTimeInfo*) obj;
        [self drawTimeInfo:info context:context];
    }];
    //[self drawLine:context start:CGPointMake(44, 44) end:CGPointMake(self.frame.size.width, 44)];
    NSLog(@"Before release context");
    //CGContextRelease(context);
}






@end
