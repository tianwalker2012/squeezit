//
//  DragableView.m
//  Squeezit
//
//  Created by Apple on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DragableView.h"
#import "Constants.h"
#import  <QuartzCore/QuartzCore.h>

@interface CycleView : UIView
{
    id<StretchTouchHandler> stretchHandler;
}

@end

@implementation CycleView

- (id) initWithFrame:(CGRect)frame handler:(id<StretchTouchHandler>)handler
{
    self = [super initWithFrame:frame];
    stretchHandler = handler;
    return self;
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, CycleStroke);
    CGContextSetRGBStrokeColor(context, 0.8, 0.2, 0.2, 1);
    CGContextSetRGBFillColor(context, 0.7, 0.4, 0.4, 1);
    CGContextAddEllipseInRect(context, CGRectInset(rect, CycleStroke, CycleStroke));
    CGContextFillEllipseInRect(context, CGRectInset(rect, CycleStroke*2, CycleStroke*2));
    CGContextStrokePath(context);
    NSLog(@"Draw a cycle");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [stretchHandler stretchTouchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [stretchHandler stretchTouchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [stretchHandler stretchTouchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [stretchHandler stretchTouchesCancelled:touches withEvent:event];
}

@end


//Following is the explaination for the weired implementation
//The purpose of the background is to make sure the StretchCycle get the right touch event.
//The rationale behind this is, the stretch point is just 6 point in diameter, but for user to touch 
//it effectively, it is actually 44*44 touch zone. 
//We need to extend the parent view to hold this touch zone. 
//I wish this explaination is clear enough for you to understand. 
//Any question: sunnyskyunix#gmail.com

@implementation DragableView
@synthesize container, background;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        animationGoing = false;
        dragModel = false;
        stretchModel = false;
        CGRect bkFrame = CGRectInset(frame, 0 , TouchZone/2);
        bkFrame.origin = CGPointMake(0, TouchZone/2);
        background = [[UIView alloc] initWithFrame:bkFrame];
        [self addSubview:background];
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
        
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
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:0.3];
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

- (void)stretchTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    stretchModel = true;
    [container setScrollEnabled:NO];
    [container stretchBegan:self];
    UITouch* touch = (UITouch*)[touches anyObject];
    prevStretchPoint = [touch locationInView:self.superview];
    NSLog(@"Stretch begen, %@",NSStringFromCGPoint(prevStretchPoint));
}

//What's the responsibility
//Now keep it simple and stupid, that is do nothing. 
//Later the rotation fit will be done in this method
- (void) adjustToFrame:(CGRect)frame
{
    [self setFrame:frame];
    [background setFrame:CGRectMake(0, 22, frame.size.width, frame.size.height - UNIT_HEIGHT)];
    [self adjustStretchControl];
}

-(void) topStretched:(CGPoint)curStretchPoint deltaY:(CGFloat)deltaY
{
    CGRect curRect = self.frame;
    curRect.origin.y = curRect.origin.y - deltaY;
    curRect.size.height = curRect.size.height + deltaY;
    if(curRect.origin.y < UpLimit){
        CGFloat compensite = curRect.origin.y - UpLimit;
        curRect.origin.y = UpLimit;
        curRect.size.height = curRect.size.height + compensite;
    }
    
   
    //CGRect normalized = [container normalizeFrame:curRect];
    if(curRect.size.height < MINI_HEIGHT){
        CGFloat originAdjust = MINI_HEIGHT - curRect.size.height;
        curRect.origin.y = curRect.origin.y - originAdjust;
        curRect.size.height = MINI_HEIGHT;
    }
    [self adjustToFrame:curRect];
}

