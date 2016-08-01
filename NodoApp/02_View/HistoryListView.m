//
//  HistoryListView.m
//  NodoApp
//
//  Created by Gustavo Alonso on 10/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "HistoryListView.h"
#import "SidebarViewController.h"
#import "AsyncImageView.h"
#import "HistoryViewController.h"
#import "HistoryDetailViewController.h"

@implementation HistoryListView
@synthesize markImageView;
@synthesize markLabel;
@synthesize markScrlView;
@synthesize indicatorView;
@synthesize controller;

- (void)initialiseViewWithController:(HistoryListViewController*)historyListViewController
{
    controller = historyListViewController;
    if ([DataManager.historyType isEqualToString:@"Sent"]) {
        [markImageView setImage:[UIImage imageNamed:@"btn_send.png"]];
        [markLabel setTitle:@"Sent" forState:UIControlStateNormal];
    } else {
        [markImageView setImage:[UIImage imageNamed:@"btn_request.png"]];
        [markLabel setTitle:@"Received" forState:UIControlStateNormal];
    }
}

- (IBAction)onClickMenuButton:(id)sender
{
    if (![[SidebarViewController share] isShowMenu]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    } else {
        [[SidebarViewController share] hideMenu];
    }
}

- (IBAction)onClickBackButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HistoryViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
}

-(IBAction)onClickDeleteButton:(id)sender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:@"Are you sure you want to delete your history?" preferredStyle:UIAlertControllerStyleAlert];
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
                                                          [socialNetwork deleteHistory:[NSDictionary dictionaryWithObjectsAndKeys:DataManager.historyType, @"type", [DataManager.currentUser objectForKey:@"id"], @"userid", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  
                                                                  [indicatorView stopAnimating];
                                                                  [indicatorView setHidden:YES];
                                                                  
                                                                  if (error) {
                                                                      [self showAlert:@"Oops! Please check your connection again."];
                                                                  } else {
                                                                      
                                                                      NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                                                                      int success = [[resultData objectForKey:@"SUCCESS"] intValue];
                                                                      
                                                                      if (success == 0) {
                                                                          [self showAlert:@"Oops! Please check your connection again!"];
                                                                      } else {
                                                                          for (UIView *subView in [markScrlView subviews]) {
                                                                              [subView removeFromSuperview];
                                                                          }
                                                                      }
                                                                  }
                                                              });
                                                          }];
                                                      }];
    [alertController addAction:yesAction];
    [alertController addAction:defaultAction];
    [controller presentViewController:alertController animated:YES completion:nil];
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

- (void)showInfos:(NSDictionary *)infos
{
    [indicatorView setHidden:YES];
    
    for (UIView *subView in [markScrlView subviews]) {
        [subView removeFromSuperview];
    }
    
    int offset = 0;
    if ([DataManager.historyType isEqualToString:@"Sent"]) {
        historyArray = [infos objectForKey:@"from"];
    } else {
        historyArray = [infos objectForKey:@"to"];
    }
    
    for (int i = (int)[historyArray count] - 1; i >= 0  ; i-- ) {
    
        NSDictionary *dic = [historyArray objectAtIndex:i];
        
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake( 5, offset + 5, markScrlView.frame.size.width - 10, 34)];
        [button setBackgroundImage:[UIImage imageNamed:@"bk_historyrow.png"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        [button setTitle:[dic objectForKey:@"screenname"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.28 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Quicksand-Bold" size:17.0f]];
        [button setTag:i];
        [button addTarget:self action:@selector(onClickHistory:) forControlEvents:UIControlEventTouchUpInside];
        [markScrlView addSubview:button];
        
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake( 1, offset + 1, 48, 44)];
        if ([[dic objectForKey:@"gender"] isEqualToString:@"Male"]) {
            [imageView setImage:[UIImage imageNamed:@"btn_man_off.png"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"btn_girl_off.png"]];
        }
        NSString *path = [NSString stringWithFormat:@"http://gobuzz.buzz/gobuzz/%@", [dic objectForKey:@"image"]];
        [imageView setImageURL:[NSURL URLWithString:path]];
        [markScrlView addSubview:imageView];
        [self createMaskForImage:imageView];
        
        UIImageView *borderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset, 50, 46)];
        [borderImgView setImage:[UIImage imageNamed:@"border_profile.png"]];
        [markScrlView addSubview:borderImgView];
        offset += 55;
    }
    [markScrlView setContentSize:CGSizeMake(markScrlView.frame.size.width, offset)];
}

- (void)onClickHistory:(UIButton*)sender
{
    DataManager.historyID = nil;
    DataManager.historyData = [historyArray objectAtIndex:sender.tag];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HistoryDetailViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryDetailViewController"];
    [[SidebarViewController share] leftSideBarSelectWithController:mainViewController];
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
