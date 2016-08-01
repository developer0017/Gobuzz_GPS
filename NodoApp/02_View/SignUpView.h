//
//  SignUpView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "INTULocationManager.h"

@interface SignUpView : UIView<UITextFieldDelegate, UIImagePickerControllerDelegate>
{
    CGSize          kbSize;
    UIImage         *userPhoto;
    BOOL            emailValidFlag;
    BOOL            mobileValidFlag;
}

@property (nonatomic, retain) IBOutlet UIImageView *userImageView;
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
@property (nonatomic, retain) SignUpViewController *controller;

- (void)initialiseViewWithController:(SignUpViewController*)signupController;
- (void)showEmailValidatingResults:(BOOL) flag;
- (void)showMobileValidatingResults:(BOOL) flag;
@end
