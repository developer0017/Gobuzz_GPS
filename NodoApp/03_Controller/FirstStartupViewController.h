//
//  FirstStartupViewController.h
//  NodoApp
//
//  Created by Polaris on 22/02/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface FirstStartupViewController : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSString *boughtProductID;
    NSArray *products;
}
- (void)buyProduct:(NSString *)productID;
- (void)getProductInfo;

@end
