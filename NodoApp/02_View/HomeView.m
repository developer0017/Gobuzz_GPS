//
//  HomeView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "HomeView.h"
#import "SidebarViewController.h"
#import "AppDelegate.h"
#import "UserAnnotation.h"
#import "ZSPinAnnotation.h"
#import "ZSAnnotation.h"
#import "SocialNetwork.h"
#import "SidebarViewController.h"
#import "PaymentViewController.h"
#import "SocialNetwork.h"

@implementation HomeView
@synthesize mapView;
@synthesize profileView;
@synthesize sendView;
@synthesize leftSendContraint;
@synthesize rightSendContraint;
@synthesize requestView;
@synthesize leftRequestContraint;
@synthesize rightRequestContraint;
@synthesize genderView;
@synthesize controller;
@synthesize usernameLabel;
@synthesize balanceLabel;
@synthesize bkImageView;
@synthesize userImageView;
@synthesize buzzButton;
@synthesize buzzLabel;

- (void)initialiseViewWithController:(HomeViewController*)homeViewController
{
    controller = homeViewController;
    
    userArray = [NSMutableArray array];
    
    [self createMaskForImage:userImageView];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    [appDelegate startUpdatingLoc];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    searchType = [[defaults objectForKey:@"searchtype"] intValue];
    if (searchType == 0) {
        searchType = 2;
    }
    
    switch (searchType) {
        case 1:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_man_on.png"] forState:UIControlStateNormal];
        }   break;
        case 2:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_all_on.png"] forState:UIControlStateNormal];
        }   break;
        case 3:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_girl_on.png"] forState:UIControlStateNormal];
        }   break;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    #endif
    [self.locationManager setDesiredAccuracy: kCLLocationAccuracyNearestTenMeters];
    [self.locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    isFirstTime = YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 60.0f target:self selector:@selector(getUsers:) userInfo:nil repeats:YES];
}

- (void)getUsers:(NSTimer *) timer
{
    CLLocationCoordinate2D newCoordinate;
    newCoordinate.latitude = mapView.userLocation.coordinate.latitude;
    newCoordinate.longitude = mapView.userLocation.coordinate.longitude;
    
    if (newCoordinate.latitude != 0 && newCoordinate.longitude != 0) {
        [self getNearbyUsers:newCoordinate withSearchType:searchType];
    }
}

-(void)getNearbyUsers:(CLLocationCoordinate2D) location withSearchType:(int)type
{
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.15f", location.latitude], @"lat", [NSString stringWithFormat:@"%.15f", location.longitude], @"lng", [NSString stringWithFormat:@"%i", type], @"searchtype", [DataManager.currentUser objectForKey:@"id"], @"userid", nil];
    
    [socialNetwork getAroundUser:dictionary withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                if (![msg isEqualToString:@"Not Exist"]) {
                    NSArray *nearbyUsers = [resultData objectForKey:@"RESULT"];
                    [userArray removeAllObjects];
                    [userArray addObjectsFromArray:nearbyUsers];
                    [self showNearbyUsers:userArray];
                } else {
                    [self showNearbyUsers:[NSArray array]];
                }
            }
        });
    }];
}

