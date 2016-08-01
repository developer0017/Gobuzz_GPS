//
//  GlobalVariables.m
//  Motini
//
//  Created by mac on 5/15/15.
//  Copyright (c) 2015 batatakara. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables
@synthesize verificationCode;
@synthesize currentUser;
@synthesize historyType;
@synthesize historyData;
@synthesize historyID;
@synthesize historyGender;
@synthesize badgeNumber;
@synthesize pickerFlag;

+ (GlobalVariables *)sharedInstance {
    static GlobalVariables *myGlobal = nil;
    
    if (myGlobal == nil) {
        myGlobal = [[[self class] alloc] init];
    }
    return myGlobal;
}

@end
