//
//  SignInView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"

@interface SignInView : UIView
{
    CGSize          kbSize;
    BOOL            rememberFlag;
    NSDate          *startingTime;
}
@property (nonatomic, retain) IBOutlet UIImageView *bkImageView;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *rememberButton;
@property (nonatomic, retain) IBOutlet UIButton *signinButton;
@property (nonatomic, retain) IBOutlet UIView   *landingPage;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) SignInViewController *controller;

- (void)initialiseViewWithController:(SignInViewController*)signinController;

@end
