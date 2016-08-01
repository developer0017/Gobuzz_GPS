//
//  SignUp2View.m
//  NodoApp
//
//  Created by Gustavo Alonso on 10/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "SignUp2View.h"
#import "AppDelegate.h"
#import "SocialNetwork.h"

@implementation SignUp2View
@synthesize titleLabel;
@synthesize userImageView;
@synthesize facebookIDField;
@synthesize twitterIDField;
@synthesize instagramIDField;
@synthesize snapchatIDField;
@synthesize signupButton;
@synthesize indicatorView;
@synthesize controller;

- (void)initialiseViewWithController:(SignUp2ViewController*)signupController
{
    
    controller = signupController;
    
    locManager = [INTULocationManager sharedInstance];
    [locManager subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyHouse block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            currentLoc = currentLocation;
        } else if (status == INTULocationStatusTimedOut) {
            currentLoc = currentLocation;
        }
    }];
    
    [titleLabel setText:[DataManager.currentUser objectForKey:@"username"]];
    [userImageView setImage:[DataManager.currentUser objectForKey:@"userimage"]];
    [self createMaskForImage:userImageView];
    
    kbSize = CGSizeZero;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapEvent:)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)onClickTapEvent:(UITapGestureRecognizer *)gesture
{
    [self endEditing:YES];
}

- (IBAction)onClickBackButton:(id)sender
{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSignupButton:(id)sender
{    
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    [DataManager.currentUser setObject:facebookIDField.text forKey:@"facebookid"];
    [DataManager.currentUser setObject:twitterIDField.text forKey:@"twitterid"];
    [DataManager.currentUser setObject:instagramIDField.text forKey:@"instagramid"];
    [DataManager.currentUser setObject:snapchatIDField.text forKey:@"snapchatid"];
    
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:DataManager.currentUser];
    
    UIImage *image = (UIImage *)[params objectForKey:@"userimage"];
    [params removeObjectForKey:@"userimage"];
    [params setObject:[NSString stringWithFormat:@"%.15f", currentLoc.coordinate.latitude] forKey:@"lat"];
    [params setObject:[NSString stringWithFormat:@"%.15f", currentLoc.coordinate.longitude] forKey:@"lng"];
    [params setObject:[NSString stringWithFormat:[NSString stringWithFormat:@"%f", interval], currentLoc.coordinate.longitude] forKey:@"timestamp"];
    
    [self registerUser:params withImage:[self imageWithImage:image scaledToSize:CGSizeMake(150, 150)]];    
}

- (void)registerUser :(NSDictionary*)params withImage:(UIImage *)image
{
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork regisreUser:params withImage:image withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicatorView setHidden:YES];
            [indicatorView stopAnimating];
            if (error) {
                [self showAlert:@"Signup Oops! Please check your connection again."];
            } else {
                
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                
                if ([msg isEqualToString:@"Registeration Success!"]) {
                    
                    NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                    int status = [[resultData objectForKey:@"SUCCESS"] intValue];
                    if (status == 1) {
                        DataManager.currentUser = [NSMutableDictionary dictionaryWithDictionary:[resultData objectForKey:@"RESULT"]];
                        [controller performSegueWithIdentifier:@"emailverification" sender:nil];
                    } else {
                        [self showAlert:@"Oops! Please check your connection again."];
                    }
                } else {
                    [self showAlert:msg];
                }
            }
        });
    }];
}

- (void)showAlert:(NSString*)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sign Up" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alertController addAction:defaultAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

#pragma mark keyboad notificaiton
- (void)UIKeyboardWillShowNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber *durationValue = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveValue = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:durationValue.doubleValue delay:0.0 options:(animationCurve << 16) animations:^(void) {
        
        kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        int margin = self.frame.size.height -self.frame.origin.y - kbSize.height - (signupButton.frame.origin.y + signupButton.frame.size.height);
        if (margin < 5) {
            [self setFrame:CGRectOffset(self.frame, 0, -(5 - margin))];
        } else {
            if (self.frame.origin.y < 0) {
                [self setFrame:CGRectOffset(self.frame, 0, MIN(- self.frame.origin.y, margin - 5))];
            }
        }
    } completion:nil];
}

- (void)UIKeyboardWillHideNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber *durationValue = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveValue = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:durationValue.doubleValue delay:0.0 options:(animationCurve << 16) animations:^(void) {
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:nil];
}


#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == facebookIDField) {
        [textField resignFirstResponder];
    } else if (textField == twitterIDField) {
        [instagramIDField becomeFirstResponder];
    } else if (textField == instagramIDField) {
        [snapchatIDField becomeFirstResponder];
    } else {
        [facebookIDField becomeFirstResponder];
    }
    return YES;
}

-(void) createMaskForImage:(UIImageView *)image
{
    CALayer *mask = [CALayer layer];
    UIImage *maskImage = [UIImage imageNamed:@"icon_mask.png"];
    maskImage = [self imageWithImage:maskImage scaledToSize:image.frame.size];
    mask.contents = (id)[maskImage CGImage];
    mask.frame = CGRectMake(0, 0,maskImage.size.width, maskImage.size.height);
    image.layer.mask = mask;
    image.layer.masksToBounds = YES;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
