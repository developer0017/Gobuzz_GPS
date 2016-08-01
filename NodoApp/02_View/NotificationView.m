//
//  NotificationView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 05/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "NotificationView.h"
#import "AppDelegate.h"
#import "HistoryViewController.h"
#import "HistoryDetailViewController.h"
#import "HomeViewController.h"
#import "SidebarViewController.h"
#import "NotificationListViewController.h"

@implementation NotificationView
@synthesize photoView;
@synthesize usernameLabel;
@synthesize acceptOrRejectLabel;
@synthesize acceptAndSendLabel;
@synthesize acceptAndSendButton;
@synthesize acceptOrRejectButton;
@synthesize infoLabel;
@synthesize controller;

- (void) initializeViewWithController:(NotificationsViewController *)notiController withInfo:(NSDictionary*)info
{
    controller = notiController;
    receivedInfo = [NSDictionary dictionaryWithDictionary:info];
    DataManager.historyID = [receivedInfo objectForKey:@"fromid"];
    DataManager.historyGender = [receivedInfo objectForKey:@"gender"];
    
    [usernameLabel setText:[receivedInfo objectForKey:@"screenname"]];
    
    if ([[receivedInfo objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [receivedInfo objectForKey:@"image"]];
    [photoView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:photoView];
    
    if ([[receivedInfo objectForKey:@"type"] isEqualToString:@"request"]) {
        [acceptOrRejectLabel setText:@"Decline"];
        [acceptOrRejectButton setImage:[UIImage imageNamed:@"btn_decline.png"] forState:UIControlStateNormal];
    } else {
        [acceptOrRejectLabel setText:@"Accept"];
        [acceptOrRejectButton setImage:[UIImage imageNamed:@"btn_accept.png"] forState:UIControlStateNormal];
    }
    
    if ([[receivedInfo objectForKey:@"type"] isEqualToString:@"request"]) {
        if ([[receivedInfo objectForKey:@"requesttype"] isEqualToString:@"mobile"]) {
            [infoLabel setText:[NSString stringWithFormat:@"You have received a request from %@ to share your Mobile number", [receivedInfo objectForKey:@"screenname"]]];
        } else {
            [infoLabel setText:[NSString stringWithFormat:@"You have received a request from %@ to share your Social Media account", [receivedInfo objectForKey:@"screenname"]]];
        }
    } else {
        if ([[receivedInfo objectForKey:@"requesttype"] isEqualToString:@"mobile"]) {
            [infoLabel setText:[NSString stringWithFormat:@"You have received %@'s mobile number", [receivedInfo objectForKey:@"screenname"]]];
        } else {
            [infoLabel setText:[NSString stringWithFormat:@"You have received %@'s social media account", [receivedInfo objectForKey:@"screenname"]]];
        }
    }
}

- (IBAction)onClickBackButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
}

- (IBAction)onClickAcceptOrReject:(id)sender
{
    
    if ([[receivedInfo objectForKey:@"type"] isEqualToString:@"request"]) {
        
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        [socialNetwork declineNotifications:[NSDictionary dictionaryWithObjectsAndKeys: [receivedInfo objectForKey:@"id"], @"notificationid", [DataManager.currentUser objectForKey:@"id"],@"userid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
               
                if (error) {
                    
                    [self showAlert:@"Oops! Please check your connection again."];
                } else {
                    
                    NSString *message = [NSString stringWithFormat:@"%@ have rejected your request!", [DataManager.currentUser objectForKey:@"screenname"]];
                    
                    NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
                    [contents setObject:@"response_reject" forKey:@"type"];
                    NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[receivedInfo objectForKey:@"fromid"], @"value", nil];
                    [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"0"}];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:[NSString stringWithFormat:@"You have rejected %@'s request!", [receivedInfo objectForKey:@"screenname"]] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                              NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
                                                                              [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                          }];
                    
                    [alertController addAction:defaultAction];
                    [controller presentViewController:alertController animated:YES completion:nil];
                }                
            });
        }];
        
    } else {
        
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        [socialNetwork acceptNotifications:[NSDictionary dictionaryWithObjectsAndKeys: [receivedInfo objectForKey:@"id"],@"notificationid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if (error) {
                    [self showAlert:@"Oops! Please check your connection again."];
                } else {
                    //                [self sendInfo];
                    if ([[receivedInfo objectForKey:@"requesttype"] isEqualToString:@"social"]) {
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        HistoryDetailViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryDetailViewController"];
                        [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                        
                    } else {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        
                        HistoryDetailViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryDetailViewController"];
                        
                        [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                    }
                }
                
            });
        }];
    }
}

