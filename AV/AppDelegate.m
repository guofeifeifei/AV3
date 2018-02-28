//
//  AppDelegate.m
//  AV
//
//  Created by ZZCN77 on 2017/9/20.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "AppDelegate.h"
#import <Hyphenate/Hyphenate.h>
#import "MessageViewController.h"
@interface AppDelegate (){
    UIBackgroundTaskIdentifier taskId;
    int count;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1195170609115439#sakuraphonereceive"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    //baiduyun
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MessageViewController *imageView = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        self.window.rootViewController = imageView;
        [self.window makeKeyAndVisible];
//
    return YES;
}
// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    //开启一个后台任务
    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        
        //结束指定的任务
        [application endBackgroundTask:taskId];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)timerAction:(NSTimer *)timer {
    
    count++;
    
    if (count % 500 == 0) {
        UIApplication *application = [UIApplication sharedApplication];
        //结束旧的后台任务
        [application endBackgroundTask:taskId];
        
        //开启一个新的后台
        taskId = [application beginBackgroundTaskWithExpirationHandler:NULL];
    }
    
    NSLog(@"%d",count);
}
// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
