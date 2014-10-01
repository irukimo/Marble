//
//  Utilities.m
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>

@implementation Utility
+ (void) generateAlertWithMessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: message
                                                    message: @""
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
}

+ (RKSuccessBlock) successBlockWithDebugMessage:(NSString *)message block:(void (^)(void))callbackBlock
{
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        if (callbackBlock) {callbackBlock();}
        MBDebug(@"%@", message);
    };
}


@end
