//
//  Utilities.h
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeywordUpdate.h"
#import "StatusUpdate.h"
#import "Quiz.h"

@interface Utility : NSObject
+ (void) generateAlertWithMessage:(NSString *)message;

+ (NSString *) generateUUID;

typedef void (^RKFailureBlock)(RKObjectRequestOperation *, NSError *);
typedef void (^RKSuccessBlock)(RKObjectRequestOperation *, RKMappingResult *);
typedef void (^voidBlock)(void);

+ (RKSuccessBlock) successBlockWithDebugMessage:(NSString *)message block:(voidBlock)callbackBlock;
+ (RKFailureBlock) failureBlockWithAlertMessage:(NSString *)message block:(voidBlock)callbackBlock;

+ (void)saveToPersistenceStore:(NSManagedObjectContext *)context failureMessage:(NSString *)failureMessage;
+(NSString *) getNameToDisplay:(NSString *)name;

+ (NSDate *)DateForRFC3339DateTimeString:(NSString *)rfc3339datestring;
+ (NSString *)getDateToShow:(NSDate *)date inWhole:(BOOL) inWhole;


+ (NSDictionary *)getPostsViewNameFontDictionary;
+ (NSDictionary *)getPostsViewCommentFontDictionary;
+ (NSDictionary *)getQuizCellKeywordNameFontDictionary;
+ (NSDictionary *)getQuizCompareNumOnPicFontDictionary;
+ (NSDictionary *)getQuizCompareNumFontDictionary;


+ (NSDictionary *)getWhiteCommentFontDictionary;
+ (NSDictionary *)getNavigationBarTitleFontDictionary;
+ (NSDictionary *)getWriteACommentFontDictionary;
+ (NSDictionary *)getEditingCommentFontDictionary;


+ (NSDictionary *)getNotifBlackBoldFontDictionary;
+ (NSDictionary *)getNotifOrangeBoldFontDictionary;
+ (NSDictionary *)getNotifOrangeNormalFontDictionary;
+ (NSDictionary *)getNotifBlackNormalFontDictionary;
+ (NSDictionary *)getGraySmallFontDictionary;



+ (NSDictionary *)getLightOrangeBoldFontDictionary;

+ (NSDictionary *)getBigNameFontDictionary;

+ (NSDictionary *)getProfileGrayStaticFontDictionary;
+ (NSDictionary *)getProfileStatusFontDictionary;
+ (NSDictionary *)getProfileMoreFontDictionary;
+ (NSDictionary *)getProfileUpdateStatusFontDictionary;

+ (NSDictionary *)getCreateQuizSuperBigKeywordFontDictionary;
+ (NSDictionary *)getCreateQuizShuffleButtonFontDictionary;
+ (NSDictionary *)getCreateQuizRightNameFontDictionary;
+ (NSDictionary *)getCreateQuizLeftNameFontDictionary;
+ (NSDictionary *)getSearchResultFontDictionary;

+ (NSDictionary *)getWalkThroughFontDictionary;
+ (NSDictionary *)getCreateQuizDescFontDictionary;

+ (NSDictionary *)getDirectionTextFontDictionary;
+ (NSDictionary *)getCommentsTableCommentNumFontDictionary;





+ (UIButton *)getKeywordButtonAtX:(int)x andY:(int)y andString:(NSString *)string;
//+ (void) setApplicationBadgeNumber:(NSInteger)number;


+ (void) sendThroughRKRoute:(NSString *)routeName withParams:(NSDictionary *)params_;
+ (void) sendThroughRKRoute:(NSString *)routeName withParams:(NSDictionary *)params_
               successBlock:(voidBlock)successBlock failureBlock:(voidBlock)failureBlock;

+ (void) setUpProfilePictureImageView:(UIImageView *)view byFBID:(NSString *)fbID;

+ (NSString *)getRankingFullString:(NSNumber *)number;
+ (int)getCellHeightForPost:(Post *)post whetherSinglePost:(bool)isSinglePost;
+(int)getLineNumForKeywords:(NSArray *)keywords withWidth:(CGFloat)width;
+(NSArray *)getKeywordArray:(KeywordUpdate *)keywordUpdate;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