-(void) bottomStretched:(CGPoint)curStretchPoint deltaY:(CGFloat)deltaY
{
    CGRect curRect = self.frame;
    curRect.size.height = curRect.size.height - deltaY;
    //CGRect normalized = [container normalizeFrame:curRect];
    if(curRect.size.height < MINI_HEIGHT){
        curRect.size.height = MINI_HEIGHT;
    }else if(curRect.origin.y+curRect.size.height > BottomLimit){
        //CGFloat compensite = curRect.origin.y+curRect.size.height - BottomLimit;
        curRect.size.height = BottomLimit - curRect.origin.y;
    }
    [self adjustToFrame:curRect];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    NSLog(@"StretchAnimationStopped, stretchModel:%@", stretchModel?@"YES":@"NO");
    if(!stretchModel){
        NSLog(@"Not in strechModel anymore");
        //Recover old delegate
        scrollView.delegate = container;
        return;
    }
    CGPoint tp = [recordedStretchTouch locationInView:self.window];
    //Keep it simple and stupid
    if(tp.y < UpperScrollZone){
        [self topStretched:tp deltaY:ScrollStep];
    }else if(tp.y > BottomScrollZone){
        [self bottomStretched:tp deltaY:-ScrollStep];
    }
    [self stretchScoll:recordedStretchTouch];
    
}
// Brief description about the method
// Check the StretchCycle's position if it is on the scroll region.
// If it is and content size is scrollable, I will scroll the view accordingly. 
- (void) stretchScoll:(UITouch*)touch
{
    currentStretchTouch = touch;
    UIView* touchedView = touch.view;
    UIWindow* window = touchedView.window;
    CGRect winRect = [window convertRect:touchedView.frame fromView:touchedView.superview];
    NSLog(@"Strech Rect:%@",NSStringFromCGRect(winRect));
    if(touchedView == topCycle){
        if(winRect.origin.y < UpperScrollZone){
            [container scrollStep:-ScrollStep stopDelegate:self];   
        }
    }else{
        if(winRect.origin.y+winRect.size.height > BottomScrollZone){
            [container scrollStep:ScrollStep stopDelegate:self];
        }
    }
}

- (void)stretchTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = (UITouch*)[touches anyObject];
    CGPoint curStretchPoint = [touch locationInView:self.superview];
    CGFloat deltaY = prevStretchPoint.y - curStretchPoint.y;
    NSLog(@"currStretchPoint:%@,previousStretchPoint:%@,deltaY:%fl",NSStringFromCGPoint(curStretchPoint),NSStringFromCGPoint(prevStretchPoint),deltaY);
    if(touch.view == topCycle){
        [self topStretched:curStretchPoint deltaY:deltaY];
    }else{
        [self bottomStretched:curStretchPoint deltaY:deltaY];
    }
    [self stretchScoll:touch];
    [container stretchMoved:self];
    prevStretchPoint = curStretchPoint;
    recordedStretchTouch = touch; 
    NSLog(@"Stretch moved");
}

- (void)stretchTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [container setScrollEnabled:YES];
    //Will add normalize code here.
    //Should we call again.
    [container stretchEnded:self];
    stretchModel = false;
    NSLog(@"Stretch ended");
}

- (void)stretchTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [container setScrollEnabled:YES];
    stretchModel = false;
    NSLog(@"Stretch cancelled");
}

