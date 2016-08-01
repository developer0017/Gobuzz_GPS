//
//  GlobalVariable.m
//  TCM
//
//  Created by zao928 on 12/27/13.
//  Copyright (c) 2013 com.appcoda. All rights reserved.
//

#import "GlobalFunctions.h"

@implementation GlobalFunctions

- (void)addBorderRectangle:(UIView*)view color:(UIColor*)color {

    view.layer.borderWidth = 1.0f ;
    view.layer.borderColor = color.CGColor ;
}

- (NSString*)ignoreNull:(NSString*)object {
    
    if ( object == nil )
        return @"" ;
    else
        return object ;
}

- (void)setBorder:(UIView*)view withColor:(UIColor*)color
{
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 5.0f;
}

- (void)clearBorder:(UIView*)view
{
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0f;
}

- (id)loadCustomObjectWithKey:(NSString *)key {
    
    NSData *encodedObject = [USER_DEFAULTS objectForKey:key] ;
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject] ;
    
    return object ;
}

- (NSString*)makeFirstLetterCapitalize:(NSString*)string {

    NSString *firstCapChar = [[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    
    return cappedString ;
}

- (void)saveCustomObject:(id)object key:(NSString *)key {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object] ;
    
    [USER_DEFAULTS setObject:encodedObject forKey:key] ;
    [USER_DEFAULTS synchronize] ;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


- (void)setCircleImage:(UIView*)imgview {
    
    imgview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
    imgview.layer.masksToBounds = YES ;
    imgview.layer.cornerRadius = imgview.frame.size.width/2 ;
    imgview.layer.rasterizationScale = [UIScreen mainScreen].scale ;
    imgview.layer.shouldRasterize = YES ;
    imgview.clipsToBounds = YES ;
    
}

- (void)setRoundButton:(UIButton*)button {
    
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
    button.layer.masksToBounds = YES ;
    button.layer.cornerRadius = 3 ;
    button.layer.rasterizationScale = [UIScreen mainScreen].scale ;
    button.layer.shouldRasterize = YES ;
    button.clipsToBounds = YES ;
    
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize withImage:(UIImage*)sourceImage {
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageWithSize:(UIImage *)image withSize:(CGSize)_size {
    UIImage *tempImage = nil;
    UIGraphicsBeginImageContext(_size);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = _size.width;
    thumbnailRect.size.height = _size.height;
    
    [image drawInRect:thumbnailRect];
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImage ;
}

- (UIImage*)  imageByApplyingAlpha:(UIImage*) image withAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

- (void) addblurView:(UIView*)view {
    
    // Blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:view.bounds];
    [view addSubview:blurEffectView];
    [view sendSubviewToBack:blurEffectView] ;
    view.alpha = 0.99 ;
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:view.bounds];
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:vibrancyEffectView];
}

- (float) getExpectedHeight:(UILabel*)label withString:(NSString*)str width:(CGFloat)width {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          label.font, NSFontAttributeName,
                                          label.textColor, NSForegroundColorAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: str attributes:attributesDictionary];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];

    
    return rect.size.height ;
}

- (float) getExpectedWidth:(UILabel*)label withString:(NSString*)str height:(CGFloat)height {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          label.font, NSFontAttributeName,
                                          label.textColor, NSForegroundColorAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: str attributes:attributesDictionary];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    return rect.size.width ;
}

- (float) getExpectedWidthWithTextView:(UITextView*)label withString:(NSString*)str height:(CGFloat)height {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.textContainer.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          label.font, NSFontAttributeName,
                                          label.textColor, NSForegroundColorAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: str attributes:attributesDictionary];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    return rect.size.width ;
}

- (void) setShadow:(UIView*)view {
    
    [view.layer setCornerRadius:0.5f];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.2f];
    [view.layer setShadowRadius:0.3f];
    [view.layer setShadowOffset:CGSizeMake(0.0f, 1.5f)];
    
    view.layer.masksToBounds = NO;
    view.layer.borderWidth = 0.5 ;
    [view.layer setBorderColor:[UIColor clearColor].CGColor] ;
    
}

- (void) setLightShadow:(UIView*)view {
    
    [view.layer setCornerRadius:0.3f];
    [view.layer setShadowColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0f].CGColor];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setShadowRadius:0.6f];
    [view.layer setShadowOffset:CGSizeMake(0.0f, 0.3f)];
    
    view.layer.masksToBounds = NO;
    view.layer.borderWidth = 0.8 ;
    [view.layer setBorderColor:[UIColor clearColor].CGColor] ;
    
}

- (void) removeShadow:(UIView*)view {
    [view.layer setShadowColor:[UIColor clearColor].CGColor];
    [view.layer setNeedsDisplay];
    [view.layer displayIfNeeded];
}

- (BOOL) isNotNull:(id)text {
    if ( ((NSNull *)text != [NSNull null]) && text != nil )
        return YES;
    else
        return NO;
}

- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor*)colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    // String should be 6 or 8 characters
    if ([cString length] < 10) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    
    if ([cString length] != 8) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    NSString *aString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)getGradientImage:(UIImage*)image fromColor:(UIColor*)fromColor endColor:(UIColor*)endColor withSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // Create gradient
    
    NSArray *colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, (id)endColor.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);
    
    // Apply gradient
    
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,size.height), 0);
    
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return gradientImage ;
}

- (NSString *)MD5String:(NSString*)sourceString {
    const char *cstr = [sourceString UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (int)strlen(cstr), result);

    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

+(GlobalFunctions *)sharedInstance {
    static GlobalFunctions *myGlobal = nil;
    
    if (myGlobal == nil) {
        myGlobal = [[[self class] alloc] init];
    }
    return myGlobal;
}

- (NSString*)getRealStringValue:(id)object {
    
    if ( [object isKindOfClass:[NSString class]] )
        return object ;
    else
    {
        NSString* string = [NSString stringWithFormat:@"%@", object] ;
        return string ;
    }
}
@end
