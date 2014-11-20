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
        return [Utility shortenName:name];
    }
    NSRange start = [name rangeOfString:@"("];
    NSRange end = [name rangeOfString:@")"];
    return [Utility shortenName:[name substringWithRange:NSMakeRange(start.location + 1, end.location - (start.location + 1))]];
}

+(NSString *) shortenName:(NSString *)name{
    if([name length] > 10){
        NSRange firstSpace = [name rangeOfString:@" "];
        if(firstSpace.location != NSNotFound){
            /*
            if(firstSpace.location < 10){
                NSRange findRange;
                findRange.location = firstSpace.location + firstSpace.length;
                if(findRange.location < name.length){
                    NSRange secondSpace = [name rangeOfString:@" " options:nil range:findRange];
                    if(secondSpace.location != NSNotFound){
                        NSString *concatString = [name substringWithRange:NSMakeRange(0, secondSpace.location +2)];
                        return [concatString stringByAppendingString:@"."];
                    }
                }
            }
             */
            NSString *concatString = [name substringWithRange:NSMakeRange(0, firstSpace.location +2)];
            return [concatString stringByAppendingString:@"."];
        }else{
            return name;
        }
    }
    return name;
}

+ (NSDate *)DateForRFC3339DateTimeString:(NSString *)rfc3339datestring
{
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    [rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *date = [rfc3339DateFormatter dateFromString:rfc3339datestring];
    
    return date;
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

+ (NSDictionary *)getPostsViewNameFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:15],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getPostsViewCommentFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:15],NSFontAttributeName, [UIColor grayColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getNavigationBarTitleFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:20],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, nil];
}

+ (NSDictionary *)getWriteACommentFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:12],NSFontAttributeName, [UIColor grayColor] ,NSForegroundColorAttributeName,  @(-0.5), NSKernAttributeName, nil];
}
+ (NSDictionary *)getEditingCommentFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:16],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName,  @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getWhiteCommentFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:14],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}
+ (NSDictionary *)getNormalKeywordFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:14],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}
+ (NSDictionary *)getQuizCellKeywordNameFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:17],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getQuizCompareNumOnPicFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:16],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getNotifBlackBoldFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:14],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName,nil];
}

+ (NSDictionary *)getNotifOrangeBoldFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:14],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName,nil];
}

+ (NSDictionary *)getLightOrangeBoldFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:16],NSFontAttributeName, [UIColor marbleLightOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,nil];
}

+ (NSDictionary *)getNotifOrangeNormalFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:14],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName,nil];
}

+ (NSDictionary *)getNotifBlackNormalFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:14],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName,nil];
}

+ (NSDictionary *)getGraySmallFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:10],NSFontAttributeName, [UIColor grayColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,  nil];
}

+ (NSDictionary *)getQuizCompareNumFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:10],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,  nil];
}

+(NSMutableParagraphStyle *) getNotifParagraphStyle{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 16.f;
    paragraphStyle.maximumLineHeight = 16.f;
    return paragraphStyle;
}



+ (NSDictionary *)getBigNameFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:23],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,nil];
}

+ (NSDictionary *)getProfileStatusFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:15],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName, nil];
}

+ (NSDictionary *)getProfileUpdateStatusFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:15],NSFontAttributeName, [UIColor grayColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName, nil];
}

+ (NSDictionary *)getProfileGrayStaticFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:13],NSFontAttributeName, [UIColor grayColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,  nil];
}

+ (NSDictionary *)getCreateQuizSuperBigKeywordFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:25],NSFontAttributeName, [UIColor marbleOrange] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getCreateQuizRightNameFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:18],NSFontAttributeName, [UIColor marbleBlueNameColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];

}
+ (NSDictionary *)getCreateQuizLeftNameFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:18],NSFontAttributeName, [UIColor marbleGreenNameColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];

}
+ (NSDictionary *)getCreateQuizShuffleButtonFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:18],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}
+ (NSDictionary *)getDirectionTextFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:25],NSFontAttributeName, [UIColor whiteColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
}

+ (NSDictionary *)getProfileMoreFontDictionary{
        return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:14],NSFontAttributeName, [UIColor grayColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,  nil];
}

+ (NSDictionary *)getSearchResultFontDictionary{
        return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:16],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, [Utility getNotifParagraphStyle],NSParagraphStyleAttributeName,nil];
}

+ (NSDictionary *)getWalkThroughFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:20],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,  nil];
}

+ (NSDictionary *)getCreateQuizDescFontDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans" size:20],NSFontAttributeName, [UIColor blackColor] ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName,  nil];
}


+ (UIButton *)getKeywordButtonAtX:(int)x andY:(int)y andString:(NSString *)string{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:string attributes:[Utility getNormalKeywordFontDictionary]];
    UIButton *keywordBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, attString.size.width + 15, attString.size.height + 5)];
