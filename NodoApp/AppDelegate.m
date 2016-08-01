//
//  AppDelegate.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "AppDelegate.h"
#import "SidebarViewController.h"
#import "HomeViewController.h"
#import "NotificationsViewController.h"

@implementation AppDelegate

+ (AppDelegate*) sharedAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    DataManager.badgeNumber = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
    
    self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions appId:@"61704c44-fc11-496b-95a6-5b93eb4fea22" handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
        
        if ([[additionalData objectForKey:@"type"] isEqualToString:@"buzz"] ) {
            AudioServicesPlaySystemSound(1304);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            
            [alertController addAction:defaultAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                      if ([SidebarViewController share] != nil) {
                                                                          if ([[additionalData objectForKey:@"type"] containsString:@"response"]) {
                                                                              
                                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                              HomeViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                                                                              [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                              
                                                                          } else {
                                                                              
                                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                              NotificationsViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
                                                                              mainViewController.type = 1;
                                                                              mainViewController.receivedInfo = additionalData;
                                                                              [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                          }
                                                                      }
                                                                  }];
            
            [alertController addAction:defaultAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }];
   
    socialNetwork = [[SocialNetwork alloc] init];
    
    return YES;
}

- (CLLocation *)getCurrentlocation
{
    return currentLoc;
}

- (void)setCurrentlocation:(CLLocation*)loc
{
    currentLoc = loc;
}

- (void)startUpdatingLoc
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(updateLocationData:) userInfo:nil repeats:YES];
}

- (void)stopUpdatingLoc
{
    [timer invalidate];
    timer = nil;
}

- (void) updateLocationData:(NSTimer*) timer
{
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.15f", currentLoc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", currentLoc.coordinate.longitude], @"lng",  [DataManager.currentUser objectForKey:@"id"], @"userid", [NSString stringWithFormat:@"%f", interval], @"timestamp", nil];
    [socialNetwork updateUser:dictionary withCompletion:nil];
    
    if (bgTaskFlag) {
        
        UIApplication *app = [UIApplication sharedApplication];
        [app endBackgroundTask:bgTask];
        
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            bgTask = UIBackgroundTaskInvalid;
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        bgTask = UIBackgroundTaskInvalid;
    }];
    bgTaskFlag = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    bgTaskFlag = NO;
    if (bgTask != UIBackgroundTaskInvalid) {
        UIApplication *app = [UIApplication sharedApplication];
        [app endBackgroundTask:bgTask];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
