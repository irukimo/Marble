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

+ (NSString *)generateUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}


+ (RKSuccessBlock) successBlockWithDebugMessage:(NSString *)message block:(void (^)(void))callbackBlock
{
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        if (callbackBlock) {callbackBlock();}
        MBDebug(@"%@", message);
    };
}

+ (RKFailureBlock) failureBlockWithAlertMessage:(NSString *)message block:(void (^)(void))callbackBlock
{
    return ^(RKObjectRequestOperation *operation, NSError *error){
        if (callbackBlock) {callbackBlock();}
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
}

+ (void)saveToPersistenceStore:(NSManagedObjectContext *)context failureMessage:(NSString *)failureMessage{
    if ([context saveToPersistentStore:nil]) {
        NSLog(@"Successfully saved to persistence store.");
    } else {
        NSLog(@"%@", failureMessage);
    }
    
}

+(NSString *) getNameToDisplay:(NSString *)name{
    if([name rangeOfString:@"("].location == NSNotFound){
        return name;
    }
    NSRange start = [name rangeOfString:@"("];
    NSRange end = [name rangeOfString:@")"];
    return [name substringWithRange:NSMakeRange(start.location + 1, end.location - (start.location + 1))];
}


@end
