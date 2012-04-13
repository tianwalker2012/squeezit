//
//  DragableView.m
//  Squeezit
//
//  Created by Apple on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DragableView.h"

@implementation DragableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setScroll:(UIView*) superView enabled:(BOOL)enabled
{
    if(![superView isKindOfClass:[UIScrollView class]]){
        return;
    }
    UIScrollView* scroll = (UIScrollView*)superView;
    scroll.scrollEnabled = enabled;
}

- (CGPoint) getContentOffset:(UIView*)superView
{
    if(![superView isKindOfClass:[UIScrollView class]]){
        return CGPointMake(0, 0);
    }
    UIScrollView* scroll = (UIScrollView*)superView;
    return scroll.contentOffset;
}

// The purpose of this functionality is to shift the contentoffset accordingly
// So that the content will move up or down at the scroll view 
- (void) shiftContentOffset:(UIView*)superView shiftedY:(CGFloat)shiftedY
{
    NSLog(@"Begin to call shift Content, shifted Y:%fl", shiftedY);
    if(![superView isKindOfClass:[UIScrollView class]]){
        return;
    }
    
    NSLog(@"start shifting");
    UIScrollView* scroll = (UIScrollView*)superView;
    if(shiftedY < 0){
        CGPoint contentOffset = scroll.contentOffset;
        CGFloat adjustedY = contentOffset.y + shiftedY;
        if(adjustedY < 0){
            adjustedY = 0;
        }
        [scroll setContentOffset:CGPointMake(contentOffset.x, adjustedY) animated:YES];
        //shiftedY = 0;
    }else if(shiftedY+self.frame.size.height > self.superview.bounds.size.height){
        CGFloat adjustedY = shiftedY+self.frame.size.height - self.superview.bounds.size.height;
        if((adjustedY + scroll.contentOffset.y + self.superview.bounds.size.height) > scroll.contentSize.height){
            adjustedY = scroll.contentSize.height - self.superview.bounds.size.height;
        }
        NSLog(@"AdjustedY: %fl, original contentoffset: %fl", shiftedY, scroll.contentOffset.y);
        [scroll setContentOffset:CGPointMake(scroll.contentOffset.x, adjustedY) animated:YES];
        //shiftedY = self.superview.bounds.size.height - self.frame.size.height;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch began");
    UITouch* touchPoint = [touches anyObject];
    originalFrame = self.frame;
    prevTouchPoint = [touchPoint locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch moved");
    [self setScroll:self.superview enabled:NO];
    UITouch* touchPoint = [touches anyObject];
    CGPoint curPos = self.frame.origin;
    CGPoint moved = [touchPoint locationInView:self.superview];
    float deltaY = moved.y - prevTouchPoint.y;
    float shiftedY = curPos.y + deltaY;
    [self shiftContentOffset:self.superview shiftedY:shiftedY];
    if(shiftedY < 0){
        shiftedY = 0;
    }else if(shiftedY+self.frame.size.height > self.superview.bounds.size.height){
        shiftedY = self.superview.bounds.size.height - self.frame.size.height;
    }
    self.frame = CGRectMake(curPos.x, shiftedY, self.frame.size.width, self.frame.size.height);
    prevTouchPoint = moved;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch ended");
    [self setScroll:self.superview enabled:YES];
    [self touchesMoved:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch cancelled, time to return to where is belonging to");
    self.frame = originalFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
