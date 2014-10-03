//
//  ClientManager.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#ifndef Marble_ClientManager_h
#define Marble_ClientManager_h

@protocol ClientLoginDelegate;

@interface ClientManager : NSObject <UIAlertViewDelegate>

+(bool)isLoggedIn;
+(void)login:(NSString *)FBAccessToken delegate:(id<ClientLoginDelegate>)delegate;;
+(BOOL)logout;

+(void)checkLetterPrompt;

+ (void)sendBadgeNumber:(NSInteger)number;

// Note that ClientManager is called to send device token twice. One is called here. Another one is called when
// TVMClient receives session token from moose server. The reason is because we don't konw which is received first -
// device token or session token. Therefore, we call ClientManager to send device token when the app receives either of them
// and let ClientManager to check if both are ready. If yes, ClientManager sends to device token to marble server.
+ (void)sendDeviceToken;

@end

@protocol ClientLoginDelegate <NSObject>

@required

- (void) ClientLoggedIn;
- (void) ClientSignedUp;
- (void) ClientLoggingInFailed;

@end


#endif
