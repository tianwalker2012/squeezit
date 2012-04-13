//
//  EZAppDelegate.m
//  Squeezit
//
//  Created by Apple on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAppDelegate.h"

#import "EZFirstViewController.h"

#import "EZSecondViewController.h"

#import "EZTimeSettingController.h"

#import "EZTabBarController.h"

#import "EZObject.h"

@implementation EZAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLauching");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[EZFirstViewController alloc] initWithNibName:@"EZFirstViewController" bundle:nil];
    UIViewController *viewController2 = [[EZSecondViewController alloc] initWithNibName:@"EZSecondViewController" bundle:nil];
    
    EZTimeSettingController* timeSettingController = [[EZTimeSettingController alloc] initWithNibName:@"TimeSetting" bundle:nil];
    UINavigationController* timeNav = [[UINavigationController alloc] initWithRootViewController:timeSettingController];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, timeNav, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    NSLog(@"About to load defaults");
    NSLog(@"Defaults is:%i",(int)[[NSUserDefaults standardUserDefaults] objectForKey:@"xxoo"]);
    NSLog(@"Completed load defaults");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] setObject:[[EZObject alloc] init] forKey:@"xxoo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
