//
//  EZFirstViewController.m
//  Squeezit
//
//  Created by Apple on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZFirstViewController.h"

@interface ReleaseObj : NSObject
{
    ReleaseObj* child;
    NSString* name;
}

- (id) initWithName:(NSString*)name child:(ReleaseObj*)child;

- (void) setChild:(ReleaseObj*)child;

@end

@implementation ReleaseObj

- (void) setChild:(ReleaseObj *)cd
{
    child = cd;
}

- (id) initWithName:(NSString *)nm  child:(ReleaseObj*)cd
{
    self = [super init];
    name = nm;
    child = cd;
    return self;
}

- (void) dealloc
{
    NSLog(@"%@:get dealloc",name);
}

@end

@interface EZFirstViewController ()

@end

@implementation EZFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    ReleaseObj* parent = [[ReleaseObj alloc] initWithName:@"Parent" child:[[ReleaseObj alloc] initWithName:@"child" child:nil]];
    ReleaseObj* child2 = [[ReleaseObj alloc] initWithName:@"Child2" child:nil];
    [parent setChild:child2];
    NSLog(@"Set child to child2, child supposed to get release");
    parent = nil;
    
    NSLog(@"View did load completed");
    
	// Do any additional setup after loading the view, typically from a nib.
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

@end
