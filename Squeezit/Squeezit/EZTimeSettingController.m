//
//  EZTimeSettingController.m
//  Squeezit
//
//  Created by Apple on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTimeSettingController.h"
#import "DragableView.h"
#import "EZButton.h"
#import "Constants.h"
#import "EZTimeScrollView.h"
#import "EZBackgroundView.h"
#import "EZViewUtility.h"
#import "EZGlobalLocalize.h"

@implementation EZTimeSettingController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = EZLocalizedString(@"Time Setting", @"Time Setting");
        self.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:1];
        self.tabBarItem.title = @"Setting";
    }
    return self;
}

- (void) scrollAnimStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    //NSLog(@"Stop get called, threadid:%i, callback: %@", (int)[NSThread currentThread], [NSThread callStackSymbols]);
    NSLog(@"Scroll stopped, call the move detection again");
    UIView* draggable = (__bridge UIView*)context;
    [self moveDetection:draggable];
}

//Under following circumstance, I assume only the 
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void) moveDetection:(UIView*)draggable
{
    UIView* grandPa = scrollView.superview;
    CGRect dragRect = [grandPa convertRect:draggable.frame fromView:draggable.superview];
    NSLog(@"move dragRect:%@, scrollView:%@",NSStringFromCGRect(dragRect), NSStringFromCGRect(scrollView.frame));
    if(CGRectContainsRect(scrollView.frame, dragRect)){
        NSLog(@"No scroll is need");
        return;
    }else if(dragRect.origin.y > scrollView.frame.origin.y && (dragRect.origin.y+dragRect.size.height) <  (scrollView.frame.origin.y+scrollView.frame.size.height)){
        NSLog(@"Will scroll horizontally");
    }else{
        CGRect insetRect = CGRectIntersection(scrollView.frame, dragRect);
        //deltaOY = (dragRect.origin.y - insetRect.origin.y)/;
        CGFloat velocity = (dragRect.size.height - insetRect.size.height)/dragRect.size.height;
        CGFloat prevOffsetY = scrollView.contentOffset.y;
        CGFloat animDuration = SCROLL_DURATION/velocity;
        CGFloat changeOffsetY = prevOffsetY;
        if(dragRect.origin.y < insetRect.origin.y){//Will scroll up.
            changeOffsetY = prevOffsetY - SCROLL_UNIT;
            if(changeOffsetY < 0.0f){
                changeOffsetY = 0.0f;
            }
        } else {
            changeOffsetY = prevOffsetY + SCROLL_UNIT;
            if((changeOffsetY+scrollView.frame.size.height) > scrollView.contentSize.height){
                changeOffsetY = scrollView.contentSize.height - scrollView.frame.size.height;
            }
        }
        
        //Will start scroll animation if the scroll happened.
        UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 44,44)];
        tmpView.backgroundColor = [UIColor redColor];
        [self.view.window addSubview:tmpView];
        //scrollView.delegate = self;
        
        if(prevOffsetY != changeOffsetY){
            NSLog(@"AnimationDurition:%fl",animDuration);
            [UIView beginAnimations:@"Scroll" context:(void*)draggable];
            [UIView setAnimationDuration:animDuration];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(scrollAnimStopped:finished:context:)];
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, changeOffsetY);
            tmpView.alpha = 0.2;
            [UIView commitAnimations];
        } else {
            NSLog(@"Nothing changed, stop calling");
        }
        ///[scrollView setContentOffset:<#(CGPoint)#> animated:<#(BOOL)#>];
    }
    
}

- (void) dropView:(UIView*)droped
{
    NSLog(@"Will reposition view:%@",NSStringFromCGRect(droped.frame));
    [scrollView setScrollEnabled:YES];
}

- (void) setDraggableView:(UIView*)draggable
{
    [scrollView setScrollEnabled:false];
    if(activeDragableView == draggable){
        return;
    }
    [activeDragableView disableDraggable];
    activeDragableView = (DragableView*)draggable;
    NSLog(@"setDraggableView get called");
    
    //activeDragableView = dragView;
}

