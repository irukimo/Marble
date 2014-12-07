//
//  KeyChainWrapper.h
//  Cells
//
//  Created by Wen-Hsiang Shaw on 3/10/14.
//  Copyright (c) 2014 WYY. All rights reserved.
//


@interface KeyChainWrapper : NSObject

+(void)storeSessionToken:(NSString *)theSessionToken;
+(NSString *)getSessionTokenForUser;
+(BOOL) isSessionTokenValid;

+(void)storeFBAccessToken:(NSString *)fbAccessToken;
+(NSString *)FBAccessToken;

+(void)storeDeviceToken:(NSData *)theDeviceToken;
+(NSData *)deviceToken;

+(void)storeKeywords:(NSArray *)theKeywords;
+(void)addKeyword:(NSString *)keyword;
+(NSArray *)keywords;
+(NSArray *)searchKeywordThatContains:(NSString *)text returnThisManyKeywords:(int)num;
+(NSString *)getARandomKeyword;

+(void)storeSelfName:(NSString *)name andID:(NSString *)fbid;
+(NSString *)getSelfName;
+(NSString *)getSelfFBID;
    
+(void)cleanUpCredentials;

+(CGFloat)getQuizImageWidth;
+(CGFloat)getQuizCellDisplayHeight;
+(CGFloat)getQuizCellHeight;

+(CGFloat)getScreenWidth;
+(CGFloat)getScreenHeight;
+(CGFloat)getKeywordUpdateKeywordsViewWidth;
//+(NSString *)getValueFromKeyChain:(NSString *)key;
//+(void)storeValueInKeyChain:(NSString *)value forKey:(NSString *)key;
//+(void)registerDeviceId:(NSString *)uid andKey:(NSString *)key;
//+(NSString *)getUidForDevice;
//+(NSString *)getKeyForDevice;

//+(OSStatus)wipeKeyChain;
//+(OSStatus)wipeCredentialsFromKeyChain;
//+(NSMutableDictionary *)createKeychainDictionaryForKey:(NSString *)key;

@end
