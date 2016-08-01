//
//  EmailVerificationView.h
//  NodoApp
//
//  Created by Polaris on 26/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailVerificationViewController.h"
#import "INTULocationManager.h"

@interface EmailVerificationView : UIView
{
    CGSize          kbSize;
    BOOL            firstSendFlag;
}
@property (nonatomic, retain) IBOutlet UITextField *codeField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIButton *resendButton;
@property (nonatomic, retain) EmailVerificationViewController *controller;

- (void)initialiseViewWithController:(EmailVerificationViewController*)emailViewController;

@end
