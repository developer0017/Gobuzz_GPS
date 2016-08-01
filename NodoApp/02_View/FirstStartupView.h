//
//  FirstStartupView.h
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstStartupViewController.h"

@interface FirstStartupView : UIView
{
    NSString *selectedID;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) FirstStartupViewController *controller;

- (void)initializeViewWithController :(FirstStartupViewController *)controller;


@end