- (IBAction)onClickMenuButton:(id)sender
{
    if (![[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    } else {
        [[SidebarViewController share] hideMenu];
    }
}

- (IBAction)onClickShowSendView:(id)sender
{
    sendType = 1;
    UIButton *button = (UIButton*)[sendView viewWithTag:1];
    [button setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateNormal];
    button = (UIButton*)[sendView viewWithTag:2];
    [button setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    
    NSString *facebookID = [DataManager.currentUser objectForKey:@"facebookid"];
    NSString *twitterID = [DataManager.currentUser objectForKey:@"twitterid"];
    NSString *instagramID = [DataManager.currentUser objectForKey:@"instagram"];
    NSString *snapchatID = [DataManager.currentUser objectForKey:@"snapchat"];
    
    if ([facebookID length] == 0 && [twitterID length] == 0 && [instagramID length] == 0 && [snapchatID length] == 0) {
        [button setHidden:YES];
    } else {
        [button setHidden:NO];
    }
    
    [UIView animateWithDuration: 0.5 animations:^{
        [leftSendContraint setConstant:0];
        [rightSendContraint setConstant:0];
        [profileView needsUpdateConstraints];
    }];
}

- (IBAction)onClickSendTypeButton:(UIButton *)sender
{
    UIButton * button = (UIButton*)[sendView viewWithTag:sendType];
    [button setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    
    sendType = (int)sender.tag;
    [sender setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateNormal];
}

- (IBAction)onClickBackProfileView:(id)sender
{
    [UIView animateWithDuration: 0.5 animations:^{
        [leftSendContraint setConstant: self.frame.size.width];
        [rightSendContraint setConstant: - self.frame.size.width];
        [profileView needsUpdateConstraints];
    }];
}

- (IBAction)onClickSendButton:(id)sender
{
    [profileView setHidden:YES];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    CLLocation *loc = [appDelegate getCurrentlocation];
    
    if (sendType == 1) {
        
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
        
        NSDictionary *sendParams = [NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"fromid", [DataManager.currentUser objectForKey:@"screenname"], @"fromname", [selectedUserInfo objectForKey:@"id"], @"toid", [selectedUserInfo objectForKey:@"screenname"], @"toname", [NSString stringWithFormat:@"Mobile : %@", [DataManager.currentUser objectForKey:@"sharenumber"]], @"shareinfo", [NSString stringWithFormat:@"%li", (long)timestamp], @"timestamp", [NSString stringWithFormat:@"%.15f", loc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", loc.coordinate.longitude], @"lng", @"send", @"type", @"mobile", @"requesttype", nil];
        
        [socialNetwork sendNotifications:sendParams withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {

            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                NSString *resultid = [resultData objectForKey:@"RESULT"];
                
                if ([msg isEqualToString:@"Success"]) {
                    
                    NSString *message = [NSString stringWithFormat:@"You have received %@'s Number.", [DataManager.currentUser objectForKey:@"screenname"]];
                    NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
                    [contents setObject:@"send" forKey:@"type"];
                    [contents setObject:resultid forKey:@"id"];
                    [contents setObject:@"mobile" forKey:@"requesttype"];
                    [contents setObject:[DataManager.currentUser objectForKey:@"id"] forKey:@"fromid"];
                    [contents setObject:DataManager.currentUser forKey:@"senderinfo"];
                    [contents setObject:[DataManager.currentUser objectForKey:@"gender"] forKey:@"gender"];
                    
                    NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[selectedUserInfo objectForKey:@"id"], @"value", nil];
                    [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"1"}];
                    
                    int connects = [[DataManager.currentUser objectForKey:@"connects"] intValue];
                    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
                    [socialNetwork updateConnects:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"],@"userid", [NSString stringWithFormat:@"%i",  connects - 1], @"connects",  nil] withCompletion: nil];
                    
                    [DataManager.currentUser setObject:[NSString stringWithFormat:@"%i", connects - 1] forKey:@"connects"];
                    
                    [self showAlert:@"Your mobile number has been shared successfully."];
                } else {
                    [self showAlert:@"Oops! Please check your connection again."];
                }
            }
        }];
        
    } else {
        
        NSString *facebookID = [DataManager.currentUser objectForKey:@"facebookid"];
        NSString *twitterID = [DataManager.currentUser objectForKey:@"twitterid"];
        NSString *instagramID = [DataManager.currentUser objectForKey:@"instagramid"];
        NSString *snapchatID = [DataManager.currentUser objectForKey:@"snapchatid"];
        
        if ([facebookID length] == 0 && [twitterID length] == 0 && [instagramID length] == 0 && [snapchatID length] == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:@"Please update your profile and add your social media account in order to share it." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                      [profileView setHidden:YES];
                                                                  }];
            [alertController addAction:defaultAction];
            [controller presentViewController:alertController animated:YES completion:nil];
            
        } else {
            
            NSString *shareInfo = @"";
            if ([facebookID length] != 0) {
                shareInfo = [NSString stringWithFormat:@"Pinterest: %@ ", facebookID];
            }
            
            if ([twitterID length] != 0) {
                shareInfo = [NSString stringWithFormat:@"%@ Twitter: %@ ", shareInfo, twitterID];
            }
            
            if ([instagramID length] != 0) {
                shareInfo = [NSString stringWithFormat:@"%@ Instagram: %@ ",  shareInfo, instagramID];
            }
            
            if ([snapchatID length] != 0) {
                shareInfo = [NSString stringWithFormat:@"%@ Snapchat: %@ ", shareInfo, snapchatID];
            }
            
            SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
            NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
            NSDictionary *sendParams = [NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"fromid", [DataManager.currentUser objectForKey:@"screenname"], @"fromname", [selectedUserInfo objectForKey:@"id"], @"toid", [selectedUserInfo objectForKey:@"screenname"], @"toname", shareInfo, @"shareinfo", [NSString stringWithFormat:@"%li", (long)timestamp], @"timestamp", [NSString stringWithFormat:@"%.15f", loc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", loc.coordinate.longitude], @"lng", @"send", @"type", @"social", @"requesttype", nil];
            
            [socialNetwork sendNotifications:sendParams withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [self showAlert:@"Oops! Please check your connection again."];
                } else {
                    
                    NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                    NSString *msg = [resultData objectForKey:@"MSG"];
                    NSString *resultid = [resultData objectForKey:@"RESULT"];
                    
                    if ([msg isEqualToString:@"Success"]) {
                        
                        NSString *message = [NSString stringWithFormat:@"You have received %@'s social media account.", [DataManager.currentUser objectForKey:@"screenname"]];
                        NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
                        [contents setObject:@"send" forKey:@"type"];
                        [contents setObject:resultid forKey:@"id"];
                        [contents setObject:@"Social Media Account" forKey:@"shareinfo"];
                        [contents setObject:@"social" forKey:@"requesttype"];
                        [contents setObject:[DataManager.currentUser objectForKey:@"id"] forKey:@"fromid"];
                        [contents setObject:[DataManager.currentUser objectForKey:@"gender"] forKey:@"gender"];
                        
                        NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[selectedUserInfo objectForKey:@"id"], @"value", nil];
                        [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"1"}];
                        
                        int connects = [[DataManager.currentUser objectForKey:@"connects"] intValue];
                        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
                        [socialNetwork updateConnects:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"],@"userid", [NSString stringWithFormat:@"%i",  connects - 1], @"connects",  nil] withCompletion:nil];
                        [DataManager.currentUser setObject:[NSString stringWithFormat:@"%i", connects - 1] forKey:@"connects"];
                        
                        [self showAlert:@"Your social media account has been shared successfully."];
                    } else {
                        [self showAlert:@"Oops! Please check your connection again."];
                    }
                }
            }];
        }
    }
}

- (IBAction)onClickShowRequestView:(id)sender
{
    requestType = 1;
    UIButton *button = (UIButton*)[requestView viewWithTag:1];
    [button setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateNormal];
    
    button = (UIButton*)[requestView viewWithTag:2];
    [button setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    
    NSString *facebookID = [selectedUserInfo objectForKey:@"facebookid"];
    NSString *twitterID = [selectedUserInfo objectForKey:@"twitterid"];
    NSString *instagramID = [selectedUserInfo objectForKey:@"instagram"];
    NSString *snapchatID = [selectedUserInfo objectForKey:@"snapchat"];
    
    if ([facebookID length] == 0 && [twitterID length] == 0 && [instagramID length] == 0 && [snapchatID length] == 0) {
        [button setHidden:YES];
    } else {
        [button setHidden:NO];
    }
    
    [UIView animateWithDuration: 0.5 animations:^{
        [leftRequestContraint setConstant:0];
        [rightRequestContraint setConstant:0];
        [requestView needsUpdateConstraints];
    }];
}

- (IBAction)onClickRequestTypeButton:(UIButton *)sender
{
    UIButton * button = (UIButton*)[requestView viewWithTag:requestType];
    [button setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    
    requestType = (int)sender.tag;
    [sender setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateNormal];
}

- (IBAction)onClickBackProfileFromRequestView:(id)sender
{
    [UIView animateWithDuration: 0.5 animations:^{
        [leftRequestContraint setConstant: self.frame.size.width];
        [rightRequestContraint setConstant: - self.frame.size.width];
        [requestView needsUpdateConstraints];
    }];
}

- (IBAction)onClickRequestButton:(id)sender
{
    
    [profileView setHidden:YES];
    
    NSString *requestInfo = @"";
    if (requestType == 1) {
        requestInfo = @"mobile";
    } else {
        requestInfo = @"social";
    }
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    CLLocation *loc = [appDelegate getCurrentlocation];
    
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    NSDictionary *sendParams = [NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"fromid", [DataManager.currentUser objectForKey:@"screenname"], @"fromname", [selectedUserInfo objectForKey:@"id"], @"toid", [selectedUserInfo objectForKey:@"screenname"], @"toname", @"", @"shareinfo", [NSString stringWithFormat:@"%li", (long)timestamp], @"timestamp", [NSString stringWithFormat:@"%.15f", loc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", loc.coordinate.longitude], @"lng", @"request", @"type", requestInfo, @"requesttype", nil];
    [socialNetwork sendNotifications:sendParams withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            [self showAlert:@"Oops! Please check your connection again."];
        } else {
            
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
            NSString *msg = [resultData objectForKey:@"MSG"];
            NSString *resultid = [resultData objectForKey:@"RESULT"];
            
            if ([msg isEqualToString:@"Success"]) {
                
                NSString *message;
                if (requestType == 1) {
                    message = [NSString stringWithFormat:@"You have received a request from %@ to share your mobile number.", [DataManager.currentUser objectForKey:@"screenname"]];
                } else {
                    message = [NSString stringWithFormat:@"You have received a request from %@ to share your social media account.", [DataManager.currentUser objectForKey:@"screenname"]];
                }
                
                NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
                [contents setObject:@"request" forKey:@"type"];
                [contents setObject:requestInfo forKey:@"requesttype"];
                [contents setObject:resultid forKey:@"id"];
                [contents setObject:[DataManager.currentUser objectForKey:@"id"] forKey:@"fromid"];
                [contents setObject:[DataManager.currentUser objectForKey:@"gender"] forKey:@"gender"];
                
                NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[selectedUserInfo objectForKey:@"id"], @"value", nil];
                [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"1"}];
                
                int connects = [[DataManager.currentUser objectForKey:@"connects"] intValue];
                SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
                [socialNetwork updateConnects:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"],@"userid", [NSString stringWithFormat:@"%i",  connects - 1], @"connects",  nil] withCompletion:nil];
                [DataManager.currentUser setObject:[NSString stringWithFormat:@"%i", connects - 1] forKey:@"connects"];
                
                if (requestType == 1) {
                    [self showAlert:[NSString stringWithFormat:@"Your request for %@ number has been sent successfully", [selectedUserInfo objectForKey:@"screenname"]]];
                } else {
                    [self showAlert:[NSString stringWithFormat:@"Your request for %@ social media account has been sent successfully", [selectedUserInfo objectForKey:@"screenname"]]];
                }                
            } else {
                [self showAlert:@"Oops! Please check your connection again."];
            }
        }
    }];
}

- (IBAction)onClickBuzzButton:(id)sender
{
    
    [profileView setHidden:YES];
    
    NSString *message = [NSString stringWithFormat:@"You have received a Buzz from %@.", [DataManager.currentUser objectForKey:@"screenname"]];
    NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
    [contents setObject:@"buzz" forKey:@"type"];
    NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[selectedUserInfo objectForKey:@"id"], @"value", nil];
    [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"0"}];
        
    int connects = [[DataManager.currentUser objectForKey:@"connects"] intValue];
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork updateConnects:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"],@"userid", [NSString stringWithFormat:@"%i",  connects - 1], @"connects",  nil] withCompletion:nil];
    [DataManager.currentUser setObject:[NSString stringWithFormat:@"%i", connects - 1] forKey:@"connects"];
    
    [self showAlert:@"Your Buzz has been sent successfully!"];
}


