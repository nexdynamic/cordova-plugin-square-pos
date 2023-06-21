#import "SquarePOS.h"
#import <Cordova/CDV.h>
#import <SquarePointOfSaleSDK/SCCAPIRequest.h>
#import <SquarePointOfSaleSDK/SCCMoney.h>
#import <SquarePointOfSaleSDK/SCCAPIConnection.h>
#import <SquarePointOfSaleSDK/SCCAPIResponse.h>

@implementation SquarePOS;
@synthesize callbackId;

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLaunchedWithUrl:) name:CDVPluginHandleOpenURLNotification object:nil];
}

- (void)applicationLaunchedWithUrl:(NSNotification*)notification
{
    NSURL* url = [notification object];

    if (![SCCAPIResponse isSquareResponse:url]) {
      return;
    }
    NSError *decodeError = nil;
    SCCAPIResponse *const response = [SCCAPIResponse responseWithResponseURL:url
                                                                         error:&decodeError];

    if (response.isSuccessResponse) {
      // Print checkout object
      NSLog(@"Transaction successful: %@", response);
        
        
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [result setObject:[NSString stringWithString: response.transactionID] forKey:@"serverTransactionId"];
        [result setObject:[NSString stringWithString: response.clientTransactionID] forKey:@"clientTransactionId"];
        [result setObject:[NSString stringWithString: response.userInfoString ] forKey:@"state"];
        
        CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        return;

    } else if (decodeError) {
      // Print decode error
        NSLog(@"Request failed: %@", decodeError);
        [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"Decode Error"];
    } else {
      // Print the error code
      NSLog(@"Request failed: %@", response.error);
        if (response.error) {
            [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: response.error];
        }
         
    };
    
}

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
    NSString * customerId = [options objectForKey:@"customerId"];
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
        customerID:customerId
        supportedTenderTypes:SCCAPIRequestTenderTypeAll
        clearsDefaultFees:TRUE
        returnsAutomaticallyAfterPayment:TRUE
        disablesKeyedInCardEntry:FALSE
        skipsReceipt:FALSE
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
