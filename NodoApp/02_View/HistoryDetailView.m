//
//  HistoryDetailView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 11/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "HistoryDetailView.h"
#import "SidebarViewController.h"
#import "HistoryListViewController.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@implementation HistoryDetailView
@synthesize usernameLabel;
@synthesize photoView;
@synthesize shareLabel;
@synthesize timeLabel;
@synthesize markImageView;
@synthesize socialView;
@synthesize widthConstraint;
@synthesize locationLabel;
@synthesize indicatorView;
@synthesize controller;

- (void)initialiseViewWithController:(HistoryDetailViewController *)detailController
{
    controller = detailController;
    
    if (DataManager.historyID == nil) {
    
        [self initialiseView];
    } else {
        
        if ([DataManager.historyGender isEqualToString:@"Male"]) {
            [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
            [markImageView setImage:[UIImage imageNamed:@"pin_male.png"]];
        } else {
            [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
            [markImageView setImage:[UIImage imageNamed:@"pin_female.png"]];
        }
        
        [indicatorView setHidden:NO];
        [indicatorView startAnimating];
        
        SocialNetwork *socialnetwork = [[SocialNetwork alloc] init];
        [socialnetwork getUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:DataManager.historyID, @"fromid", [DataManager.currentUser objectForKey:@"id"], @"toid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicatorView stopAnimating];
                [indicatorView setHidden:YES];
                
                if (error) {
                    [self showAlert:@"Oops! Please check your connection again."];
                } else {
                    
                    NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                    int success = [[resultData objectForKey:@"SUCCESS"] intValue];
                    
                    if (success == 0) {
                        [self showAlert:@"Oops! Please check your connection again!"];
                    } else {
                        DataManager.historyData = [NSMutableDictionary dictionaryWithDictionary:[resultData objectForKey:@"RESULT"]];
                        [self initialiseView];
                    }
                }
            });
        }];
    }
}