- (void) adjustStretchControl
{
    topCycle.center = CGPointMake(0.8*self.bounds.size.width, TouchZone/2);
    bottomCycle.center = CGPointMake(0.2*self.bounds.size.width, self.bounds.size.height - TouchZone/2);
    NSLog(@"SelfBounds:%@,topCycle:%@,bottomCycle:%@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(topCycle.frame),NSStringFromCGRect(bottomCycle.frame));
}

- (void) addStretchControl
{
    //CGRect bounds = self.bounds;
    if(!topCycle){
        topCycle = [[CycleView alloc] initWithFrame:CGRectMake(0, 0, DragCycleSize, DragCycleSize) handler:self];
        bottomCycle = [[CycleView alloc] initWithFrame:CGRectMake(0, 0, DragCycleSize, DragCycleSize)handler:self];
        topCycle.backgroundColor = [UIColor clearColor];
        bottomCycle.backgroundColor = [UIColor clearColor];
    }
    [self adjustStretchControl];
    [self addSubview:topCycle];
    [self addSubview:bottomCycle];
}



- (void) disableDraggable
{
    dragModel = false;
    [topCycle removeFromSuperview];
    [bottomCycle removeFromSuperview];
}

//The purpose of this method is to copy src view's look to dest UIView as a image.
//Do I need image of not. I am not sure. Let's go ahead. 
- (void) copyView:(UIView*)src to:(UIView*)dest
{
    UIGraphicsBeginImageContext(dest.bounds.size);
    [src.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* imgView = [[UIImageView alloc] initWithImage:img];
    [dest addSubview:imgView];
}

- (void) addShadow
{
    UIWindow* window = self.window;
    parent = self.superview;
    oldLocation = self.frame;
    CGRect converted = [window convertRect:oldLocation fromView:parent];
    CGRect alterConverted = [parent convertRect:oldLocation toView:window];
    NSLog(@"Original:%@,Converted:%@, alterConverted:%@",NSStringFromCGRect(oldLocation),NSStringFromCGRect(converted), NSStringFromCGRect(alterConverted));
    //CGRect adjusted = CGRectInset(converted, 0, -CycleStroke/2);
    NSLog(@"oldRect:%@, converted:%@",NSStringFromCGRect(oldLocation),NSStringFromCGRect(converted));
    
    shadow = [[UIView alloc] initWithFrame:converted];
    shadow.alpha = 0.7;
    [self copyView:self to:shadow];
    //shadow.backgroundColor = [UIColor colorWithRed:0.6 green:0.4 blue:0.4 alpha:0.7];
    //self.frame = converted;
    [self.window addSubview:shadow];
    //I guess will have some flash effect, so better prepared a image UIView first. 
    // do it at the next iteration
}

- (void) longPressed
{
    dragModel = true;
    NSLog(@"Long Pressed");
    [container setDraggableView:self];
    [self addStretchControl];
    [self addShadow];
}

//Will be called when dropped
- (void) putBack
{
    CGRect position = [parent convertRect:shadow.frame fromView:shadow.window];
    NSLog(@"Put back, original frame:%@, converted:%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(position));
    self.frame = position;
    [shadow removeFromSuperview];
    //[parent addSubview:self];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch began");
    if(!dragModel){
        [self performSelector:@selector(longPressed) withObject:nil afterDelay:LONG_TOUCH];
    }else{
        [container setDraggableView:self];
        [self addShadow];
    }
    UITouch* touchPoint = [touches anyObject];
    originalFrame = self.frame;
    prevTouchPoint = [touchPoint locationInView:self.window];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Only dragable when in dragModel
    if(!dragModel){
        return;
    }
    NSLog(@"Touch moved");
    //[self setScroll:self.superview enabled:NO];
    UITouch* touchPoint = [touches anyObject];
    CGPoint curPos = shadow.frame.origin;
    CGPoint moved = [touchPoint locationInView:shadow.window];
    float deltaY = moved.y - prevTouchPoint.y;
    float deltaX = moved.x - prevTouchPoint.x;
    float shiftedY = curPos.y + deltaY;
    float shiftedX = curPos.x + deltaX;
    //[self shiftContentOffset:self.superview shiftedY:shiftedY];
    //[self relocateSelf:self.superview shifted:shiftedY];
    shadow.frame = CGRectMake(shiftedX, shiftedY, shadow.frame.size.width, shadow.frame.size.height);
    prevTouchPoint = moved;
    [container moveDetection:shadow];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch ended");
    if(!dragModel){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        return;
    }
    [self touchesMoved:touches withEvent:event];
    [self putBack];
    [container dropView:self];
    [container dismissShadow:shadow];
    //[self setScroll:self.superview enabled:YES];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch cancelled, time to return to where is belonging to");
    self.frame = originalFrame;
    [shadow removeFromSuperview];
    [container dismissShadow:shadow];
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