- (IBAction)onClickSearchType:(UIButton *)sender
{
    switch (searchType) {
        case 1:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_man_off.png"] forState:UIControlStateNormal];
        }   break;
        case 2:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_all_off.png"] forState:UIControlStateNormal];
        }   break;
        case 3:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_girl_off.png"] forState:UIControlStateNormal];
        }   break;
    }
    
    searchType = (int)sender.tag;
    
    switch (searchType) {
        case 1:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_man_on.png"] forState:UIControlStateNormal];
        }   break;
        case 2:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_all_on.png"] forState:UIControlStateNormal];
        }   break;
        case 3:
        {
            UIButton *button = (UIButton*)[genderView viewWithTag:searchType];
            [button setImage:[UIImage imageNamed:@"btn_girl_on.png"] forState:UIControlStateNormal];
        }   break;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:searchType]  forKey:@"distancetype"];
    [defaults synchronize];
    
    [self showNearbyUsers:userArray];
}

- (IBAction)onClickShowCurrentLocation:(id)sender
{
    CLLocationCoordinate2D newCoordinate;
    newCoordinate.latitude = mapView.userLocation.coordinate.latitude;
    newCoordinate.longitude = mapView.userLocation.coordinate.longitude;
    
    MKCoordinateRegion mapRegion;
    mapRegion = MKCoordinateRegionMakeWithDistance(newCoordinate, 150, 150);
    [mapView setRegion:mapRegion animated: YES];
}

