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
        animated = false;
    }
    return self;
}

//Under following circumstance, I assume only the 
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    animated = false;
    NSLog(@"ScrollAnimation completed");
    if(shadowView){
        [self moveDetection:shadowView];
    }
}


// The animation will be stop
- (void) dismissShadow:(UIView *)shadow
{
    shadowView = nil;
}

- (void) moveDetection:(UIView*)draggable
{
    if(animated){
        NSLog(@"Quit for already animated");
        return;
    }
    //animated = YES;
    UIView* grandPa = scrollView.superview;
    CGRect dragRect = [grandPa convertRect:draggable.frame fromView:draggable.superview];
    
    if(CGRectContainsRect(scrollView.frame, dragRect)){
        NSLog(@"No scroll is need");
        return;
    }else if(dragRect.origin.y >= scrollView.frame.origin.y && (dragRect.origin.y+dragRect.size.height) <=  (scrollView.frame.origin.y+scrollView.frame.size.height)){
        NSLog(@"Will scroll horizontally");
    }else{
        
        //deltaOY = (dragRect.origin.y - insetRect.origin.y)/;
        //Assume the 
        CGFloat velocity = (scrollView.frame.origin.y - dragRect.origin.y)/dragRect.size.height;
        CGFloat prevOffsetY = scrollView.contentOffset.y;
        CGFloat animDuration = SCROLL_DURATION/(velocity*3);
        CGFloat changeOffsetY = prevOffsetY;
        if(velocity > 0){//Will scroll up.
            changeOffsetY = prevOffsetY - SCROLL_UNIT;
            if(changeOffsetY < 0.0f){
                changeOffsetY = 0.0f;
            }
        } else {
            velocity = (dragRect.origin.y+dragRect.size.height-(scrollView.frame.origin.y+scrollView.frame.size.height))/dragRect.size.height;
            animDuration = SCROLL_DURATION/(velocity*3);
            changeOffsetY = prevOffsetY + SCROLL_UNIT;
            if((changeOffsetY+scrollView.frame.size.height) > scrollView.contentSize.height){
                changeOffsetY = scrollView.contentSize.height - scrollView.frame.size.height;
            }
        }
        
        //Will start scroll animation if the scroll happened.
              
        if(prevOffsetY != changeOffsetY){
            animated = YES;
            shadowView = draggable;
            NSLog(@"AnimationDuration:%fl, velocity:%fl",animDuration , velocity);
            if(animDuration > SCROLL_DURATION_MAX){
                animDuration = SCROLL_DURATION_MAX;
            } 
            NSLog(@"AnimationDurition:%fl",animDuration);
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, changeOffsetY) animated:YES];
            //[self performSelector:@selector(ownScrollAnimationCompleted:) withObject:draggable afterDelay:animDuration];
        } else {
            NSLog(@"Nothing changed, stop calling");
        }
    }
    
}

- (void)ownScrollAnimationCompleted:(UIView*)draggable
{
    NSLog(@"Manual animation control");
    animated = NO;
    if(shadowView){
        [self moveDetection:shadowView];
    }
}


-(CGRect) normalizeFrame:(CGRect)frame stretchType:(StretchType)type;
{
    CGRect res = frame;
    switch (type) {
        case UpperCycleUp:
            if(true){//For a weired Xcode bug. remove the "if" block to check it. :)
                CGFloat distance = res.origin.y - PAGE_HEAD;
                int unitCount = distance/SCROLL_UNIT;
                res.origin.y = PAGE_HEAD + unitCount*SCROLL_UNIT;
                CGFloat delta = frame.origin.y - res.origin.y;
                res.size.height = res.size.height + delta; 
            }
            break;
        case UpperCycleDown:
            if(true){
                CGFloat distance = res.origin.y - PAGE_HEAD;
                int unitCount = distance/SCROLL_UNIT;
                res.origin.y = PAGE_HEAD + (unitCount+1)*SCROLL_UNIT;
                CGFloat delta = frame.origin.y - res.origin.y;
                res.size.height = res.size.height + delta; 
            }
            break;
        case BottomCycleUp:
            if(true){
                int count = res.size.height/SCROLL_UNIT;
                res.size.height = count*SCROLL_UNIT;
            }
            break;
        case BottomCycleDown:
            if(true){
                int unitCount = res.size.height/SCROLL_UNIT;
                res.size.height = (unitCount+1)*SCROLL_UNIT;
            }
            break;
        default:
            break;
    }
    
    return res;
}