- (IBAction)onClickAcceptAndSend:(id)sender
{
    
    if ([[receivedInfo objectForKey:@"type"] isEqualToString:@"request"]) {
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        [socialNetwork declineNotifications:[NSDictionary dictionaryWithObjectsAndKeys: [receivedInfo objectForKey:@"id"],@"notificationid", [DataManager.currentUser objectForKey:@"id"],@"userid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (error) {
                    [self showAlert:@"Oops! Please check your connection again."];
                } else {
                    [self sendInfo];
                }
            });
        }];
    } else {
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        [socialNetwork acceptNotifications:[NSDictionary dictionaryWithObjectsAndKeys: [receivedInfo objectForKey:@"id"],@"notificationid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (error) {
                    [self showAlert:@"Oops! Please check your connection again."];
                } else {
                    [self sendInfo];
                }
            });
        }];
    }
}

- (void)sendInfo
{
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    CLLocation *loc = [appDelegate getCurrentlocation];
    
    NSString *facebookID = [DataManager.currentUser objectForKey:@"facebookid"];
    NSString *twitterID = [DataManager.currentUser objectForKey:@"twitterid"];
    NSString *instagramID = [DataManager.currentUser objectForKey:@"instagramid"];
    NSString *snapchatID = [DataManager.currentUser objectForKey:@"snapchatid"];
    
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
    
    if ( [[receivedInfo objectForKey:@"requesttype"] isEqualToString:@"social"] && [shareInfo length] != 0 ) {
        
        NSString *message = [NSString stringWithFormat:@"You have received %@'s social media account", [DataManager.currentUser objectForKey:@"screenname"]];
        NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
        [contents setObject:@"response_acceptandsend" forKey:@"type"];
        NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[receivedInfo objectForKey:@"fromid"], @"value", nil];
        [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"0"}];
        
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
        [socialNetwork sendInfo:[NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"fromid", [DataManager.currentUser objectForKey:@"screenname"], @"fromname", [receivedInfo objectForKey:@"fromid"], @"toid", [receivedInfo objectForKey:@"screenname"], @"toname", shareInfo, @"shareinfo", [NSString stringWithFormat:@"%li", (long)timestamp], @"timestamp", [NSString stringWithFormat:@"%.15f", loc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", loc.coordinate.longitude], @"lng", nil] withCompletion:nil];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:@"Your social media account has been shared successfully!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  if ([[receivedInfo objectForKey:@"type"] isEqualToString:@"request"]) {
                                                                      
                                                                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                      NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
                                                                      [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                      
                                                                  } else {
                                                                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                      HistoryDetailViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryDetailViewController"];
                                                                      [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                  }                                                                  
                                                              }];
        
        [alertController addAction:defaultAction];
        [controller presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        NSString *message = [NSString stringWithFormat:@"You have received %@'s Number", [DataManager.currentUser objectForKey:@"screenname"]];
        NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
        [contents setObject:@"response_acceptandsend" forKey:@"type"];
        NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys: @"userid", @"key", @"=", @"relation",[receivedInfo objectForKey:@"fromid"], @"value", nil];
        [[AppDelegate sharedAppDelegate].oneSignal postNotification:@{@"contents":@{@"en": message}, @"tags": @[tags], @"data":contents, @"ios_badgeType":@"Increase", @"ios_badgeCount": @"0"}];
        
        SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
        NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
        [socialNetwork sendInfo:[NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"fromid", [DataManager.currentUser objectForKey:@"screenname"], @"fromname", [receivedInfo objectForKey:@"fromid"], @"toid", [receivedInfo objectForKey:@"screenname"], @"toname", [NSString stringWithFormat:@"Mobile : %@", [DataManager.currentUser objectForKey:@"sharenumber"]], @"shareinfo", [NSString stringWithFormat:@"%li", (long)timestamp], @"timestamp", [NSString stringWithFormat:@"%.15f", loc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", loc.coordinate.longitude], @"lng", nil] withCompletion: nil];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:@"Your mobile number has been shared successfully!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  if ([[receivedInfo objectForKey:@"type"] isEqualToString:@"request"]) {
                                                                      
                                                                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                      NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
                                                                      [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                      
                                                                  } else {
                                                                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                      HistoryDetailViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryDetailViewController"];
                                                                      [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                  }
                                                              }];
        
        [alertController addAction:defaultAction];
        [controller presentViewController:alertController animated:YES completion:nil];
    }
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

@end
