//
//  AppDelegate.m
//  iCartooniGame
//
//  Created by qianfeng on 14-7-30.
//  Copyright (c) 2014年 michaelalei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void) createRootVC
{
    NSArray* arrayClassName = [NSArray arrayWithObjects:@"VCCategory"/*,@"VCRecomendArt",@"VCDiscovery"*/,@"VCMe", nil] ;
    
    NSMutableArray* arrayVC = [[NSMutableArray alloc] init];
    for (NSString* strCName in arrayClassName)
    {
        Class VC = NSClassFromString(strCName);
        
        UIViewController* vc = [[VC alloc] init] ;
        
        UINavigationController* navBase = [[UINavigationController alloc] initWithRootViewController:vc] ;
        
        [arrayVC addObject:navBase] ;
    }
    
    UITabBarController* tabVC = [[UITabBarController alloc] init] ;
    //tabVC.tabBar.translucent = NO ;
    tabVC.viewControllers = arrayVC ;
    
    self.window.rootViewController = tabVC ;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [self createRootVC] ;
    
    self.isLogin = NO ;
    self.isMaster = NO;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults] ;
    [ud removeObjectForKey:@"OnlyWifiPost"];
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
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
