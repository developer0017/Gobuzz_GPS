//
//  SignUpView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "SignUpView.h"
#import "AppDelegate.h"
#import "SocialNetwork.h"

@implementation SignUpView
@synthesize userImageView;
@synthesize usernameField;
@synthesize genderField;
@synthesize screennameField;
@synthesize emailField;
@synthesize emailIndicatorView;
@synthesize passwordField;
@synthesize mobileFiled;
@synthesize phoneIndicatorView;
@synthesize sharenumberField;
@synthesize nextButton;
@synthesize controller;

- (void)initialiseViewWithController:(SignUpViewController*)signupController
{
    controller = signupController;
    
    [emailIndicatorView setHidden:YES];
    [phoneIndicatorView setHidden:YES];
    
    [userImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
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

- (IBAction)onClickSignup2Button:(id)sender
{
    [self endEditing:YES];
    if (userPhoto == nil) {
        [self showAlert:@"Please select the photo!"];
    } else if ([usernameField.text length] == 0) {
        [self showAlert:@"Please input your name!"];
    } else if ([genderField.text length] == 0) {
        [self showAlert:@"Please select your Gender!"];
    } else if ([screennameField.text length] == 0) {
        [self showAlert:@"Please input the screen name!"];
    } else if ([emailField.text length] == 0) {
        [self showAlert:@"Please input the email address!"];
    } else if ([passwordField.text length] == 0) {
        [self showAlert:@"Please input the password!"];
    } else if ([mobileFiled.text length] == 0) {
        [self showAlert:@"Please input the mobile number!"];
    } else if ([sharenumberField.text length] == 0) {
        [self showAlert:@"Please input the number to share!"];
    } else if ([sharenumberField.text length] < 6) {
        [self showAlert:@"You mobile number for sharing should be more than 6 digits!"];
    } else {
        
        if (emailValidFlag == NO) {
            if (![self NSStringIsValidEmail:emailField.text]) {
                [self showAlert:@"Enter a valid email address!"];
            } else {
                [self showAlert:@"Email already exists!"];
            }
        } else if (mobileValidFlag == NO) {
            if ([mobileFiled.text length] < 6) {
                [self showAlert:@"Your mobile number should be more than 6 digits!"];
            } else {
                [self showAlert:@"Mobile number already exists!"];
            }
        } else {
            DataManager.currentUser = [NSMutableDictionary dictionaryWithObjectsAndKeys: userPhoto, @"userimage", usernameField.text, @"username", genderField.text, @"gender", screennameField.text, @"screenname", emailField.text, @"email", passwordField.text, @"password", mobileFiled.text, @"mobilenumber", sharenumberField.text, @"sharenumber", nil];
            [controller performSegueWithIdentifier:@"signup2" sender:nil];
        }
    }
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

- (IBAction)onClickSelectPhotoButton:(id)sender
{
    
    [self endEditing:YES];
    
    id pickerDelegate = self;
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Photo"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction
                         actionWithTitle:@"Camera"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                             if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
                             {
                                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Camera" message:@"Can't use this functionality" preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * action) {
                                                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                                       }];
                                 
                                 [alertController addAction:defaultAction];
                                 [controller presentViewController:alertController animated:YES completion:nil];
                                 return;
                             }
                             
                             UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                             [picker setSourceType: UIImagePickerControllerSourceTypeCamera];
                             [picker setDelegate: pickerDelegate];
                             picker.allowsEditing = YES;
                             [controller presentViewController:picker animated: YES completion:nil];
                             
                         }];
    
    UIAlertAction* galleryAction = [UIAlertAction
                             actionWithTitle:@"Gallery"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                                 UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                 [picker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
                                 [picker setDelegate: pickerDelegate];
                                 picker.allowsEditing = YES;
                                 [controller presentViewController:picker animated: YES completion:nil];
                             }];
    
    UIAlertAction* cancelAction = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];                                 
                             }];
    
    [view addAction:cameraAction];
    [view addAction:galleryAction];
    [view addAction:cancelAction];
    [controller presentViewController:view animated:YES completion:nil];
}

