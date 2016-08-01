//
//  LeftSideBarViewController.m
//  CBCTV
//
//  Created by Albert Bluemel on 23/10/15.
//  Copyright © 2015 bluemelservices. All rights reserved.
//

#import "LeftSideBarViewController.h"
#import "AppDelegate.h"
#import "SidebarViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "PaymentViewController.h"
#import "NotificationListViewController.h"
#import "HistoryViewController.h"
#import "TermsAndConditionsViewController.h"

@implementation LeftSideBarViewController
@synthesize nameLabel;
@synthesize photoView;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [nameLabel setText:[DataManager.currentUser objectForKey:@"username"]];
    if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
    [photoView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:photoView];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (DataManager.pickerFlag) {
        DataManager.pickerFlag = NO;
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        if ( DataManager.badgeNumber != 0) {
            NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            HomeViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
                [delegate leftSideBarSelectWithController:mainViewController];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickMenuButton:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    switch (sender.tag) {
        case 1:
        {
            HomeViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
        } break;
        
        case 2:
        {
            ProfileViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
        } break;
            
        case 3:
        {
            PaymentViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
        } break;
        
        case 4:
        {
            NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
        } break;
            
        case 5:
        {
            HistoryViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
        } break;
          
            
        case 8:
        {
            TermsAndConditionsViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionsViewController"];
            [delegate leftSideBarSelectWithController:mainViewController];
        } break;
            
        case 10:
        {
            AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
            [appDelegate stopUpdatingLoc];
            [[SidebarViewController share] logout];
        } break;
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

- (void)updateUserPhoto
{
    [nameLabel setText:[DataManager.currentUser objectForKey:@"username"]];
    if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
    [photoView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:photoView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
