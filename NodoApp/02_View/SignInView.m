//
//  SignInView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "SignInView.h"
#import "SocialNetwork.h"
#import "AppDelegate.h"

@implementation SignInView
@synthesize bkImageView;
@synthesize emailField;
@synthesize passwordField;
@synthesize indicatorView;
@synthesize rememberButton;
@synthesize landingPage;
@synthesize signinButton;
@synthesize controller;

- (void)initialiseViewWithController:(SignInViewController*)signinController
{
    
    controller = signinController;
    
    kbSize = CGSizeZero;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapEvent:)];
    [bkImageView addGestureRecognizer:tapGesture];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    rememberFlag = [[defaults objectForKey:@"remember"] boolValue];
    if (rememberFlag) {
        [rememberButton setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateNormal];
    } else {
        [rememberButton setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    }
    
    NSString *email = [defaults objectForKey:@"email"];
    NSString *password = [defaults objectForKey:@"password"];

    if (email != nil  && [email length] != 0) {
        startingTime = [NSDate date];
        [self loginUser:email :password];
    } else {
        [landingPage setHidden:YES];
    }
}

- (void)onClickTapEvent:(UITapGestureRecognizer *)gesture
{
    [self endEditing:YES];
}

- (IBAction)onClickRememberButton:(id)sender
{
    rememberFlag = !rememberFlag;
    if (rememberFlag) {
        [rememberButton setImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateNormal];
    } else {
        [rememberButton setImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:rememberFlag] forKey:@"remember"];
    [defaults synchronize];
}

- (IBAction)onClickSingnInButton:(id)sender
{
    if ([emailField.text length] == 0) {
        [self showAlert:@"Please input your email address!"];
    } else if ([passwordField.text length] == 0) {
        [self showAlert:@"Please input your password!"];
    } else {
        [self loginUser:emailField.text :passwordField.text];
    }
}

- (void)loginUser:(NSString *)email :(NSString*)password
{
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork loginUser:[NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicatorView stopAnimating];
            [indicatorView setHidden:YES];
            [landingPage setHidden: YES];
            
            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                int success = [[resultData objectForKey:@"SUCCESS"] intValue];
                
                if (success == 0) {
                    [self showAlert:@"Your Email or Password is incorrect!"];
                } else {
                    
                    DataManager.currentUser = [NSMutableDictionary dictionaryWithDictionary:[resultData objectForKey:@"RESULT"]];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (rememberFlag) {
                        [defaults setObject:[DataManager.currentUser objectForKey:@"email"] forKey:@"email"];
                        [defaults setObject:[DataManager.currentUser objectForKey:@"password"] forKey:@"password"];
                        [defaults synchronize];
                    }
                    [emailField setText:@""];
                    [passwordField setText:@""];
                    [[AppDelegate sharedAppDelegate].oneSignal sendTag:@"userid" value:[DataManager.currentUser objectForKey:@"id"]];
                    if ([[DataManager.currentUser objectForKey:@"verified"] isEqualToString:@"true"]) {
                        [controller performSegueWithIdentifier:@"sidebar" sender:nil];
                    } else {
                        [controller performSegueWithIdentifier:@"verification" sender:nil];
                    }
                }
            }
        });
    }];
}

- (IBAction) onClickForgotPassword:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot password?"
                                          message:@"Please input your email address!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Email";
         [textField setKeyboardType:UIKeyboardTypeEmailAddress];
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Send"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                                   UITextField *login = alertController.textFields.firstObject;
                                   [self forgotPassword:login.text];
                               }];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Canel" style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  [alertController dismissViewControllerAnimated:YES completion:nil];
                              }];
    [alertController addAction:okAction];
    [alertController addAction:defaultAction];
    [controller presentViewController:alertController animated:YES completion:nil];
}

- (void)forgotPassword:(NSString*) email
{
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork forgotPassword:[NSDictionary dictionaryWithObjectsAndKeys: email, @"email", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                
                [indicatorView stopAnimating];
                [indicatorView setHidden:YES];
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                int result = [[resultData objectForKey:@"SUCCESS"] intValue];
                if (result == 1) {
                    [self showAlert:@"Password have been send to your email successfully!"];
                } else {
                    [self showAlert:@"This email does not exists!"];
                }
            }
        });
    }];
}

- (void)showAlert:(NSString*)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sign In" message:text preferredStyle:UIAlertControllerStyleAlert];
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
        int margin = self.frame.size.height -self.frame.origin.y - kbSize.height - (signinButton.frame.origin.y + signinButton.frame.size.height);
        if (margin < 50) {
            [self setFrame:CGRectOffset(self.frame, 0, -(50 - margin))];
        } else {
            if (self.frame.origin.y < 0) {
                [self setFrame:CGRectOffset(self.frame, 0, MIN(- self.frame.origin.y, margin - 50))];
            }
        }
    } completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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

#pragma mark uitextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (kbSize.width != 0 && kbSize.height != 0) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^(void) {
            
            int margin = self.frame.size.height -self.frame.origin.y - kbSize.height - (signinButton.frame.origin.y + signinButton.frame.size.height);
            if (margin < 50) {
                [self setFrame:CGRectOffset(self.frame, 0, -(50 - margin))];
            } else {
                if (self.frame.origin.y < 0) {
                    [self setFrame:CGRectOffset(self.frame, 0, MIN(- self.frame.origin.y, margin - 50))];
                }
            }
        } completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 2) {
        [textField resignFirstResponder];
    } else {
        UITextField *nextField = (UITextField*)[self viewWithTag:textField.tag + 1];
        [nextField becomeFirstResponder];
    }    
    return YES;
}

@end
