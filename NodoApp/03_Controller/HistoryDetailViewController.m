//
//  HistoryDetailViewController.m
//  NodoApp
//
//  Created by Gustavo Alonso on 11/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "HistoryDetailView.h"

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HistoryDetailView *detailView = (HistoryDetailView*)self.view;
    [detailView initialiseViewWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
