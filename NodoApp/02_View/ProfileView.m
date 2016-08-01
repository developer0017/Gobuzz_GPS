//
//  ProfileView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "ProfileView.h"
#import "SidebarViewController.h"
#import "Profile2ViewController.h"
#import "SocialNetwork.h"
#import "AppDelegate.h"

@implementation ProfileView
@synthesize userImageView;
@synthesize usernameField;
@synthesize genderField;
@synthesize screennameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize mobileFiled;
@synthesize sharenumberField;
@synthesize nextButton;
@synthesize indicatorView;
@synthesize emailIndicatorView;
@synthesize phoneIndicatorView;
@synthesize controller;

- (void)initialiseViewWithController:(ProfileViewController *)profileViewController
{
    
    controller = profileViewController;
    
    kbSize = CGSizeZero;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapEvent:)];
    [self addGestureRecognizer:tapGesture];
    
    editedFlag = NO;
    userData = [NSDictionary dictionaryWithDictionary:DataManager.currentUser];
    
    usernameField.text = [userData objectForKey:@"username"];
    genderField.text = [userData objectForKey:@"gender"];
    screennameField.text = [userData objectForKey:@"screenname"];
    emailField.text = [userData objectForKey:@"email"];
    passwordField.text = [userData objectForKey:@"password"];
    mobileFiled.text = [userData objectForKey:@"mobilenumber"];
    sharenumberField.text = [userData objectForKey:@"sharenumber"];
    [indicatorView setHidden:YES];
    
    if ([[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
        [userImageView setImage:[UIImage imageNamed:@"icon_male_blue.png"]];
    } else {
        [userImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [userData objectForKey:@"image"]];
    [userImageView setImageURL:[NSURL URLWithString:path]];
    [self createMaskForImage:userImageView];
    
    emailValidFlag = YES;
    mobileValidFlag = YES;
    
    [emailIndicatorView setHidden:YES];
    [phoneIndicatorView setHidden:YES];
}

- (void)onClickTapEvent:(UITapGestureRecognizer *)gesture
{
    [self endEditing:YES];
    if ([[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] hideMenu];
    }
}

- (IBAction)onClickDeleteButton:(id)sender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:@"Are you sure you want to delete your profile?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                              [indicatorView setHidden:NO];
                                                              [indicatorView startAnimating];
                                                              SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
                                                              [socialNetwork deleteUser:[NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"userid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                  
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      
                                                                      [indicatorView setHidden:YES];
                                                                      [indicatorView startAnimating];
                                                                      
                                                                      if (error) {
                                                                          [self showAlert:@"Deleting Oops! Please check your connection again!"];
                                                                      } else {
                                                                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                          [defaults setObject:@"" forKey:@"email"];
                                                                          [defaults setObject:@"" forKey:@"password"];
                                                                          [defaults synchronize];
                                                                          [controller.navigationController popToRootViewControllerAnimated:YES];
                                                                      }
                                                                  });
                                                              }];
                                                          }];
    [alertController addAction:yesAction];
    [alertController addAction:defaultAction];
    [controller presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)onClickMenuButton:(id)sender
{
    [self endEditing:YES];
    if (![[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    } else {
        [[SidebarViewController share] hideMenu];
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

- (IBAction)onClickNextButton:(id)sender
{
    [self endEditing:YES];
    
    if ([usernameField.text length] == 0) {
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
        [self showAlert:@"Your mobile number for sharing should be more than 6 digits!"];
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
            
            if (editedFlag) {
                
                NSDate *date = [NSDate date];
                NSTimeInterval interval = [date timeIntervalSince1970];
                
                AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
                currentLoc = [appDelegate getCurrentlocation];
                
                NSMutableDictionary *params;
                params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"], @"userid",usernameField.text, @"username", genderField.text, @"gender", screennameField.text, @"screenname", emailField.text, @"email", passwordField.text, @"password", mobileFiled.text, @"mobilenumber", sharenumberField.text, @"sharenumber", [DataManager.currentUser objectForKey:@"facebookid"], @"facebookid", [DataManager.currentUser objectForKey:@"twitterid"], @"twitterid", [DataManager.currentUser objectForKey:@"instagramid"], @"instagramid", [DataManager.currentUser objectForKey:@"snapchatid"], @"snapchatid", [NSString stringWithFormat:@"%.15f", currentLoc.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%.15f", currentLoc.coordinate.longitude], @"lng", [NSString stringWithFormat:@"%f", interval], @"timestamp", [DataManager.currentUser objectForKey:@"connects"], @"connects", nil];
                
                if (!userPhoto) {
                    NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [DataManager.currentUser objectForKey:@"image"]];
                    userPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
                }
                
                [self updateUser:params withImage:[self imageWithImage:userPhoto scaledToSize:CGSizeMake(150, 150)]];
                
            } else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                Profile2ViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile2ViewController"];
                [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
            }
        }
    }
}

