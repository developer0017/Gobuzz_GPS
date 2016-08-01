//
//  LeftSideBarViewController.h
//  CBCTV
//
//  Created by Albert Bluemel on 23/10/15.
//  Copyright © 2015 bluemelservices. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol SideBarSelectDelegate;

@interface LeftSideBarViewController : UIViewController
{
    
}
@property (nonatomic, retain) IBOutlet AsyncImageView  *photoView;
@property (nonatomic, retain) IBOutlet UILabel  *nameLabel;

@property (assign, nonatomic) id<SideBarSelectDelegate> delegate;

- (void)updateUserPhoto;
@end
