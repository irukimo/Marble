//
//  Utilities.h
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (NSString *)getDateToShow:(NSDate *)date inWhole:(BOOL) inWhole;
+ (NSDictionary *)getPostsViewNameFontDictionary;
+ (NSDictionary *)getPostsViewCommentFontDictionary;
+ (NSDictionary *)getNavigationBarTitleFontDictionary;

+ (void) sendThroughRKRoute:(NSString *)routeName withParams:(NSDictionary *)params_;
+ (void) sendThroughRKRoute:(NSString *)routeName withParams:(NSDictionary *)params_
               successBlock:(voidBlock)successBlock failureBlock:(voidBlock)failureBlock;
@end
