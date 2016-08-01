//
//  HistoryView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryViewController.h"
#import "AsyncImageView.h"

@interface HistoryView : UIView
{
    
}
@property (nonatomic, retain) IBOutlet AsyncImageView *photoView;
@property (nonatomic, retain) IBOutlet UILabel  *usernameLabel;
@property (nonatomic, retain) HistoryViewController *controller;

- (void)initialiseViewWithController:(HistoryViewController *)historyViewController;
@end
