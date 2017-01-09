//
//  AppDelegate.m
//  心灵FM
//
//  Created by qianfeng on 16/2/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.isGuanZhu = -1;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 注册友盟平台的Key
    // 友盟的官方平台注册
    [UMSocialData setAppKey:@"56a0fb0767e58eb9ae0031a0"];
    
    // sina 集成appid 和 key
    // 注意:appid和key 以及url不能写错
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4237884006" secret:@"e5e1b57e2d5deb9d0eed0be6bd95a6f0" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // 注册 qq 平台的appid 和 key
    // qq 后台配置未上线之前,只能用测试帐号分享以及登录
    [UMSocialQQHandler setQQWithAppId:@"1105007810" appKey:@"KU33QPGCd6Kzzk1j" url:@"http://www.umeng.com/social"];
    
    [UMSocialWechatHandler setWXAppId:@"wxe1259c7da44f1ec8" appSecret:@"692fbfe32c931148b088ea0fce6bdc9b" url:@"http://www.umeng.com/social"];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
