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
    NSLog(@"background setting:%@",[EZViewUtility printAutoResizeMask:background]);
    EZBackgroundView* tmp = [[EZBackgroundView alloc] initWithFrame:CGRectZero];
    NSLog(@"Check if any magic done by CGRectZero resizeingMask:%@",[EZViewUtility printAutoResizeMask:tmp]);
    [scrollView addSubview:background];
    [self.view addSubview:scrollView];
    
    //scrollView.backgroundColor = [UIColor grayColor];
    //scrollView.delegate = self;
    [self.view addSubview:scrollView];
    //[scrollView addSubview:block1];
    [scrollView setFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    NSLog(@"Before settting, the scrollView's autoResizeSubviews is:%@",scrollView.autoresizesSubviews?@"YES":@"NO");
    scrollView.autoresizesSubviews = true;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, HEIGHT);
    //scrollView.delegate = self;
    
    /**  Keep this one commit, it is for test purpose
    DragableView* block2 = [[DragableView alloc] initWithFrame:CGRectMake(0, 900, 50, 50)];
    block2.backgroundColor = [UIColor greenColor];
    EZButton* eb = [[EZButton alloc] initWithFrame:CGRectMake(0, 200, 44, 44)];
    eb.backgroundColor = [UIColor redColor];
    [eb addTapTarget:self selector:@selector(buttonTapped)];
    [scrollView addSubview:eb];
    
    [scrollView addSubview:block2];
    **/
}

- (void) viewDidLayoutSubviews
{
    [self viewWillAppear:YES];
}

- (void) viewWillAppear:(BOOL)animated 
{
    NSLog(@"I should have called, bounds:%@",NSStringFromCGRect(self.view.bounds));
    //[scrollView setFrame:self.view.bounds];
    //scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, HEIGHT);
    
    //NSLog(@"");
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
