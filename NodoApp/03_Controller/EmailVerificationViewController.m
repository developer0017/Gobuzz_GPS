//
//  EmailVerificationViewController.m
//  NodoApp
//
//  Created by Polaris on 26/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "EmailVerificationViewController.h"
#import "EmailVerificationView.h"

@implementation EmailVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    EmailVerificationView *emailVerificationView = (EmailVerificationView *)self.view;
    [emailVerificationView initialiseViewWithController: self];
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
