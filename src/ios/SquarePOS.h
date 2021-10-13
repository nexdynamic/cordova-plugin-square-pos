#import <Cordova/CDV.h>
@import SquarePointOfSaleSDK;

@interface SquarePOS : CDVPlugin
    @property   NSString* callbackId;
    @property (nonatomic, assign) SCCAPIRequestTenderTypes supportedTenderTypes;
    - (void)initTransaction:(CDVInvokedUrlCommand*)command;
@end