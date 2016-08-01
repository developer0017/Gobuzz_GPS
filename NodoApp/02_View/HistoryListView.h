//
//  HistoryListView.h
//  NodoApp
//
//  Created by Gustavo Alonso on 10/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryListViewController.h"

@interface HistoryListView : UIView
{
    NSArray *historyArray;
}
@property (nonatomic, retain) IBOutlet UIImageView  *markImageView;
@property (nonatomic, retain) IBOutlet UIButton     *markLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *markScrlView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) HistoryListViewController *controller;


- (void)initialiseViewWithController:(HistoryListViewController*)historyListViewController;
- (void)showInfos:(NSDictionary *)infos;
@end
