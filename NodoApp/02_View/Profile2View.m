//
//  Profile2View.m
//  NodoApp
//
//  Created by Gustavo Alonso on 11/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "Profile2View.h"
#import "SidebarViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

@implementation Profile2View
@synthesize titleLabel;
@synthesize userImageView;
@synthesize facebookIDField;
@synthesize twitterIDField;
@synthesize instagramIDField;
@synthesize snapchatIDField;
@synthesize signupButton;
@synthesize indicatorView;
@synthesize controller;

- (void)initialiseViewWithController:(Profile2ViewController*)profileController;
{
    controller = profileController;
    kbSize = CGSizeZero;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapEvent:)];
    [self addGestureRecognizer:tapGesture];
        
    [titleLabel setText:[DataManager.currentUser objectForKey:@"username"]];
    if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [userImageView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [userImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
    [userImageView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:userImageView];
    
    editedFlag = NO;
    [facebookIDField setText:[DataManager.currentUser objectForKey:@"facebookid"]];
    [twitterIDField setText:[DataManager.currentUser objectForKey:@"twitterid"]];
    [snapchatIDField setText:[DataManager.currentUser objectForKey:@"snapchatid"]];
    [instagramIDField setText:[DataManager.currentUser objectForKey:@"instagramid"]];
}

- (void)onClickTapEvent:(UITapGestureRecognizer *)gesture
{
    [self endEditing:YES];
}

- (IBAction)onClickBackButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ProfileViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
}

- (IBAction)onClickUpdateButton:(id)sender
{
    if (editedFlag) {
        [indicatorView setHidden:NO];
        [indicatorView startAnimating];
        
        NSDate *date = [NSDate date];
        NSTimeInterval interval = [date timeIntervalSince1970];
        
        AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
        currentLoc = [appDelegate getCurrentlocation];
        
        NSMutableDictionary *params;
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"], @"userid",[DataManager.currentUser objectForKey:@"username"], @"username", [DataManager.currentUser objectForKey:@"gender"], @"gender", [DataManager.currentUser objectForKey:@"screenname"], @"screenname", [DataManager.currentUser objectForKey:@"email"], @"email", [DataManager.currentUser objectForKey:@"password"], @"password", [DataManager.currentUser objectForKey:@"mobilenumber"], @"mobilenumber", [DataManager.currentUser objectForKey:@"sharenumber"], @"sharenumber", facebookIDField.text, @"facebookid", twitterIDField.text, @"twitterid", instagramIDField.text, @"instagramid", snapchatIDField.text, @"snapchatid", [NSString stringWithFormat:@"%.15f", currentLoc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", currentLoc.coordinate.longitude], @"lng", [NSString stringWithFormat:@"%f", interval], @"timestamp", nil];
        
        NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
        [self updateUser:params withImage:[self imageWithImage:image scaledToSize:CGSizeMake(150, 150)]];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ProfileViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
    }
}

- (void)updateUser :(NSDictionary*)params withImage:(UIImage *)image
{
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork updateUserInfo:params withImage:image withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicatorView setHidden:YES];
            [indicatorView stopAnimating];
            
            if (error) {
                [self showAlert:@"Update Oops! Please check your connection again."];
            } else {
                
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                if ([msg isEqualToString:@"Update Success!"]) {
                    
                    DataManager.currentUser = [NSMutableDictionary dictionaryWithDictionary:[resultData objectForKey:@"RESULT"]];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Update Profile" message:@"Your profile has been updated successfully!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                              ProfileViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                                                                              [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                                                                          }];
                    
                    [alertController addAction:defaultAction];
                    [controller presentViewController:alertController animated:YES completion:nil];
                } else {
                    [self showAlert:msg];
                }
            }
        });
    }];
}

#pragma mark keyboad notificaiton
- (void)UIKeyboardWillShowNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber *durationValue = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveValue = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:durationValue.doubleValue delay:0.0 options:(animationCurve << 16) animations:^(void) {
        SidebarViewController *sidebarController = [SidebarViewController share];
        
        kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        int margin = sidebarController.view.frame.size.height -sidebarController.view.frame.origin.y - kbSize.height - (signupButton.frame.origin.y + signupButton.frame.size.height);
        if (margin < 5) {
            [sidebarController.view setFrame:CGRectOffset(sidebarController.view.frame, 0, -(5 - margin))];
        } else {
            if (sidebarController.view.frame.origin.y < 0) {
                [sidebarController.view setFrame:CGRectOffset(sidebarController.view.frame, 0, MIN( - sidebarController.view.frame.origin.y, margin - 5))];
            }
        }
    } completion:nil];
}

- (void)UIKeyboardWillHideNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber *durationValue = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveValue = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:durationValue.doubleValue delay:0.0 options:(animationCurve << 16) animations:^(void) {
        
        SidebarViewController *sidebarController = [SidebarViewController share];
        [sidebarController.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:nil];
}


#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    editedFlag = YES;
    
    return YES;
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
