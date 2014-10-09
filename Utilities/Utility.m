//
//  Utilities.m
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>

#define YEAR_SECOND 31556926
#define MONTH_SECOND 2629743
#define WEEK_SECOND 604800
#define DAY_SECOND 86400
#define HOUR_SECOND 3600
#define MIN_SECOND 60


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


+ (NSString *)getDateToShow:(NSDate *)date inWhole:(BOOL) inWhole;{
    if (inWhole) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger month = [components month];
        NSInteger year = [components year];
        NSInteger day = [components day];
        NSString *monthString = [Utility getMonthName:month];
        NSString *yearString = [NSString stringWithFormat: @"%d", (int)year];
        NSString *dayString = [NSString stringWithFormat:@"%d", (int)day];
        return [[[[monthString stringByAppendingString:@" "] stringByAppendingString:dayString ] stringByAppendingString:@", "] stringByAppendingString:yearString];
    }
    NSTimeInterval timedifference = -date.timeIntervalSinceNow;
    if(timedifference < 60){
        return @"now";
    }
    int yearCnt = floor(timedifference/YEAR_SECOND);
    if(yearCnt > 0){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger month = [components month];
        NSInteger year = [components year];
        NSInteger day = [components day];
        NSString *monthString = [Utility getMonthName:month];
        NSString *yearString = [NSString stringWithFormat: @"%d", (int)year];
        NSString *dayString = [NSString stringWithFormat:@"%d", (int)day];
        return [[[[monthString stringByAppendingString:@" "] stringByAppendingString:dayString ] stringByAppendingString:@", "] stringByAppendingString:yearString];
        
    }
    int monthCnt = floor(timedifference/MONTH_SECOND);
    if(monthCnt > 0){
        NSString *monthString = [NSString stringWithFormat: @"%d", monthCnt];
        return [monthString stringByAppendingString:@"mo"];
    }
    int weekCnt = floor(timedifference/WEEK_SECOND);
    if(weekCnt > 0){
        NSString *weekString = [NSString stringWithFormat: @"%d", weekCnt];
        return [weekString stringByAppendingString:@"w"];
    }
    int dayCnt = floor(timedifference/DAY_SECOND);
    if(dayCnt > 0){
        NSString *dayString = [NSString stringWithFormat: @"%d", dayCnt];
        return [dayString stringByAppendingString:@"d"];
    }
    int hourCnt = floor(timedifference/HOUR_SECOND);
    if(hourCnt > 0){
        NSString *hourString = [NSString stringWithFormat: @"%d", hourCnt];
        return [hourString stringByAppendingString:@"h"];
    }
    int minCnt = floor(timedifference/MIN_SECOND);
    if(minCnt > 0){
        NSString *minString = [NSString stringWithFormat: @"%d", minCnt];
        return [minString stringByAppendingString:@"m"];
    }
    
    NSString *secString = [NSString stringWithFormat: @"%d", (int)timedifference];
    return [secString stringByAppendingString:@"s"];
    
}

+ (NSString *)getMonthName:(NSInteger)month{
    switch ((int)month) {
        case 1:
            return @"Jan";
        case 2:
            return @"Feb";
        case 3:
            return @"Mar";
        case 4:
            return @"Apr";
        case 5:
            return @"May";
        case 6:
            return @"Jun";
        case 7:
            return @"Jul";
        case 8:
            return @"Aug";
        case 9:
            return @"Sep";
        case 10:
            return @"Oct";
        case 11:
            return @"Nov";
        case 12:
            return @"Dec";
        default:
            return @"Dec";
    }
}


@end
