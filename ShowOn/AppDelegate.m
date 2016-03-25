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
#import <RongIMKit/RongIMKit.h>
#import "YWLoginViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "YWCustomTabBarViewController.h"
#import "YWDataBaseManager.h"
#import "YWFriendListManager.h"

@interface AppDelegate ()<UITabBarControllerDelegate, YWCustomTabBarViewControllerDelegate>

@end

@implementation AppDelegate
{
    YWCustomTabBarViewController   *_tabBar;
    NSInteger             _tabBarLastSelectIndex;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = Subject_color;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccess object:nil];
    [self configureAPIKey];
    _tabBarLastSelectIndex = -1;
    [YWFriendListManager shareInstance];
    [self createTabBar];
//
//    if ([[YWDataBaseManager shareInstance] loginUser]) {
//        [self createTabBar];
//    }else {
//        [self createLogin];
//    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureAPIKey {
    [UMSocialData setAppKey:UMengAppKey];
    [UMSocialWechatHandler setWXAppId:WECHAT_APP_ID appSecret:WECHAT_APP_SECRET url:WECHAT_APP_URL];
    [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_KEY url:QQ_APP_URL];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaHandler openSSOWithRedirectURL:SINA_SSO_URL];
    
    [[RCIM sharedRCIM] initWithAppKey:@"z3v5yqkbvtks0"];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)createLogin {
    YWLoginViewController *vc = [[YWLoginViewController alloc] init];
    vc.backButtonHiddenState = YES;
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nv;
    nv.navigationBarHidden = YES;
}

- (void)createTabBar {
    _tabBar = [[YWCustomTabBarViewController alloc] init];
    _tabBar.itemNums = 3;
    _tabBar.itemDelegate = self;
    self.window.rootViewController = _tabBar;
    NSArray *classNames = @[@"YWHomeViewController", @"YWMovieViewController", @"YWMineViewController"];
    NSArray *titles = @[@"", @"", @""];
    NSArray *imageNames = @[@"article_normal.png", @"shoot_normal.png", @"mine_normal.png"];
    NSArray *selectImageNames = @[@"more_selected.png", @"shoot_selected.png", @"more_selected.png"];
    _tabBar.titles = titles;
    _tabBar.imageNames = imageNames;
    _tabBar.selectImageNames = selectImageNames;
    for (NSInteger i=0; i<classNames.count; i++) {
        [self createChildViewControllerWithClassName:classNames[i] title:titles[i]];
    }
}

- (void)createChildViewControllerWithClassName:(NSString *)className title:(NSString *)title {
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    vc.title = title;
    [_tabBar addChildViewController:nv];
}

#pragma mark - YWCustomTabBarViewControllerDelegate
- (void)customTabBarViewControllerDidSelectWithIndex:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenHotView" object:nil];
    if (index == 1) {
        _tabBar.hiddenState = YES;
    }else {
        _tabBar.hiddenState = NO;
        _tabBarLastSelectIndex = _tabBar.selectedIndex;
    }
    _tabBar.selectedIndex = index;
}

- (void)loginSuccess:(NSNotification *)notification {
    [self createTabBar];
}

#pragma mark 实现授权回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.viewControllerType == UMSViewControllerOauth) {
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        }];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return  [UMSocialSnsService handleOpenURL:url];
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