- (void)showNearbyUsers:(NSArray *)usersArray
{
    NSInteger toRemoveCount = mapView.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in mapView.annotations)
        if (annotation != mapView.userLocation)
            [toRemove addObject:annotation];
    [mapView removeAnnotations:toRemove];
    
    for ( int i = 0; i < [usersArray count]; i++) {
        
        NSDictionary *user = [usersArray objectAtIndex:i];
        
        if (searchType == 1 && ![[user objectForKey:@"gender"] isEqualToString:@"Male"]) {
            continue;
        } else if (searchType == 3 && ![[user objectForKey:@"gender"] isEqualToString:@"Female"]) {
            continue;
        }
        
        NSTimeInterval passedinterval = [[user objectForKey:@"timestamp"] doubleValue];
        NSDate *date = [NSDate date];
        NSTimeInterval currentInterval = [date timeIntervalSince1970];
        int seconds = currentInterval - passedinterval;
        
        ZSAnnotation *toAdd = [[ZSAnnotation alloc]init];
        toAdd.coordinate = CLLocationCoordinate2DMake( [[user objectForKey:@"lat"] floatValue], [[user objectForKey:@"lng"] floatValue]);
        float distance = [self metersfromPlace:mapView.userLocation.coordinate andToPlace:toAdd.coordinate];
        toAdd.color =[UIColor colorWithRed: 1 - distance / 1000.0f green:0.0f blue: distance / 1000.0f alpha:1.0f];
        toAdd.userinfo = user;
        
        if (seconds < 60) {
            toAdd.subtitle = [NSString stringWithFormat:@"%is ago", seconds];
        } else if (seconds < 3600) {
            toAdd.subtitle = [NSString stringWithFormat:@"%im ago", seconds / 60 + 1];
        } else if (seconds < 3600 * 24) {
            toAdd.subtitle = [NSString stringWithFormat:@"%ih ago", seconds / 3600];
        } else {
            toAdd.subtitle = [NSString stringWithFormat:@"%idays ago", seconds / (3600 * 24)];
        }
        toAdd.title =[user objectForKey:@"screenname"];
        
        if (seconds < 60 && [[user objectForKey:@"verified"] isEqualToString:@"true"]) {
            [mapView addAnnotation:toAdd];
        }
    }
}

