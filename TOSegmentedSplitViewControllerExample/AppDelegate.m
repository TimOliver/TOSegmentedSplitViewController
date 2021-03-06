//
//  AppDelegate.m
//  TOSegmentedTabBarController
//
//  Created by Tim Oliver on 28/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import "AppDelegate.h"

#import "TOSegmentedSplitViewController.h"
#import "PlainTableViewController.h"
#import "GroupedTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    GroupedTableViewController *groupedController = [[GroupedTableViewController alloc] init];
    groupedController.title = @"Download";
    UINavigationController *firstController = [[UINavigationController alloc] initWithRootViewController:groupedController];
    firstController.navigationBar.prefersLargeTitles = YES;
    
    PlainTableViewController *plainController = [[PlainTableViewController alloc] init];
    plainController.title = @"Activity";
    UINavigationController *secondController = [[UINavigationController alloc] initWithRootViewController:plainController];
    secondController.navigationBar.prefersLargeTitles = YES;
    
    TOSegmentedSplitViewController *segmentedController = [[TOSegmentedSplitViewController alloc] initWithControllers:@[firstController, secondController]];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = segmentedController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
