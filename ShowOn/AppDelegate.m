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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccess object:nil];
    [self configureAPIKey];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginState"]) {
        [self createTabBar];
    }else {
        [self createLogin];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureAPIKey {
    [UMSocialData setAppKey:YOUMENG_API_KEY];
    [UMSocialWechatHandler setWXAppId:WECHAT_APP_ID appSecret:WECHAT_APP_SECRET url:WECHAT_APP_URL];
    [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_KEY url:QQ_APP_URL];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaHandler openSSOWithRedirectURL:SINA_SSO_URL];
    
    [[RCIM sharedRCIM] initWithAppKey:@"25wehl3uwaqmw"];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)createLogin {
    YWLoginViewController *vc = [[YWLoginViewController alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nv;
    nv.navigationBarHidden = YES;
}

- (void)createTabBar {
    _tabBar = [[UITabBarController alloc] init];
    _tabBar.delegate = self;
    _tabBar.tabBar.tintColor = [UIColor greenColor];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    backView.backgroundColor = RGBColor(30, 30, 30);
    [_tabBar.tabBar insertSubview:backView atIndex:0];
    _tabBar.tabBar.opaque = YES;
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
