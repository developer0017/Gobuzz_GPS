//
//  NotificationListView.m
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "NotificationListView.h"
#import "SidebarViewController.h"
#import "NotificationsViewController.h"
#import "AsyncImageView.h"

@implementation NotificationListView
@synthesize indicatorView;
@synthesize markScrlView;
@synthesize notificationLabel;
@synthesize controller;

- (void)initialiseViewWithController:(NotificationListViewController*)notificationListViewController;
{
    controller = notificationListViewController;
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
    NotificationListViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
}

- (void)showInfos:(NSArray *)infos
{
    [indicatorView setHidden:YES];
    
    for (UIView *subView in [markScrlView subviews]) {
        [subView removeFromSuperview];
    }
    
    int offset = 0;
    notificationArray = [NSArray arrayWithArray:infos];
    
    for (int i = (int)[notificationArray count] - 1; i >= 0  ; i-- ) {
        
        NSDictionary *dic = [notificationArray objectAtIndex:i];
        
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake( 5, offset + 5, markScrlView.frame.size.width - 10, 34)];
        [button setBackgroundImage:[UIImage imageNamed:@"bk_historyrow.png"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        [button setTitle:[dic objectForKey:@"screenname"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.28 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:17.0f]];
        [button setTag:i];
        [button addTarget:self action:@selector(onClickNotification:) forControlEvents:UIControlEventTouchUpInside];
        [markScrlView addSubview:button];
        
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake( 1, offset + 1, 48, 44)];
        if ([[dic objectForKey:@"gender"] isEqualToString:@"Male"]) {
            [imageView setImage:[UIImage imageNamed:@"btn_man_off.png"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"btn_girl_off.png"]];
        }
        NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [dic objectForKey:@"image"]];
        [imageView setImageURL:[NSURL URLWithString:path]];
        [markScrlView addSubview:imageView];
        [self createMaskForImage:imageView];
        
        UIImageView *borderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset, 50, 46)];
        [borderImgView setImage:[UIImage imageNamed:@"border_profile.png"]];
        [markScrlView addSubview:borderImgView];
        offset += 55;
    }
    [markScrlView setContentSize:CGSizeMake(markScrlView.frame.size.width, offset)];
    
    if ([infos count] == 0) {
        [notificationLabel setHidden:NO];
    } else {
        [notificationLabel setHidden:YES];
    }
}

- (void)onClickNotification:(UIButton*)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NotificationsViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
    mainViewController.type = 0;
    mainViewController.receivedInfo = [notificationArray objectAtIndex:sender.tag];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
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
