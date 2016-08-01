//
//  SignUp2View.h
//  NodoApp
//
//  Created by Gustavo Alonso on 10/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUp2ViewController.h"
#import "INTULocationManager.h"

@interface SignUp2View : UIView
{
    CGSize              kbSize;
    CLLocation          *currentLoc;
    INTULocationManager *locManager;
}

@property (nonatomic, retain) IBOutlet UILabel      *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView  *userImageView;
@property (nonatomic, retain) IBOutlet UITextField  *facebookIDField;
@property (nonatomic, retain) IBOutlet UITextField  *twitterIDField;
@property (nonatomic, retain) IBOutlet UITextField  *instagramIDField;
@property (nonatomic, retain) IBOutlet UITextField  *snapchatIDField;
@property (nonatomic, retain) IBOutlet UIButton     *signupButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) SignUp2ViewController *controller;

- (void)initialiseViewWithController:(SignUp2ViewController*)signupController;

@end
