//
//  UserAnnotation.h
//  NodoApp
//
//  Created by Gustavo Alonso on 27/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserAnnotation : NSObject <MKAnnotation>{
    
    NSString *title;
    NSString *subtitle;
    NSString *note;
    CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, strong) UIColor *pincolor;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
