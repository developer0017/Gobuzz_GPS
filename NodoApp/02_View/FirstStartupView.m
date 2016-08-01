//
//  FirstStartupView.m
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "FirstStartupView.h"
#import "SidebarViewController.h"

@implementation FirstStartupView
@synthesize indicatorView;
@synthesize controller;

- (void)initializeViewWithController:(FirstStartupViewController*)firstViewController
{
    selectedID = @"fares.gobuzz.plan1";
    controller = firstViewController;
}

- (IBAction)onClickPlanButton:(UIButton*)sender
{
    NSArray *productIDArray = [NSArray arrayWithObjects: @"fares.gobuzz.plan1", @"fares.gobuzz.plan2", @"fares.gobuzz.plan3", nil];
    for (int i = 1; i < 4; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        if (sender.tag == i) {
            selectedID = [productIDArray objectAtIndex:i - 1];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_plan_on.png"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"btn_plan_off.png"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)onClickSubscribeButton:(id)sender
{
    [controller buyProduct:selectedID];
}

- (IBAction)onClickStartButton:(id)sender
{
    [controller performSegueWithIdentifier:@"start" sender:nil];
}

@end
