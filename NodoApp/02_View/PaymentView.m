//
//  PaymentView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "PaymentView.h"
#import "SidebarViewController.h"

@implementation PaymentView
@synthesize photoView;
@synthesize usernameLabel;
@synthesize buzzShareLabel;
@synthesize indicatorView;
@synthesize controller;

- (void)initialiseViewWithController:(PaymentViewController*)paymentViewController
{
    selectedID = @"fares.gobuzz.plan1";
    controller = paymentViewController;
    usernameLabel.text = [DataManager.currentUser objectForKey:@"username"];
    if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [photoView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [photoView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
    [photoView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:photoView];
    
    if ([[DataManager.currentUser objectForKey:@"connects"] length] == 0) {
        [buzzShareLabel setText:@"Your Buzz Shares balance is 0"];
    } else {
        [buzzShareLabel setText:[NSString stringWithFormat:@"Your Buzz Shares balance is %@", [DataManager.currentUser objectForKey:@"connects"]]];
    }
}

- (IBAction)onClickPlanButton:(UIButton*)sender
{
    NSArray *productIDArray = [NSArray arrayWithObjects: @"fares.gobuzz.plan1", @"fares.gobuzz.plan2", @"fares.gobuzz.plan3", nil];    
    for (int i = 1; i < 4; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        if (sender.tag == i) {
            selectedID = [productIDArray objectAtIndex:i - 1];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_plan_on.png"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"btn_plan_off.png"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)onClickSubscribeButton:(id)sender
{
    [controller buyProduct:selectedID];
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
