//
//  Profile2ViewController.m
//  NodoApp
//
//  Created by Gustavo Alonso on 11/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "Profile2ViewController.h"
#import "Profile2View.h"

@implementation Profile2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Profile2View *profileView = (Profile2View *)self.view;
    [profileView initialiseViewWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
