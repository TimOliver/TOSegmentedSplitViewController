//
//  AppDelegate.m
//  TOSegmentedTabBarController
//
//  Created by Tim Oliver on 28/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *firstController = [self viewControllerWithTitle:@"Tab 1"];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = firstController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UINavigationController *)viewControllerWithTitle:(NSString *)title
{
    UITableViewController *controller = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = title;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.prefersLargeTitles = YES;

    return navController;
}

@end
