//
//  AppDelegate.m
//  sxxw
//
//  Created by haidony on 14-4-11.
//  Copyright (c) 2014年 weyida. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "LefttypeDB.h"
#import "TgnewstypeDB.h"
#import "TgnewsDB.h"
#import "CreateTableDB.h"
#import "Util.h"
#import "LeftSideDrawerViewController.h"
#import "RESideMenu.h"
#import <XHNewsFramework/XHParallaxNavigationController.h>
#import "HttpService.h"

@interface AppDelegate () <RESideMenuDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *temp = [build substringFromIndex:2];
    NSString *temp2 = @"1";
    if([temp isEqualToString:temp2]){//需要更新数据库
        //删除数据库新建数据库；
        
    }
    @try {
        [LefttypeDB singleton];
        [TgnewstypeDB singleton];
        [TgnewsDB singleton];
    }
    @catch (NSException *exception) {
        //<1>断点 可以更清晰的看到一些调用信息 从而发现错误源
        //<2.1>日志(打印一些相关的信息 分析错误源)或者其他方式保存记录信息
        NSLog(@"%@",exception);
        //<2.2>也可以调用Exception处理方法
        //[self UncaughtExceptionHandler:exception];
        [CreateTableDB singleton];
        [LefttypeDB singleton];
        [TgnewstypeDB singleton];
        [TgnewsDB singleton];
    }
    @finally {
        Lefttype *firstLefttype = [Util getLastLefttype];
        if(firstLefttype!=nil){
//            [Util getLastNewstype:firstLefttype];
        }else{
            //获取数据
        }
        
    }

    
    LeftSideDrawerViewController *leftSideDrawerViewController = [[LeftSideDrawerViewController alloc] init];
    
    XHParallaxNavigationController *parallaxNavigationController = [[XHParallaxNavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:parallaxNavigationController menuViewController:leftSideDrawerViewController];
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"sidebar_bg@2x.jpg"];
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 20;
    sideMenuViewController.scaleContentView = NO;
    sideMenuViewController.scaleBackgroundImageView = NO;
    sideMenuViewController.scaleMenuViewContainer = NO;
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    
    sideMenuViewController.delegate = self;
    
    
    
    self.window.rootViewController = sideMenuViewController;
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[XHNeteaseNewsViewController alloc] init]];
    [self.window makeKeyAndVisible];
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
}

@end
