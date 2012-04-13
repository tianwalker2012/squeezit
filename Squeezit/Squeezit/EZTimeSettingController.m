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

@implementation EZTimeSettingController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Time Setting", @"Time Setting");
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
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
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
    DragableView* block1 = [[DragableView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    block1.backgroundColor = [UIColor redColor];
    
    [scrollView addSubview:block1];
    scrollView.delegate = self;
    
    DragableView* block2 = [[DragableView alloc] initWithFrame:CGRectMake(0, 900, 50, 50)];
    block2.backgroundColor = [UIColor greenColor];
    EZButton* eb = [[EZButton alloc] initWithFrame:CGRectMake(0, 200, 44, 44)];
    eb.backgroundColor = [UIColor redColor];
    [eb addTapTarget:self selector:@selector(buttonTapped)];
    [scrollView addSubview:eb];
    
    [scrollView addSubview:block2];
    
}

- (void) viewDidLayoutSubviews
{
    [self viewWillAppear:YES];
}

- (void) viewWillAppear:(BOOL)animated 
{
    NSLog(@"I should have called, bounds:%@",NSStringFromCGRect(self.view.bounds));
    [scrollView setFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, HEIGHT);
    
    
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
