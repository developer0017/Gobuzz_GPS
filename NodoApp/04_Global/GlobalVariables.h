//
//  GlobalVariables.h
//  Motini
//
//  Created by mac on 5/15/15.
//  Copyright (c) 2015 batatakara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject

+ (GlobalVariables*) sharedInstance ;

@property (nonatomic, retain) NSString *verificationCode;
@property (nonatomic, retain) NSMutableDictionary *currentUser;
@property (nonatomic, retain) NSString *historyType;
@property (nonatomic, retain) NSDictionary *historyData;
@property (nonatomic, retain) NSDictionary *historyID;
@property (nonatomic, retain) NSString  *historyGender;
@property (nonatomic, assign) int   badgeNumber;
@property (nonatomic, assign) BOOL  pickerFlag;
@end
