//
//  HistoryListViewController.m
//  NodoApp
//
//  Created by Gustavo Alonso on 10/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "HistoryListViewController.h"
#import "HistoryListView.h"

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HistoryListView *historyListView = (HistoryListView*)self.view;
    [historyListView initialiseViewWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    HistoryListView *historyView = (HistoryListView*)self.view;
    [historyView.indicatorView setHidden:NO];
    [historyView.indicatorView startAnimating];

    SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
    [socialNetwork getInfos:[NSDictionary dictionaryWithObjectsAndKeys: [DataManager.currentUser objectForKey:@"id"], @"id", nil] withCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            HistoryListView *historyView = (HistoryListView*)self.view;
            [historyView.indicatorView setHidden:YES];
            [historyView.indicatorView stopAnimating];
            
            if (error) {
                [self showAlert:@"Oops! Please check your connection again."];
            } else {
                NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
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