-(float)metersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest];
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    return [distance floatValue];
}

#pragma mark touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![profileView isHidden]) {
        [profileView setHidden:YES];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

#pragma mark mapview delegate
- (void)mapView:(MKMapView *)mkmapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    [appDelegate setCurrentlocation:userLocation.location];
    
    CLLocationCoordinate2D newCoordinate;
    newCoordinate.latitude = userLocation.coordinate.latitude;
    newCoordinate.longitude = userLocation.coordinate.longitude;
    
    [self getNearbyUsers:newCoordinate withSearchType:searchType];
    
    if (isFirstTime) {
        isFirstTime = NO;
        MKCoordinateRegion mapRegion;
        mapRegion = MKCoordinateRegionMakeWithDistance(newCoordinate, 300, 300);
        [mkmapView setRegion:mapRegion animated: YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mkmapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // Don't mess with user location
    
    if (annotation == mapView.userLocation) {
        
        static NSString *defaultPinID = @"CurrentLocation";
        ZSPinAnnotation *pinView = (ZSPinAnnotation *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil){
            pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }        
        // Set the type of pin to draw and the color
        if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
            pinView.image = [UIImage imageNamed:@"male.png"];
        } else {
            pinView.image = [UIImage imageNamed:@"female.png"];
        }
        return pinView;
    }
    
    if(![annotation isKindOfClass:[ZSAnnotation class]])
        return nil;
    
    ZSAnnotation *a = (ZSAnnotation *)annotation;
    static NSString *defaultPinID = @"StandardIdentifier";
    
    // Create the ZSPinAnnotation object and reuse it
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil){
        pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    // Set the type of pin to draw and the color
    pinView.annotationType = ZSPinAnnotationTypeTagStroke;
    
    if ([[a.userinfo objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [pinView setImage:[UIImage imageNamed:@"pin_male.png"]];
    } else {
        [pinView setImage:[UIImage imageNamed:@"pin_female.png"]];
    }
    
    pinView.canShowCallout = YES;
//    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pinView;
}

- (void)mapView:(MKMapView *)mkmapView didSelectAnnotationView:(MKAnnotationView *)view
{
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)view;
    ZSAnnotation *annotation = (ZSAnnotation *)pinView.annotation;
    [mkmapView deselectAnnotation:annotation animated:NO];
    if (pinView.annotation != mapView.userLocation) {
        [self showUserInfo:annotation.userinfo];
    }
}

- (void)mapView:(MKMapView *)mkmapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)view;
    ZSAnnotation *annotation = (ZSAnnotation *)pinView.annotation;
    [mkmapView deselectAnnotation:annotation animated:NO];
    
    [self showUserInfo:annotation.userinfo];
}

