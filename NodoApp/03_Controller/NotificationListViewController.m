//
//  NotificationListViewController.m
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "NotificationListViewController.h"
#import "NotificationListView.h"

@implementation NotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NotificationListView *historyView = (NotificationListView*)self.view;
    [historyView initialiseViewWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NotificationListView *historyView = (NotificationListView*)self.view;
    [historyView.indicatorView setHidden:NO];
    [historyView.indicatorView startAnimating];
    
    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork getNotifications:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"], @"id", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NotificationListView *historyView = (NotificationListView*)self.view;
            [historyView.indicatorView setHidden:YES];
            [historyView.indicatorView stopAnimating];
            
            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                NSArray *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
                [historyView showInfos:resultData];
            }
        });
    }];
}

- (void)showAlert:(NSString*)text
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"GoBuzz" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
