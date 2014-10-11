//
//  ClientManager.m
//  Marble
//
//  Created by Wen-Hsiang Shaw on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClientManager.h"
#import "KeyChainWrapper.h"

static id<ClientLoginDelegate> delegate = nil;
static AFHTTPClient *httpClient = nil;
static NSInteger tryAgainButtonIndex;

@implementation ClientManager

+(ClientManager *)sharedClientManager
{
    static ClientManager *sharedClientManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClientManager = [[self alloc] init];
        NSURL *url = [NSURL URLWithString:BASE_URL];
        // we are using AFTNETWOKRING 1.3.3.... not the latest one due to RestKit dependencies
        httpClient = [AFHTTPClient clientWithBaseURL:url];
    });
    return sharedClientManager;
}


#pragma mark -
#pragma mark Login/Logout Methods

+(bool)isLoggedIn
{
    return ([KeyChainWrapper getSessionTokenForUser] != nil);
}


+(void)login:(NSString *)FBAccessToken delegate:(id<ClientLoginDelegate>)delegate_
{
    delegate = delegate_;
    [KeyChainWrapper storeFBAccessToken:FBAccessToken];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:FBAccessToken
                                                             forKey:@"fb_access_token"];
    [ClientManager sharedClientManager];
    MBDebug(@"Before login: %@", params);
    
    [httpClient postPath:@"login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self handleLoggedIn:(NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:nil]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailedToLogIn:error];
    }];
}



+ (void)handleLoggedIn:(NSDictionary *)response
{
    NSString *token = [response objectForKey:@"token"];
    NSString *signup = [response objectForKey:@"signup"];
    
    if (token != nil && signup != nil) {
        [KeyChainWrapper storeSessionToken:token];
        MBDebug(@"Auth token: %@", token);
        MBDebug(@"Signup: %@", signup);
        
        [ClientManager sendDeviceToken];
        if ([signup isEqualToString:@"true"]) {
            if (delegate && [delegate respondsToSelector:@selector(ClientSignedUp)]) {
                [delegate ClientSignedUp];
            } else {
                MBError(@"ClientClient's delegate method ClientSignedUp is not set!");
            }
        } else {
            if (delegate && [delegate respondsToSelector:@selector(ClientLoggedIn)]) {
                [delegate ClientLoggedIn];
            } else {
                MBError(@"ClientClient's delegate method ClientLoggedIn is not set!");
            }
        }
    } else {
        MBError(@"Login request sent successfully, but either token, bucket_name or signup is not returned");
    }
    
}

+ (void)handleFailedToLogIn:(NSError *)error
{
    MBError(@"Failed to log in");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                    message:nil
                                                   delegate:[ClientManager sharedClientManager]
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    tryAgainButtonIndex = [alert addButtonWithTitle:@"Try again!"];
    MBDebug(@"%ld", tryAgainButtonIndex);
    [alert show];
}

#pragma mark -
#pragma mark UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == tryAgainButtonIndex) {
        MBDebug(@"Try to log in again!");
        [ClientManager login:[KeyChainWrapper FBAccessToken] delegate:delegate];
    } else {
        if (delegate && [delegate respondsToSelector:@selector(ClientLoggingInFailed)]) {
            MBDebug(@"Tell delegate that logging in failed!");
            [delegate ClientLoggingInFailed];
        } else {
            MBError(@"ClientLogging's delegation is not set!");
        }
    }
}



+ (BOOL)logout
{
    if ([KeyChainWrapper isSessionTokenValid]) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:[KeyChainWrapper getSessionTokenForUser]
                                                           forKey:@"authentication_token"];
        
        [self sendSynchronousRequestWithClient:httpClient
                                        method:@"DELETE"
                                          path:@"users/sign_out"
                                    parameters:params
                                      response:nil
                                      errorLog:@"Can't log out!"];
    }
    
    return YES;
}


+ (BOOL) sendSynchronousRequestWithClient:(AFHTTPClient *)client
                                   method:(NSString *)method
                                     path:(NSString *)path
                               parameters:(NSDictionary *)params
                                 response:(NSDictionary **)response
                                 errorLog:(NSString *)errorLog
{
    NSMutableURLRequest *request = [client requestWithMethod:method path:path parameters:params];
    
    NSHTTPURLResponse *_response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&_response
                                                     error:&error];
    
    if (error != nil || data == nil || _response.statusCode != 200){
        NSLog(@"%@", errorLog);
        return false;
    }
    
    if (response != nil) {
        (*response) = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
    }
    return true;
}



+(void)sendDeviceToken
{
    NSData *deviceToken = [KeyChainWrapper deviceToken];
    MBDebug(@"device token: %@", deviceToken);
    
    // we wait for both device token and session token are ready
    if (deviceToken == NULL) {
        return;
    } else if (![KeyChainWrapper isSessionTokenValid]) {
        return;
    }
    MBDebug(@"Ready to send device token: %@", deviceToken);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[deviceToken, [KeyChainWrapper getSessionTokenForUser]]
                                                                     forKeys:@[@"device_token", @"auth_token"]];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    requestWithPathForRouteNamed:@"set_device_token"
                                                          object:self
                                                      parameters:params];

    RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        MBDebug(@"Device Token posted");
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [Utility generateAlertWithMessage:@"Network problem"];
                                         });
                                         MBError(@"Cannot set device token!");
                                     }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

+ (void)sendBadgeNumber:(NSInteger)number
{
    if (![KeyChainWrapper isSessionTokenValid]) {
        MBError(@"User session token is not valid.");
        return;
    }
    
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    
    MBDebug(@"badge number: %i", number);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[sessionToken, [NSNumber numberWithInteger:number]]
                                                                     forKeys:@[@"auth_token", @"badge_number"]];
    
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithPathForRouteNamed:@"set_badge"
                                                                                          object:self
                                                                                      parameters:params];
    
    RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = number;
        });
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [Utility generateAlertWithMessage:@"Network problem"];
                                         });
                                         MBError(@"Cannot set badge number!");
                                     }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

+(void)checkLetterPrompt
{

    [httpClient getPath:@"letters/check" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:nil];
        NSString *letter = [response objectForKey:@"letter"];
        if (letter) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Letter from Yours"
                                                                message:letter
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MBError(@"Failed to check letter prompt");
    }];
}

@end
