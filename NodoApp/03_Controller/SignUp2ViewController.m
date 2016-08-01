//
//  SignUp2ViewController.m
//  NodoApp
//
//  Created by Gustavo Alonso on 10/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "SignUp2ViewController.h"
#import "SignUp2View.h"
#import "AppDelegate.h"

@implementation SignUp2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SignUp2View *signupView = (SignUp2View*)self.view;
    [signupView initialiseViewWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
