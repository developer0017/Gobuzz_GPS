//
//  HistoryDetailView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 11/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDetailViewController.h"
#import "AsyncImageView.h"

@interface HistoryDetailView : UIView
{
    BOOL    hudFlag;
    int     socialOffset;
}
@property (nonatomic, retain) IBOutlet AsyncImageView *photoView;
@property (nonatomic, retain) IBOutlet UIView   *socialView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, retain) IBOutlet UILabel  *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel  *shareLabel;
@property (nonatomic, retain) IBOutlet UILabel  *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel  *locationLabel;
@property (nonatomic, retain) IBOutlet UIImageView *markImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) HistoryDetailViewController *controller;

- (void)initialiseViewWithController:(HistoryDetailViewController *)detailController;

@end
