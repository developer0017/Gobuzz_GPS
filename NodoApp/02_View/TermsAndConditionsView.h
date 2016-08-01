//
//  TermsAndConditionsView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsAndConditionsViewController.h"

@interface TermsAndConditionsView : UIView
{
    
}
@property (nonatomic, retain) IBOutlet UITextView   *termsView;
@property (nonatomic, retain) TermsAndConditionsViewController *controller;

- (void)initialiseViewWithController:(TermsAndConditionsViewController *)termsController;

@end
