//
//  KeyChainWrapper.m
//  Cells
//
//  Created by Wen-Hsiang Shaw on 3/10/14.
//  Copyright (c) 2014 WYY. All rights reserved.
//

#import "KeyChainWrapper.h"

// Marble server credentials
static NSString *SessionToken = nil;

// FB credentials
static NSString *FBUserID = nil;
static NSString *FBAccessToken = nil;

// Device token
static NSData *deviceToken = nil;

// Keywords
static NSArray *keywords = nil;

@implementation KeyChainWrapper

+(void)storeFBUserID:(NSString *)fbUserID
{
    if (fbUserID != nil) {
        FBUserID = [NSString stringWithString:fbUserID];
    }
}

+(void)storeFBAccessToken:(NSString *)fbAccessToken
{
    if (fbAccessToken != nil) {
        FBAccessToken = [NSString stringWithString:fbAccessToken];
    }
}

+(NSString *)FBAccessToken
{
    return FBAccessToken;
}

+(NSString *)FBUserID
{
    return FBUserID;
}

+(BOOL)isFBUserIDValid
{
    if (FBUserID == nil || [FBUserID isEqualToString:@""]){
        return false;
    } else {
        return true;
    }
}

+(bool)isExpired:(NSDate *)date
{
    // if expiration is coming in fifteen minutes, let's renew it!
    NSDate *soon = [NSDate dateWithTimeIntervalSinceNow:(15 * 60)];
    
    if ( [soon compare:date] == NSOrderedDescending) {
        return YES;
    }
    else {
        return NO;
    }
}


+(void)storeSessionToken:(NSString *)theSessionToken{
    SessionToken = [NSString stringWithString:theSessionToken];
}

+(NSString *)getSessionTokenForUser
{
    return SessionToken;
}

+(BOOL) isSessionTokenValid
{
    if (SessionToken == nil || [SessionToken isEqualToString:@""]){
        return false;
    } else {
        return true;
    }
}

+(void)storeDeviceToken:(NSData *)theDeviceToken
{
    deviceToken = [NSData dataWithData:theDeviceToken];
}

+(NSData *)deviceToken
{
    return deviceToken;
}


+(void)cleanUpCredentials{
    // Marble server credentials
    SessionToken = nil;
    
    // FB credentials
    FBUserID = nil;
}

+(void)storeKeywords:(NSArray *)theKeywords
{
    keywords = [NSArray arrayWithArray:theKeywords];
}

+(NSArray *)keywords
{
    return keywords;
}

+(NSArray *)searchKeywordThatContains:(NSString *)text returnThisManyKeywords:(int)num{
    int i = 0;
    NSMutableArray *arrayOfKeywords = [[NSMutableArray alloc] init];
    for(NSString *keyword in self.keywords){
        if([keyword rangeOfString:text].location!=NSNotFound){
            [arrayOfKeywords addObject:keyword];
            i++;
        }
        if(i > num){
            break;
        }
    }
    return arrayOfKeywords;
}


@end
