//
//  ProfileView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ProfileViewController.h"

@interface ProfileView : UIView
{
    UIImage         *userPhoto;
    NSDictionary    *userData;
    
    BOOL            editedFlag;
    CGSize          kbSize;
    UITextField     *selectedField;
    CLLocation          *currentLoc;
    
    BOOL            emailValidFlag;
    BOOL            mobileValidFlag;
}
@property (nonatomic, retain) IBOutlet AsyncImageView *userImageView;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *genderField;
@property (nonatomic, retain) IBOutlet UITextField *screennameField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *emailIndicatorView;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *mobileFiled;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *phoneIndicatorView;
@property (nonatomic, retain) IBOutlet UITextField *sharenumberField;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) ProfileViewController *controller;

- (void)initialiseViewWithController:(ProfileViewController *)profileViewController;

@end
