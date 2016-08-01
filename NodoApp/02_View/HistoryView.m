//
//  HistoryView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "HistoryView.h"
#import "SidebarViewController.h"
#import "HistoryListViewController.h"

@implementation HistoryView
@synthesize photoView;
@synthesize usernameLabel;
@synthesize controller;

- (void)initialiseViewWithController:(HistoryViewController *)profileViewController
{
    controller = profileViewController;
   
    if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
    [photoView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:photoView];
    [usernameLabel setText:[DataManager.currentUser objectForKey:@"username"]];
}

- (IBAction)onClickButton:(UIButton *)sender
{
    if (sender.tag == 1) {
        DataManager.historyType = @"Sent";
    } else {
        DataManager.historyType = @"Received";
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HistoryListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryListViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
}

- (IBAction)onClickMenuButton:(id)sender
{
    if (![[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    } else {
        [[SidebarViewController share] hideMenu];
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
@end
