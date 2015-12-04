//
//  AppDelegate.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "AppDelegate.h"
#import "YWHomeViewController.h"
#import "YWMovieViewController.h"
#import "YWMineViewController.h"
#import "YWNavigationController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate
{
    UITabBarController   *_tabBar;
    NSInteger             _tabBarLastSelectIndex;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createTabBar];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)createTabBar {
    _tabBar = [[UITabBarController alloc] init];
    _tabBar.delegate = self;
    _tabBar.tabBar.tintColor = [UIColor orangeColor];
    self.window.rootViewController = _tabBar;
    NSArray *classNames = @[@"YWHomeViewController", @"YWMovieViewController", @"YWMineViewController"];
    NSArray *titles = @[@"首页", @"影集", @"我的"];
    NSArray *imageNames = @[@"", @"", @""];
    NSArray *selectImageNames = @[@"", @"", @""];
    for (NSInteger i=0; i<classNames.count; i++) {
        [self createChildViewControllerWithClassName:classNames[i] title:titles[i] imageName:imageNames[i] selectImageName:selectImageNames[i]];
    }
}

- (void)createChildViewControllerWithClassName:(NSString *)className title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName {
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    vc.title = title;
    nv.tabBarItem.title = title;
    nv.tabBarItem.image = [UIImage imageNamed:imageName];
    nv.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    [_tabBar addChildViewController:nv];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isEqual:_tabBar.childViewControllers[1]]) {
        _tabBar.tabBar.hidden = YES;
    }else {
        _tabBarLastSelectIndex = _tabBar.selectedIndex;
    }
}

- (void)movieVCToBack {
    _tabBar.tabBar.hidden = NO;
    _tabBar.selectedIndex = _tabBarLastSelectIndex;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
