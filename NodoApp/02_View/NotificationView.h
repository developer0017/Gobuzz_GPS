//
//  NotificationView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 05/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsViewController.h"
#import "AsyncImageView.h"

@interface NotificationView : UIView
{
    NSDictionary    *receivedInfo;
}
@property (nonatomic, retain) IBOutlet UILabel  *acceptOrRejectLabel;
@property (nonatomic, retain) IBOutlet UILabel  *acceptAndSendLabel;
@property (nonatomic, retain) IBOutlet AsyncImageView *photoView;
@property (nonatomic, retain) IBOutlet UILabel  *usernameLabel;
@property (nonatomic, retain) IBOutlet UIButton *acceptOrRejectButton;
@property (nonatomic, retain) IBOutlet UIButton *acceptAndSendButton;
@property (nonatomic, retain) IBOutlet UILabel  *infoLabel;
@property (nonatomic, retain) NotificationsViewController *controller;

- (void) initializeViewWithController:(NotificationsViewController *)notiController withInfo:(NSDictionary*)info;

@end