- (void) stretchBegan:(UIView*)stretched
{
    
}

- (void) stretchMoved:(UIView*)stretched
{
    
}

- (void) stretchEnded:(UIView*)stretched
{
    
}

- (void) stretchCancelled:(UIView*)stretched
{
    
}

- (void) setScrollEnabled:(BOOL)endabled
{
    [scrollView setScrollEnabled:endabled];
}

- (void) dropView:(UIView*)droped
{
    NSLog(@"Will reposition view:%@",NSStringFromCGRect(droped.frame));
    CGPoint center = droped.center;
    CGFloat bodyArea = center.y - PAGE_HEAD;
    int floors = bodyArea/SCROLL_UNIT;
    if(floors == 0){
        center.y = PAGE_HEAD;
    }else{
        center.y = PAGE_HEAD+ PAGE_HEAD*floors;
    }
    center.x = TIME_BEGIN+droped.frame.size.width/2;
    NSLog(@"Old center:%@, new center:%@",NSStringFromCGPoint(droped.center), NSStringFromCGPoint(center));
    droped.center = center;
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
    DragableView* dragableView = [[DragableView alloc] initWithFrame:CGRectMake(TIME_BEGIN, y-TouchZone/2, self.view.bounds.size.width-TIME_BEGIN, UNIT_HEIGHT+TouchZone)];
    dragableView.background.backgroundColor = [UIColor colorWithRed:0.8 green:0.5 blue:0.5 alpha:1];
    //dragableView.alpha = 0.0;
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
    EZBlockObject* obj = [[EZBlockObject alloc] initWithName:@"Block1"];
    myBlock = [obj createBlock];
    //block();
    NSLog(@"Name is %@", obj.name);
    obj = nil;
    //block = nil;
    NSLog(@"Should dealloced before this");
    
    /**
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
     **/
}

- (void) executeBlock
{
    myBlock();
    myBlock = nil;
    NSLog(@"Should have released the Object referred in the block");
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

//If we really scroll or not
- (BOOL) scrollStep:(CGFloat)step stopDelegate:(id)delegate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetYUpdated = offsetY + step;
    if(offsetYUpdated < 0){
        offsetYUpdated = 0;
    }else if((offsetYUpdated + scrollView.frame.size.height) > scrollView.contentSize.height){
        offsetYUpdated = scrollView.contentSize.height - scrollView.frame.size.height;
    }
    NSLog(@"offsetY:%fl, offsetUpdated:%fl", offsetY, offsetYUpdated);
    if(offsetYUpdated == offsetY){
        NSLog(@"No animation for not changed");
        return false;
    }
    
    //[UIView beginAnimations:@"Scroll" context:context];
    //[UIView setAnimationDelegate:delegate];
    //[UIView setAnimationDidStopSelector:method];
    //[UIView setAnimationDuration:duration];
    scrollView.delegate = delegate;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, offsetYUpdated)
                        animated:YES];   
    return true;
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
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(executeBlock)];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Timesetting view resizing: %@",[EZViewUtility printAutoResizeMask:self.view]);
    DragableView* block1 = [[DragableView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    block1.backgroundColor = [UIColor redColor];
    scrollView = [[EZTimeScrollView alloc] initWithFrame:CGRectZero];
    scrollView.delegate = self;
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
