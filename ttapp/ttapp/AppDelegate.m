//
//  AppDelegate.m
//  ttapp
//
//  Created by Xiangyu Zhang on 2/9/15.
//  Copyright (c) 2015 Yahoo!. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetsViewController.h"
#import "ContainerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotifiction object:nil];
    
    //styling the navigation bar
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 0.3);
    shadow.shadowColor = [UIColor blackColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]
       }
     forState:UIControlStateNormal];
    
    User * user = [User currentUser];
    if([User currentUser] != nil){
        //currentUser not nil do something here...
        NSLog(@"Welcome back, %@", user.name);
        //TweetsViewController * tvc = [[TweetsViewController alloc] init];
        //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
        ContainerViewController * cvc = [[ContainerViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
        self.window.rootViewController = nvc;
    }else{
        NSLog(@"Not Logged in");
        self.window.rootViewController = [[LoginViewController alloc] init];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)userDidLogout {
    self.window.rootViewController = [[LoginViewController alloc] init];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    [[TwitterClient sharedInstance] openURL: url];
    return YES;
}

@end
