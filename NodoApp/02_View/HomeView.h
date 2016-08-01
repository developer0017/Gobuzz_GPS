//
//  HomeView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HomeViewController.h"
#import "AsyncImageView.h"

@interface HomeView : UIView <MKMapViewDelegate, CLLocationManagerDelegate>
{
    int searchType;
    NSDictionary *selectedUserInfo;

    BOOL isFirstTime;
    int  sendType;
    int  requestType;
    
    NSTimer *timer;
    NSMutableArray *userArray;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UIView    *genderView;
@property (nonatomic, retain) IBOutlet UIView    *profileView;
@property (nonatomic, retain) IBOutlet UIView    *sendView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *leftSendContraint;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *rightSendContraint;
@property (nonatomic, retain) IBOutlet UIView    *requestView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *leftRequestContraint;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *rightRequestContraint;
@property (nonatomic, retain) IBOutlet UILabel   *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel   *balanceLabel;
@property (nonatomic, retain) IBOutlet UIButton  *buzzButton;
@property (nonatomic, retain) IBOutlet UILabel   *buzzLabel;
@property (nonatomic, retain) IBOutlet UIImageView    *bkImageView;
@property (nonatomic, retain) IBOutlet AsyncImageView *userImageView;
@property (nonatomic, retain) HomeViewController *controller;

- (void)initialiseViewWithController:(HomeViewController*)homeViewController;
- (void)showNearbyUsers:(NSArray *)usersArray;
@end