- (void) createTimeBoxStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    //NSLog(@"Stop get called, threadid:%i, callback: %@", (int)[NSThread currentThread], [NSThread callStackSymbols]);
    NSLog(@"I will jump to another controller later");
}

// Create the TimeSpan box at the position and jump to the setting controller
- (void) createTimeSpanAndJump:(int)touchedTime positionY:(CGFloat)y
{
    NSLog(@"toucheTime:%d, position:%fl",touchedTime,y);
    DragableView* dragableView = [[DragableView alloc] initWithFrame:CGRectMake(TIME_BEGIN, y, self.view.bounds.size.width-TIME_BEGIN, UNIT_HEIGHT)];
    dragableView.backgroundColor = [UIColor colorWithRed:0.8 green:0.5 blue:0.5 alpha:1];
    dragableView.alpha = 0.0;
    dragableView.autoresizingMask = UIViewAutoresizingFlexibleWidth; 
    [scrollView addSubview:dragableView];
    
    [UIView beginAnimations:@"generateView" context:nil];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:dragableView cache:NO];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(createTimeBoxStopped:finished:context:)];
    dragableView.alpha = 0.6;
    [UIView commitAnimations];
    dragableView.container = self;
}

// Once I get touch ended event
// What I should do? 
// I assume the touch event on the existing event will not show on me.
// How many cases the touch end will be on me? 
// One cases, that is the user want to create 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch end count: %d",[touches count]);
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    CGFloat touchY = touchPoint.y - PAGE_HEAD;
    int touchedTime = touchY/UNIT_HEIGHT;
    CGFloat y = PAGE_HEAD + touchedTime*UNIT_HEIGHT;
    [activeDragableView disableDraggable];
    activeDragableView = nil;
    [self createTimeSpanAndJump:touchedTime positionY:y];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TimeSetting, touch cancelled");
}

- (void)done
{

    NSLog(@"done get called");
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
}

- (void)cancel
{
    NSLog(@"cancel get called");
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];   
}

- (void)edit
{
    NSLog(@"Edit get called");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
}

- (void) loadView 
{
    [super loadView];
    //scrollView.contentSize = CGSizeMake(, );
}

// The purpose of this functionality is to make the stop are really get call back. 
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    //NSLog(@"Stop get called, threadid:%i, callback: %@", (int)[NSThread currentThread], [NSThread callStackSymbols]);
}

- (void) buttonTapped
{
    //scrollView.scrollIndicatorInsets
    NSLog(@"Button clicked, move the offset, thread id:%i",(int)[NSThread currentThread]);
    NSLog(@"ScrollView mask change: %@",[EZViewUtility printAutoResizeMask:scrollView]);
    
    [UIView beginAnimations:@"Scroll" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.5];
    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+20);
    [UIView commitAnimations];
     

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Timesetting view resizing: %@",[EZViewUtility printAutoResizeMask:self.view]);
    DragableView* block1 = [[DragableView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    block1.backgroundColor = [UIColor redColor];
    scrollView = [[EZTimeScrollView alloc] initWithFrame:CGRectZero];
    NSLog(@"scrollView resizing:%@",[EZViewUtility printAutoResizeMask:scrollView]);
    background = [[EZBackgroundView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT)];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    background.backgroundColor = [UIColor whiteColor];
    background.touchHandler = self;
    NSLog(@"background setting:%@",[EZViewUtility printAutoResizeMask:background]);
  
    [scrollView addSubview:background];
    [self.view addSubview:scrollView];

    [scrollView setFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    NSLog(@"Before settting, the scrollView's autoResizeSubviews is:%@",scrollView.autoresizesSubviews?@"YES":@"NO");
    scrollView.autoresizesSubviews = true;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, HEIGHT);
}

// When do I need to do something in this?
// When you need to rearrange the layout instead of simply stretching it.
- (void) viewDidLayoutSubviews
{
    [self viewWillAppear:YES];
}

- (void) viewWillAppear:(BOOL)animated 
{
    NSLog(@"I should have called, bounds:%@",NSStringFromCGRect(self.view.bounds));

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"ShouldScrolled to top:%@",[NSThread callStackSymbols]);
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"didScrollToTop: %@", [NSThread callStackSymbols]);
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