//    [keywordBtn.layer setBorderColor:[UIColor grayColor].CGColor];
//    [keywordBtn.layer setBorderWidth:1.0f];
    [keywordBtn.layer setCornerRadius:keywordBtn.frame.size.height/2.0f];
    [keywordBtn.layer setMasksToBounds:YES];
    [keywordBtn setBackgroundColor:[UIColor marbleOrange]];
    [keywordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [keywordBtn setAttributedTitle:attString forState:UIControlStateNormal];
    return keywordBtn;
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


//+ (void) setApplicationBadgeNumber:(NSInteger)number
//{
//    if (number != 0) {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = number;
//    } else {
//        [UIApplication sharedApplication].applicationIconBadgeNumber = nil;
//    }
//}

+ (void) sendThroughRKRoute:(NSString *)routeName withParams:(NSDictionary *)params_
{
    [Utility sendThroughRKRoute:routeName withParams:params_ successBlock:nil failureBlock:nil];
}

+ (void) sendThroughRKRoute:(NSString *)routeName withParams:(NSDictionary *)params_
               successBlock:(voidBlock)successBlock failureBlock:(voidBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[[KeyChainWrapper getSessionTokenForUser]]
                                   forKeys:@[@"auth_token"]];
    if (params_ != nil) {[params addEntriesFromDictionary:params_];}
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:routeName
                                                                                          object:self
                                                                                      parameters:params];
    
    RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:nil];
        MBDebug(@"SEND THROUGH %@", response);
        MBDebug(@"object posted/got via route %@", routeName);
        if (successBlock) {successBlock();}
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [Utility generateAlertWithMessage:@"Network problem"];
         });
         MBError(@"Cannot send/get object via route %@!", routeName);
         if (failureBlock) {failureBlock();}
     }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];

}

+ (void) setUpProfilePictureImageView:(UIImageView *)view byFBID:(NSString *)fbID {
    [view setTag:[view tag]+1];
    NSUInteger tag = [view tag];
    NSUInteger width = view.frame.size.width*2;
    NSUInteger height = view.frame.size.height*2;
    NSString *fileName = [NSString stringWithFormat:@"%@w%luh%lu.png", fbID, width, height];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
    if(imageData){
        if(tag == [view tag]){
            [view setImage:[UIImage imageWithData:imageData]];
        }
        MBDebug(@"found photo!!!! %@", fileName);
    } else {
        NSURL *picURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%lu&height=%lu", fbID, (unsigned long)width, (unsigned long)height]];
        [view setImageWithURLRequest:[NSURLRequest requestWithURL:picURL]
                    placeholderImage:[UIImage imageNamed:@"head.png"]
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 MAINQ(
                                       if(tag == [view tag]){
                                           [view setImage:image];
                                       }
                                       );
                                 ASYNC({
                                     NSData *data = UIImagePNGRepresentation(image);
                                     BOOL succeed = [data writeToFile:filePath atomically:YES];
                                     if(succeed){
                                         MBDebug(@"succesfully saved profile picture");
                                     }else{
                                         MBError(@"failed to saved profile picture");
                                     }
                                 });
                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 MBError(@"Failed to fetch profile picture from Facebook Server");
                             }];
        
    }
}


+(NSString *)getRankingFullString:(NSNumber *)number{
    int numberInt = [number intValue];
    int lastDigit = numberInt % 10;
    NSString *postfix;
    MBDebug(@"last digit%d", lastDigit);
    switch (lastDigit) {
        case 0:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            postfix = @"th";
            break;
        }
        case 1:{
            postfix = @"st";
            break;
        }
        case 2:{
            postfix = @"nd";
            break;
        }
        case 3:{
            postfix = @"rd";
            break;
        }
        default:{
            postfix = @"th";
            break;
        }
    }
    MBDebug(@"whatispostfix%@", postfix);
    return [[NSString stringWithFormat:@"%@",number] stringByAppendingString:postfix];
}
+ (int)getCellHeightForPostWithType:(PostCellType)cellType withComments:(NSArray *)comments whetherSinglePost:(bool)isSinglePost {
    if (cellType == MBQuizCellType){
        if(!comments|| [comments count] == 0){
            return [KeyChainWrapper getQuizCellDisplayHeight];
        } else if([comments count] > 2 && !isSinglePost){
            return [KeyChainWrapper getQuizCellDisplayHeight] +FirstCommentIncrementHeight + 2*CommentIncrementHeight + 8;
        } else{
            return [KeyChainWrapper getQuizCellDisplayHeight] + FirstCommentIncrementHeight + (int)([comments count]-1)*CommentIncrementHeight+ 8;
        }
    } else if(cellType == MBStatusUpdateCellType){
        if(!comments|| [comments count] == 0){
            return StatusUpdateTableViewCellDisplayHeight;
        } else if([comments count] > 2 && !isSinglePost){
            return StatusUpdateTableViewCellDisplayHeight + FirstCommentIncrementHeight + 2*CommentIncrementHeight+ 8;

        } else{
            return StatusUpdateTableViewCellDisplayHeight + FirstCommentIncrementHeight + (int)([comments count]-1)*CommentIncrementHeight+ 8;
        }
    } else if(cellType == MBKeywordUpdateCellType){
        if(!comments || [comments count] == 0){
            return KeywordUpdateTableViewCellDisplayHeight;
        } else if([comments count] > 2 && !isSinglePost){
            return KeywordUpdateTableViewCellDisplayHeight + FirstCommentIncrementHeight + 2*CommentIncrementHeight+ 8;

        } else{
            return KeywordUpdateTableViewCellDisplayHeight + FirstCommentIncrementHeight + (int)([comments count]-1)*CommentIncrementHeight+ 8;
        }
    } else{
        MBDebug(@"should never happen");
        return 0;
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
