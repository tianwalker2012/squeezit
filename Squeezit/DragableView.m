//
//  DragableView.m
//  Squeezit
//
//  Created by Apple on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DragableView.h"
#import "Constants.h"

@implementation DragableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        animationGoing = false;
        
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

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    NSLog(@"Animation did stop, callstack:%@",[NSThread callStackSymbols]);
    animationGoing = false;
    if(moveUp){
        [self relocateSelf:self.superview shifted:-1];
    }else{
        [self relocateSelf:self.superview shifted:MAXFLOAT];
    }
}

- (void) scrollTo:(UIScrollView*)view offset:(CGPoint)offset animated:(BOOL)animated
{
    //NSLog(@"ScrollTo get called, offset:%@",NSStringFromCGPoint(offset));
    if(animationGoing){
        //NSLog(@"Animation are going, do nothing");
        return;
    }
    animationGoing = true;
    if(animated){
        [UIView beginAnimations:@"scroll" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:2];
        view.contentOffset = offset;
        [UIView commitAnimations];
    }else{
        view.contentOffset = offset;
    }
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
    CGPoint contentOffset = scroll.contentOffset;
    CGFloat beginningY = contentOffset.y;
    CGFloat endingY = contentOffset.y + scroll.frame.size.height;
    
    if(shiftedY < beginningY){
        moveUp = true;
        if((contentOffset.y-ScrollStep) >= 0.0){
            [self scrollTo:scroll offset:CGPointMake(contentOffset.x, contentOffset.y-ScrollStep) animated:YES];
        }else{
            [self scrollTo:scroll offset:CGPointMake(contentOffset.x, 0.0) animated:YES];
        }

    }else if(shiftedY+self.frame.size.height > endingY){
        moveUp = false;
        CGFloat limit = HEIGHT-scroll.frame.size.height;
        if((contentOffset.y+ScrollStep) <= limit){
            [self scrollTo:scroll offset:CGPointMake(contentOffset.x, contentOffset.y+ScrollStep) animated:YES];
        }else {
            [self scrollTo:scroll offset:CGPointMake(contentOffset.x, limit) animated:YES];
        }
        
    }
}

- (void) relocateSelf:(UIView*)superView shifted:(CGFloat)shiftedY
{
    CGPoint curPos = self.frame.origin;
    //If our superView is not scroll view than noraml way to treat it is ok for us.
    if(![superView isKindOfClass:[UIScrollView class]]){
        if(shiftedY < 0){
            shiftedY = 0;
        }else if(shiftedY+self.frame.size.height > self.superview.bounds.size.height){
            shiftedY = self.superview.bounds.size.height - self.frame.size.height;
        }
        self.frame = CGRectMake(curPos.x, shiftedY, self.frame.size.width, self.frame.size.height);
        return;
    }
    UIScrollView* scroll = (UIScrollView*)superView;
    CGPoint contentOffset = scroll.contentOffset;
    CGFloat beginningY = contentOffset.y;
    CGFloat endingY = contentOffset.y + scroll.frame.size.height;
    if(shiftedY < beginningY){
        shiftedY = beginningY;
    }else if(shiftedY+self.frame.size.height > endingY){
        shiftedY = endingY - self.frame.size.height;
    }
    self.frame = CGRectMake(curPos.x, shiftedY, self.frame.size.width, self.frame.size.height);

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
    [self relocateSelf:self.superview shifted:shiftedY];
    prevTouchPoint = moved;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch ended");
    [self touchesMoved:touches withEvent:event];
    [self setScroll:self.superview enabled:YES];
    
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
