//
//  NotificationListView.h
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationListViewController.h"

@interface NotificationListView : UIView
{
    NSArray *notificationArray;
}
@property (nonatomic, retain) IBOutlet UIScrollView *markScrlView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UILabel *notificationLabel;
@property (nonatomic, retain) NotificationListViewController *controller;


- (void)initialiseViewWithController:(NotificationListViewController*)notificationListViewController;
- (void)showInfos:(NSArray *)infos;
@end
