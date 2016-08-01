//
//  EmailVerificationView.m
//  NodoApp
//
//  Created by Polaris on 26/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "EmailVerificationView.h"
#import "AppDelegate.h"
#import "SocialNetwork.h"

@implementation EmailVerificationView
@synthesize controller;
@synthesize codeField;
@synthesize resendButton;
@synthesize indicatorView;

- (void)initialiseViewWithController:(EmailVerificationViewController*)emailViewController
{
    controller = emailViewController;
    kbSize = CGSizeZero;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapEvent:)];
    [self addGestureRecognizer:tapGesture];
    
    firstSendFlag = YES;
    [self onClickResendButton:nil];
}

#pragma mark keyboad notificaiton
- (void)onClickTapEvent:(UITapGestureRecognizer *)gesture
{
    [self endEditing:YES];
}

- (void)UIKeyboardWillShowNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber *durationValue = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveValue = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:durationValue.doubleValue delay:0.0 options:(animationCurve << 16) animations:^(void) {
        
        kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        int margin = self.frame.size.height -self.frame.origin.y - kbSize.height - (resendButton.frame.origin.y + resendButton.frame.size.height);
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


- (IBAction)onClickBackButton:(id)sender
{
    [controller.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onClickResendButton:(id)sender
{
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    SocialNetwork *socialNetwork = [SocialNetwork alloc];
    [socialNetwork emailVerification:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"email"], @"email", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicatorView setHidden:YES];
            [indicatorView stopAnimating];
            
            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                int status = [[resultData objectForKey:@"SUCCESS"] intValue];
                if (status == 1) {
                    NSDictionary *dic = [resultData objectForKey:@"Results"];
                    DataManager.verificationCode = [dic objectForKey:@"code"];
                    if (firstSendFlag) {
                        [self showAlert:@"Your verification code was sent to your email successfully!"];
                        firstSendFlag = NO;
                    } else {
                        [self showAlert:@"Your verification code was re-sent to your email!"];
                    }
                    
                } else {
                    [self showAlert:@"Oops! Please check your connection again."];
                }
            }
        });
    }];
}

- (IBAction)onClickVerifyButton:(id)sender
{
    
    [self endEditing:YES];
    if (![DataManager.verificationCode isEqualToString:codeField.text]) {
        [self showAlert:@"Oops! You have entered a wrong code."];
    } else {
        
        [indicatorView setHidden:NO];
        [indicatorView startAnimating];
        
        SocialNetwork *socialNetwork = [SocialNetwork alloc];
        [socialNetwork updateEmailVerification:[NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"userid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [indicatorView setHidden:YES];
            [indicatorView stopAnimating];
            
            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                [[AppDelegate sharedAppDelegate].oneSignal sendTag:@"userid" value:[DataManager.currentUser objectForKey:@"id"]];
                [controller performSegueWithIdentifier:@"sidebar_signup" sender:nil];
            }
        }];
    }
}

- (void)showAlert:(NSString*)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alertController addAction:defaultAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
