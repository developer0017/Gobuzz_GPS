//
//  PaymentViewController.h
//  NodoApp
//
//  Created by Gustavo Alonso on 25/01/16.
//  Copyright © 2016 WanCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PaymentViewController : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSString *boughtProductID;
    NSArray *products;
}
- (void)buyProduct:(NSString *)productID;
- (void)getProductInfo;
@end
