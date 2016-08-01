//
//  TermsAndConditionsView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "TermsAndConditionsView.h"
#import "SidebarViewController.h"

@implementation TermsAndConditionsView
@synthesize termsView;
@synthesize controller;

- (void)initialiseViewWithController:(TermsAndConditionsViewController *)termsController
{
    controller = termsController;
    [termsView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (IBAction)onClickMenuButton:(id)sender
{
    if (![[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    } else {
        [[SidebarViewController share] hideMenu];
    }
}

@end
