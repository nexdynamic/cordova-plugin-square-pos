#import "SquarePOS.h"
#import <Cordova/CDV.h>
#import <SquarePointOfSaleSDK/SCCAPIRequest.h>
#import <SquarePointOfSaleSDK/SCCMoney.h>
#import <SquarePointOfSaleSDK/SCCAPIConnection.h>

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
    NSString * state = [options objectForKey:@"state"];
    NSString * notes = [options objectForKey:@"notes"];
    NSError *error = nil;
    
    SCCMoney *amount = [SCCMoney moneyWithAmountCents:floatAmount*100 currencyCode:currencyCode error:&error];
    if (error) {
        NSLog(@"Failed to create SCCMoney with error: %@", error);
        return;
    }
    

    [SCCAPIRequest setApplicationID:squareApplicationId];
    
    
    SCCAPIRequest *request = [SCCAPIRequest requestWithCallbackURL:[NSURL URLWithString:squareCallbackURL]
        amount:amount
        userInfoString:state
        locationID:nil
        notes:notes
        customerID:nil
        supportedTenderTypes:SCCAPIRequestTenderTypeCard
        clearsDefaultFees:TRUE
        returnsAutomaticallyAfterPayment:TRUE
        disablesKeyedInCardEntry:FALSE
        skipsReceipt:TRUE
        error:&error];
    
    if (error) {
        NSLog(@"Failed to create SCCAPIRequest with error: %@", error);
        return;
    }

    if (![SCCAPIConnection performRequest:request error:&error]) {
        NSLog(@"Failed to perform SCCAPIConnection request: %@", error);
        return;
    }
  
}

@end
