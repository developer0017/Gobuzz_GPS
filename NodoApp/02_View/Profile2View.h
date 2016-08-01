//
//  Profile2View.h
//  NodoApp
//
//  Created by Gustavo Alonso on 11/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile2ViewController.h"
#import "AsyncImageView.h"

@interface Profile2View : UIView
{
    BOOL            editedFlag;
    CGSize          kbSize;
    
    CLLocation          *currentLoc;
}
@property (nonatomic, retain) IBOutlet UILabel      *titleLabel;
@property (nonatomic, retain) IBOutlet AsyncImageView  *userImageView;
@property (nonatomic, retain) IBOutlet UITextField  *facebookIDField;
@property (nonatomic, retain) IBOutlet UITextField  *twitterIDField;
@property (nonatomic, retain) IBOutlet UITextField  *instagramIDField;
@property (nonatomic, retain) IBOutlet UITextField  *snapchatIDField;
@property (nonatomic, retain) IBOutlet UIButton     *signupButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) Profile2ViewController *controller;

- (void)initialiseViewWithController:(Profile2ViewController*)profileController;
@end
