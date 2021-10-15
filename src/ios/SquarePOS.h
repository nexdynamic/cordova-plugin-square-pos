#import <Cordova/CDV.h>

@interface SquarePOS : CDVPlugin
    @property   NSString* callbackId;
    - (void)initTransaction:(CDVInvokedUrlCommand*)command;
@end

