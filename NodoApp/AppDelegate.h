//
//  AppDelegate.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OneSignal/OneSignal.h>
#import "SocialNetwork.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate >
{
    NSTimer     *timer;
    CLLocation          *currentLoc;
    
    BOOL        bgTaskFlag;
    UIBackgroundTaskIdentifier bgTask;
    
    SocialNetwork *socialNetwork;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OneSignal *oneSignal;

+ (AppDelegate*) sharedAppDelegate;
- (void)startUpdatingLoc;
- (void)stopUpdatingLoc;
- (CLLocation *)getCurrentlocation;
- (void)setCurrentlocation:(CLLocation*)loc;
@end

