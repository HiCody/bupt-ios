//
//  AppDelegate.m
//  cosign
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 YuanTu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "APService.h"
#import <Bugly/CrashReporter.h>
#import "BaseNavigationController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <TSMessage.h>
#import <TSMessageView.h>
#import "MspendingViewController.h"

#define BUGLY_APP_ID @"900010753"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];

//JPush推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // ios8之前 categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }
#else
    // categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif      // Required
    [APService setupWithOption:launchOptions];

/*---------------------------------------------------------------------------------------*/
    
    // 初始化Bugly SDK，开启崩溃捕获上报功能及卡顿监听上报
        [[CrashReporter sharedInstance] installWithAppId:BUGLY_APP_ID];
    // ------
    // 注意: 在调试SDK的捕获上报功能时，请注意以下内容:
    // 1. Xcode断开编译器，否则Xcode编译器会拦截应用错误信号，让应用进程挂起，方便开发者调试定位问题。此时，SDK无法顺利进行崩溃的错误上报
    // 2. 请关闭项目存在第三方捕获工具，否则会相互产生影响。因为崩溃捕获的机制一致，系统只会保持一个注册的崩溃处理函数
    // ------
    
/*---------------------------------------------------------------------------------------*/
    [UIApplication sharedApplication].applicationIconBadgeNumber=0.0;
    [self postNotification];
    
    Account *account = [Account shareAccount];
    [account loadAccountFromSanbox];
    
    LoginViewController *loginVC  = [[LoginViewController alloc] init];
    if (account.autoLogin.boolValue) {
//检测自动登陆
        
        [loginVC requestLoginWithName:account.userName pwd:account.passWord];
        
       
    }

    self.window.rootViewController = loginVC;
   

   [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)postNotification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeViewRefresh object:@YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationRefresh object:@YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MspendingRefresh object:@YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:CirculatedRefresh object:@YES];
}

//获取到token之后，把token发送给极光服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

//注册token失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error);
}

//接受到通知（需要开启网络）
//1、app打开状态下直接调用该方法
//2、app进入后台，点击通知栏的通知调用该方法
//3、app关闭，点击通知栏的通知调用didFinishLaunchingWithOptions方法
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo[@"aps"][@"alert"]);
      [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotification" object:userInfo];
    [self postNotification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@",userInfo[@"aps"][@"alert"]);
    [self postNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotification" object:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


//登陆成功
- (void)signIn{
    
    HomeViewController  *oneVC = [[HomeViewController alloc] init];
    BaseNavigationController *nav=[[BaseNavigationController alloc]initWithRootViewController:oneVC];
    self.window.rootViewController=nav;
    
    
   
}

//登录失败
- (void)signOut{
    LoginViewController *loginVC  = [[LoginViewController alloc] init];
    
    
    self.window.rootViewController = loginVC;
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
