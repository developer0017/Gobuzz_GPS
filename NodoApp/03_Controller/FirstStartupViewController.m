//
//  FirstStartupViewController.m
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import "FirstStartupViewController.h"
#import "FirstStartupView.h"
#import "SocialNetwork.h"

@implementation FirstStartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FirstStartupView *paymentView = (FirstStartupView *)self.view;
    [paymentView initializeViewWithController:self];
    [self getProductInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getProductInfo
{
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObjects: @"fares.gobuzz.plan1", @"fares.gobuzz.plan2", @"fares.gobuzz.plan3", nil]];
        request.delegate = self;
        [request start];
    }
}

- (void)buyProduct:(NSString *)productID
{
    boughtProductID = productID;
    for (SKProduct *product in products) {
        if ([product.productIdentifier isEqualToString:productID]) {
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
    }
}

#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    FirstStartupView *paymentView = (FirstStartupView *)self.view;;
    [paymentView.indicatorView setHidden:YES];
    products = response.products;
}

#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                int connects = [[DataManager.currentUser objectForKey:@"connects"] intValue];
                if ([boughtProductID isEqualToString:@"fares.gobuzz.plan1"]) {
                    connects += 10;
                } else if ([boughtProductID isEqualToString:@"fares.gobuzz.plan2"]) {
                    connects += 20;
                } else {
                    connects += 30;
                }
                [DataManager.currentUser setObject:[NSString stringWithFormat:@"%i", connects] forKey:@"connects"];
                
                SocialNetwork *socialNetwork = [[SocialNetwork alloc] init];
                [socialNetwork updateConnects:[NSDictionary dictionaryWithObjectsAndKeys:[DataManager.currentUser objectForKey:@"id"], @"userid", [NSString stringWithFormat:@"%i", connects], @"connects", nil] withCompletion:nil];
                
                [self performSegueWithIdentifier:@"start" sender:nil];
            }   break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
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