- (void)updateUser :(NSDictionary*)params withImage:(UIImage *)image
{
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork updateUserInfo:params withImage:image withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicatorView setHidden:YES];
            [indicatorView stopAnimating];
            
            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                NSString *msg = [resultData objectForKey:@"MSG"];
                if ([msg isEqualToString:@"Update Success!"]) {
                    
                    DataManager.currentUser = [NSMutableDictionary dictionaryWithDictionary:[resultData objectForKey:@"RESULT"]];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    BOOL rememberFlag = [[defaults objectForKey:@"remember"] boolValue];
                    if (rememberFlag) {
                        [defaults setObject:[DataManager.currentUser objectForKey:@"email"] forKey:@"email"];
                        [defaults setObject:[DataManager.currentUser objectForKey:@"password"] forKey:@"password"];
                        [defaults synchronize];
                    }
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    Profile2ViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile2ViewController"];
                    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
                } else {
                    [self showAlert:msg];
                }
            }
        });
    }];
}

#pragma mark imagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    editedFlag = YES;
    userPhoto = image;
    [userImageView setImage:userPhoto];
    DataManager.pickerFlag = YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    DataManager.pickerFlag = YES;
}

#pragma mark keyboad notificaiton
- (void)UIKeyboardWillShowNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber *durationValue = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveValue = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:durationValue.doubleValue delay:0.0 options:(animationCurve << 16) animations:^(void) {
        SidebarViewController *sidebarController = [SidebarViewController share];
        
        kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        int margin = sidebarController.view.frame.size.height -sidebarController.view.frame.origin.y - kbSize.height - (nextButton.frame.origin.y + nextButton.frame.size.height);
        if (margin < 5) {
            [sidebarController.view setFrame:CGRectOffset(sidebarController.view.frame, 0, -(5 - margin))];
        } else {
            if (sidebarController.view.frame.origin.y < 0) {
                [sidebarController.view setFrame:CGRectOffset(sidebarController.view.frame, 0, MIN( - sidebarController.view.frame.origin.y, margin - 5))];
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
        
        SidebarViewController *sidebarController = [SidebarViewController share];
        [sidebarController.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
                                         if (![[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Male"]) {
                                             editedFlag = YES;
                                         }
                                         
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
                                           if (![[DataManager.currentUser objectForKey:@"gender"] isEqualToString:@"Female"]) {
                                               editedFlag = YES;
                                           }
                                           UITextField *nextField = (UITextField*)[self viewWithTag:3];
                                           [nextField becomeFirstResponder];
                                       }];
        
        UIAlertAction* cancelAction = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    editedFlag = YES;
    if (emailField == textField) {
        emailValidFlag = NO;
    } else if (mobileFiled == textField) {
        mobileValidFlag = NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == usernameField && [usernameField.text isEqualToString:[DataManager.currentUser objectForKey:@"username"]]) {
        editedFlag = NO;
    } else if (textField == genderField && [genderField.text isEqualToString:[DataManager.currentUser objectForKey:@"gender"]]) {
        editedFlag = NO;
    } else if (textField == screennameField && [screennameField.text isEqualToString:[DataManager.currentUser objectForKey:@"screenname"]]) {
        editedFlag = NO;
    } else if (textField == emailField && [emailField.text isEqualToString:[DataManager.currentUser objectForKey:@"email"]]) {
        emailValidFlag = YES;
        editedFlag = NO;
    } else if (textField == passwordField && [passwordField.text isEqualToString:[DataManager.currentUser objectForKey:@"password"]]) {
        editedFlag = NO;
    } else if (textField == mobileFiled && [mobileFiled.text isEqualToString:[DataManager.currentUser objectForKey:@"mobilenumber"]]) {
        mobileValidFlag = YES;
        editedFlag = NO;
    } else if (textField == sharenumberField && [sharenumberField.text isEqualToString:[DataManager.currentUser objectForKey:@"sharenumber"]]) {
        editedFlag = NO;
    } else if (textField == emailField && ![emailField.text isEqualToString:[DataManager.currentUser objectForKey:@"email"]]) {
        if ([self NSStringIsValidEmail:emailField.text]) {
            [self checkEmailAddress:emailField.text];
        }
    } else if (textField == mobileFiled && ![mobileFiled.text isEqualToString:[DataManager.currentUser objectForKey:@"mobilenumber"]]) {
        if ([mobileFiled.text length] >= 6) {
            [self checkMobile:mobileFiled.text];
        }
    }
}

- (void)checkEmailAddress:(NSString*)email
{
    [emailIndicatorView setHidden:NO];
    [emailIndicatorView startAnimating];
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork checkEmail:[NSDictionary dictionaryWithObjectsAndKeys: email, @"email", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [emailIndicatorView setHidden:YES];
            [emailIndicatorView stopAnimating];
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
    [phoneIndicatorView setHidden:NO];
    [phoneIndicatorView startAnimating];
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork checkMobile:[NSDictionary dictionaryWithObjectsAndKeys: mobile, @"mobilenumber", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [phoneIndicatorView setHidden:YES];
            [phoneIndicatorView stopAnimating];
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

- (void)showEmailValidatingResults:(BOOL) flag
{
    emailValidFlag = flag;
    if (!flag) {
        [emailField setTextColor:[UIColor redColor]];
    } else {
        [emailField setTextColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.28 alpha:1.0]];
    }
}

- (void)showMobileValidatingResults:(BOOL) flag
{
    mobileValidFlag = flag;
    if (!flag) {
        [mobileFiled setTextColor:[UIColor redColor]];
    } else {
        [mobileFiled setTextColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.28 alpha:1.0]];
    }
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

@end
