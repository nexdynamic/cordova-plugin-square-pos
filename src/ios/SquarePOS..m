#import "SquarePOS.h"
#import <Cordova/CDV.h>
@import SquarePointOfSaleSDK;
@implementation SquarePOS;
@synthesize callbackId;

- (void)initTransaction:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSNumber *amountInCents = [options objectForKey:@"amount"];
    float floatAmount = [amountInCents floatValue];
    NSString * currencyCode = [options objectForKey:@"currencyCode"];
    NSString * squareApplicationId = [options objectForKey:@"squareApplicationId"];
    NSString * squareCallbackURL = [options objectForKey:@"squareCallbackURL"];
    NSString * notes = [options objectForKey:@"notes"];
    NSError *error = nil;
    
    SCCMoney *amount = [SCCMoney moneyWithAmountCents:floatAmount*100 currencyCode:currencyCode error:&error];
    
    [SCCAPIRequest setApplicationID:squareApplicationId];
    
    SCCAPIRequest *request = [SCCAPIRequest requestWithCallbackURL:[NSURL URLWithString:squareCallbackURL]
                                                            amount:amount
                                                    userInfoString:nil
                                                             notes:notes
                                                        customerID:nil
                                              supportedTenderTypes:SCCAPIRequestTenderTypeAll
                                                 clearsDefaultFees:TRUE
                                   returnAutomaticallyAfterPayment:TRUE
                                                             error:&error ];
    if (error) {
        return;
    }
    if (![SCCAPIConnection performRequest:request error:&error]) {
        return;
    }
      
}

@end