- (void)showUserInfo:(NSDictionary *)userInfo
{
    int connects = [[DataManager.currentUser objectForKey:@"connects"] intValue];
    
    if (connects > 0) {
        
        selectedUserInfo = userInfo;
        [usernameLabel setText:[userInfo objectForKey:@"screenname"]];
        [balanceLabel setText:[DataManager.currentUser objectForKey:@"connects"]];
        if ([[userInfo objectForKey:@"gender"] isEqualToString:@"Male"]) {
            [userImageView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
        } else {
            [userImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
        }
        NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [userInfo objectForKey:@"image"]];
        [userImageView setImageURL: [NSURL URLWithString: path]];
        userImageView.contentMode = UIViewContentModeScaleToFill;
        userImageView.clipsToBounds = YES;
        
        [leftSendContraint setConstant: self.frame.size.width];
        [rightSendContraint setConstant: - self.frame.size.width];
        [leftRequestContraint setConstant: self.frame.size.width];
        [rightRequestContraint setConstant: - self.frame.size.width];
        [profileView setHidden:NO];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( [[selectedUserInfo objectForKey:@"lat"] floatValue], [[selectedUserInfo objectForKey:@"lng"] floatValue]);
        float distance = [self metersfromPlace: mapView.userLocation.coordinate andToPlace: coordinate];
        if (distance < 500.f) {
            [buzzButton setHidden:NO];
            [buzzLabel setHidden:NO];
        } else {
            [buzzButton setHidden:YES];
            [buzzLabel setHidden:YES];
        }
        
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:@"You don't have enough Buzz Shares. Would you like to buy now?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [alertController dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        UIAlertAction* buyAction = [UIAlertAction actionWithTitle:@"Buy" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                  PaymentViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
                                                                  [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                              }];
        [alertController addAction:defaultAction];
        [alertController addAction:buyAction];
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}

-(void) createMaskForImage:(UIImageView *)image
{
    CALayer *mask = [CALayer layer];
    UIImage *maskImage = [UIImage imageNamed:@"icon_mask.png"];
    maskImage = [self imageWithImage:maskImage scaledToSize:image.frame.size];
    mask.contents = (id)[maskImage CGImage];
    mask.frame = CGRectMake(0, 0,maskImage.size.width, maskImage.size.height);
    image.layer.mask = mask;
    image.layer.masksToBounds = YES;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showAlert:(NSString*)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alertController addAction:defaultAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
