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

+ (RKSuccessBlock) successBlockWithDebugMessage:(NSString *)message block:(void (^)(void))callbackBlock;
+ (RKFailureBlock) failureBlockWithAlertMessage:(NSString *)message block:(void (^)(void))callbackBlock;

+ (void)saveToPersistenceStore:(NSManagedObjectContext *)context failureMessage:(NSString *)failureMessage;
+(NSString *) getNameToDisplay:(NSString *)name;
@end
