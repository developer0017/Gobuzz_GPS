//
//  GlobalVariable.h
//  TCM
//
//  Created by zao928 on 12/27/13.
//  Copyright (c) 2013 com.appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Defines.h"
#import <CommonCrypto/CommonDigest.h>

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@interface GlobalFunctions : NSObject

- (void) setShadow:(UIView*)view ;
- (void) setLightShadow:(UIView*)view ;
- (void) removeShadow:(UIView*)view ;
- (BOOL) isNotNull:(id)text ;
- (void) addblurView:(UIView*)view ;
- (NSString*)makeFirstLetterCapitalize:(NSString*)string ;

- (void)setRoundButton:(UIButton*)button;
- (void)setBorder:(UIView*)view withColor:(UIColor*)color;
- (void)clearBorder:(UIView*)view;

- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
- (UIImage *)imageWithSize:(UIImage *)image withSize:(CGSize)_size ;
- (UIImage *)imageWithColor:(UIColor *)color ;
- (UIImage *)imageByApplyingAlpha:(UIImage*) image withAlpha:(CGFloat) alpha ;

- (float) getExpectedHeight:(UILabel*)label withString:(NSString*)str width:(CGFloat)width ;
- (float) getExpectedWidth:(UILabel*)label withString:(NSString*)str height:(CGFloat)height;
- (float) getExpectedWidthWithTextView:(UITextView*)label withString:(NSString*)str height:(CGFloat)height;

- (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color ;
- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height ;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize withImage:(UIImage*)sourceImage ;
- (UIImage *)getGradientImage:(UIImage*)image fromColor:(UIColor*)fromColor endColor:(UIColor*)endColor withSize:(CGSize)size ;
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize ;
- (BOOL)validateEmail:(NSString *)emailStr ;
- (void)setCircleImage:(UIView*)imgview ;
- (id)loadCustomObjectWithKey:(NSString *)key ;
- (void)saveCustomObject:(id)object key:(NSString *)key ;
- (NSString*)ignoreNull:(NSString*)object ;

- (NSString *)MD5String:(NSString*)sourceString ;

- (NSString*)getRealStringValue:(id)object ;

- (void)addBorderRectangle:(UIView*)view color:(UIColor*)color ;

+ (GlobalFunctions*) sharedInstance ;

@end