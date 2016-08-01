//
//  PaymentView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentViewController.h"
#import "AsyncImageView.h"

@interface PaymentView : UIView
{
    NSString *selectedID;
}
@property (nonatomic, retain) IBOutlet AsyncImageView *photoView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *buzzShareLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) PaymentViewController *controller;

- (void)initialiseViewWithController:(PaymentViewController*)paymentViewController;

@end