- (void)initialiseView
{
    
    [usernameLabel setText:[DataManager.historyData objectForKey:@"screenname"]];
    
    if ([[DataManager.historyData objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
        [markImageView setImage:[UIImage imageNamed:@"pin_male.png"]];
    } else {
        [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
        [markImageView setImage:[UIImage imageNamed:@"pin_female.png"]];
    }
    
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.historyData objectForKey:@"image"]];
    [photoView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:photoView];
    
    NSString *shareInfo = [DataManager.historyData objectForKey:@"shareinfo"];
    if ([shareInfo containsString:@"Mobile"]) {
        [shareLabel setText:shareInfo];
    } else {
        
        int offset = 0;
        if ([shareInfo containsString:@"Twitter"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, 55, 50)];
            [button setImage:[UIImage imageNamed:@"icon_twitter.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickTwitterButton:) forControlEvents:UIControlEventTouchUpInside];
            [socialView addSubview:button];
            offset += 60;
        }
        
        if ([shareInfo containsString:@"Instagram"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, 55, 50)];
            [button setImage:[UIImage imageNamed:@"icon_instagram.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickInstagramButton:) forControlEvents:UIControlEventTouchUpInside];
            [socialView addSubview:button];
            offset += 60;
        }
        
        if ([shareInfo containsString:@"Snapchat"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, 55, 50)];
            [button setImage:[UIImage imageNamed:@"icon_snapchat.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickSnapchatButton:) forControlEvents:UIControlEventTouchUpInside];
            [socialView addSubview:button];
            offset += 60;
        }
        
        if ([shareInfo containsString:@"Pinterest"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, 55, 50)];
            [button setImage:[UIImage imageNamed:@"icon_pinterest.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickPinterestButton:) forControlEvents:UIControlEventTouchUpInside];
            [socialView addSubview:button];
            offset += 55;
        }
        [widthConstraint setConstant:offset];
        
        socialOffset = (self.frame.size.width - offset) / 2;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@",[DataManager.historyData objectForKey:@"lat"], [DataManager.historyData objectForKey:@"lng"]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
    if ([[dic objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSArray *resultsData = [dic objectForKey:@"results"];
        if ([resultsData count] > 0) {
            NSDictionary *addressData = [resultsData objectAtIndex:0];
            [locationLabel setText:[addressData objectForKey:@"formatted_address"]];
        }
    }
    
    NSInteger timestamp = [[DataManager.historyData objectForKey:@"timestamp"] integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
    [yearFormat setDateFormat:@"MMMM dd, yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    [timeLabel setText:[NSString stringWithFormat:@"%@\n%@", [yearFormat stringFromDate:date], [timeFormat stringFromDate:date]]];
}

- (void)onClickTwitterButton:(UIButton *)sender
{
    hudFlag = YES;
    NSString *shareInfo = [DataManager.historyData objectForKey:@"shareinfo"];
    NSString *startString = [shareInfo substringFromIndex:[shareInfo rangeOfString:@"Twitter"].location + 9];
    
    NSString *info;
    if ([startString rangeOfString:@":"].location != NSNotFound) {
        NSString *endString = [startString substringToIndex:[startString rangeOfString:@":"].location];
        info = [endString substringToIndex:[endString rangeOfString:@" " options:NSBackwardsSearch].location];
    } else {
        info = startString;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud.label setText:info];
    hud.margin = 10.f;
    [hud setOffset:CGPointMake( (sender.center.x - socialView.frame.size.width / 2), (socialView.center.y - self.frame.size.height / 2) - 60)];
    [hud showAnimated:YES];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:info];
}

- (void)onClickInstagramButton:(UIButton *)sender
{
    hudFlag = YES;
    NSString *shareInfo = [DataManager.historyData objectForKey:@"shareinfo"];
    NSString *startString = [shareInfo substringFromIndex:[shareInfo rangeOfString:@"Instagram"].location + 11];
    
    NSString *info;
    if ([startString rangeOfString:@":"].location != NSNotFound) {
        NSString *endString = [startString substringToIndex:[startString rangeOfString:@":"].location];
        info = [endString substringToIndex:[endString rangeOfString:@" " options:NSBackwardsSearch].location];
    } else {
        info = startString;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud.label setText:info];
    hud.margin = 10.f;
    [hud setOffset:CGPointMake( (sender.center.x - socialView.frame.size.width / 2), (socialView.center.y - self.frame.size.height / 2) - 60)];
    [hud showAnimated:YES];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:info];
}

- (void)onClickSnapchatButton:(UIButton *)sender
{
    hudFlag = YES;
    NSString *shareInfo = [DataManager.historyData objectForKey:@"shareinfo"];
    NSString *startString = [shareInfo substringFromIndex:[shareInfo rangeOfString:@"Snapchat"].location + 10];
    
    NSString *info;
    if ([startString rangeOfString:@":"].location != NSNotFound) {
        NSString *endString = [startString substringToIndex:[startString rangeOfString:@":"].location];
        info = [endString substringToIndex:[endString rangeOfString:@" " options:NSBackwardsSearch].location];
    } else {
        info = startString;
    }
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud.label setText:info];
    hud.margin = 10.f;
    [hud setOffset:CGPointMake( (sender.center.x - socialView.frame.size.width / 2), (socialView.center.y - self.frame.size.height / 2) - 60)];
    [hud showAnimated:YES];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:info];
}

- (void)onClickPinterestButton:(UIButton *)sender
{
    hudFlag = YES;
    NSString *shareInfo = [DataManager.historyData objectForKey:@"shareinfo"];
    NSString *startString = [shareInfo substringFromIndex:[shareInfo rangeOfString:@"Pinterest"].location + 11];
    
    NSString *info;
    if ([startString rangeOfString:@":"].location != NSNotFound) {
        NSString *endString = [startString substringToIndex:[startString rangeOfString:@":"].location];
        info = [endString substringToIndex:[endString rangeOfString:@" " options:NSBackwardsSearch].location];
    } else {
        info = startString;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud.label setText:info];
    hud.margin = 10.f;
    [hud setOffset:CGPointMake( (sender.center.x - socialView.frame.size.width / 2), (socialView.center.y - self.frame.size.height / 2) - 60)];
    [hud showAnimated:YES];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:info];
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

- (IBAction)onClickMenuButton:(id)sender
{
    if (![[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    } else {
        [[SidebarViewController share] hideMenu];
    }
}

- (IBAction)onClickBackButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HistoryListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryListViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
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

#pragma mark touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (hudFlag) {
        hudFlag = NO;
        [MBProgressHUD hideHUDForView:self animated:YES];
    }
}
@end