- (void)showEmailValidatingResults:(BOOL) flag
{
    emailValidFlag = flag;
    [emailIndicatorView setHidden:YES];
    [emailIndicatorView stopAnimating];
    if (!flag) {
        [emailField setTextColor:[UIColor redColor]];
    } else {
        [emailField setTextColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.28 alpha:1.0]];
    }
}

- (void)showMobileValidatingResults:(BOOL) flag
{
    mobileValidFlag = flag;
    [phoneIndicatorView setHidden:YES];
    [emailIndicatorView stopAnimating];
    if (!flag) {
        [mobileFiled setTextColor:[UIColor redColor]];
    } else {
        [mobileFiled setTextColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.28 alpha:1.0]];
    }
}

#pragma mark imagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    userPhoto = image;
    [userImageView setImage:userPhoto];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        int margin = self.frame.size.height -self.frame.origin.y - kbSize.height - (nextButton.frame.origin.y + nextButton.frame.size.height);
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Gender"
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* maleAction = [UIAlertAction
                                     actionWithTitle:@"Male"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                         [genderField setText:@"Male"];
                                         
                                         UITextField *nextField = (UITextField*)[self viewWithTag:3];
                                         [nextField becomeFirstResponder];
                                     }];
        
        UIAlertAction* femaleAction = [UIAlertAction
                                       actionWithTitle:@"Female"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [view dismissViewControllerAnimated:YES completion:nil];
                                           
                                           [genderField setText:@"Female"];
                                           
                                           UITextField *nextField = (UITextField*)[self viewWithTag:3];
                                           [nextField becomeFirstResponder];
                                       }];
        
        UIAlertAction* cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [view dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [view addAction:maleAction];
        [view addAction:femaleAction];
        [view addAction:cancelAction];
        [controller presentViewController:view animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 4) {
        emailValidFlag = NO;
    }
    
    if (textField.tag == 6) {
        mobileValidFlag = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 7) {
        [textField resignFirstResponder];
    } else if (textField.tag == 1 || textField.tag == 2) {
        [textField resignFirstResponder];

        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Gender"
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* maleAction = [UIAlertAction
                                       actionWithTitle:@"Male"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Do some thing here
                                           [view dismissViewControllerAnimated:YES completion:nil];
                                           
                                           [genderField setText:@"Male"];
                                           
                                           UITextField *nextField = (UITextField*)[self viewWithTag:3];
                                           [nextField becomeFirstResponder];
                                       }];
        
        UIAlertAction* femaleAction = [UIAlertAction
                                        actionWithTitle:@"Female"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                            [genderField setText:@"Female"];
                                            
                                            UITextField *nextField = (UITextField*)[self viewWithTag:3];
                                            [nextField becomeFirstResponder];
                                        }];
        
        [view addAction:maleAction];
        [view addAction:femaleAction];
        [controller presentViewController:view animated:YES completion:nil];
    } else {
        UITextField *nextField = (UITextField*)[self viewWithTag:textField.tag + 1];
        [nextField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 4) {
        if ([emailField.text length] != 0 && [self NSStringIsValidEmail:emailField.text]) {
            [emailIndicatorView setHidden:NO];
            [emailIndicatorView startAnimating];
            [self checkEmailAddress:emailField.text];
        }
    } else if (textField.tag == 6) {
        if ([mobileFiled.text length] >= 6) {
            [phoneIndicatorView setHidden:NO];
            [phoneIndicatorView startAnimating];
            [self checkMobile:mobileFiled.text];
        }
    }
}

- (void)checkEmailAddress:(NSString*)email
{
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork checkEmail:[NSDictionary dictionaryWithObjectsAndKeys: email, @"email", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showEmailValidatingResults:NO];
            } else {
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                if ([msg isEqualToString:@"Not Exist!"]) {
                    [self showEmailValidatingResults:YES];
                } else {
                    [self showEmailValidatingResults:NO];
                }
            }
        });        
    }];
}

- (void)checkMobile:(NSString *)mobile
{
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork checkMobile:[NSDictionary dictionaryWithObjectsAndKeys: mobile, @"mobilenumber", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showMobileValidatingResults:NO];
            } else {
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                if ([msg isEqualToString:@"Not Exist!"]) {
                    [self showMobileValidatingResults:YES];
                } else {
                    [self showMobileValidatingResults:NO];
                }
            }
        });
    }];
}

#pragma mark checkEmailValidate
- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
