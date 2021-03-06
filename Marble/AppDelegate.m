//
//  AppDelegate.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "RestKitInitializer.h"
#import "ClientManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Preloads keyboard so there's no lag on initial keyboard appearance.
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    // Override point for customization after application launch.
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSError *error = nil;
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    
    //for permanent store
//    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Moose.sqlite"];
//    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    
    //for in memory store
    NSPersistentStore *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    
    if (! persistentStore) {
        RKLogError(@"Failed adding in-memory persistent store: %@", error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // configure the object manager
    // Let's let the URL end with '/' so later in response descriptors or routes we don't need to prefix path patterns with '/'
    // Remeber, evaluation of path patterns against base URL could be surprising.
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    MBDebug(@"BASE URL: %@", BASE_URL);
    
    // DON'T EVER ADD FOLLOWING LINE because last time when I added it, ghost entities pop out everywhere...
    // THIS is kept here for the warning purpose
    //managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    objectManager.managedObjectStore = managedObjectStore;
    // only accepts JSON from the server
    [objectManager setAcceptHeaderWithMIMEType:@"application/json"];
    [RKObjectManager setSharedManager:objectManager];
    
    [RestKitInitializer setupWithObjectManager:objectManager inManagedObjectStore:managedObjectStore];
    
    
    // make sure that the FBLoginView class is loaded before the login view is shown.
    [FBLoginView class];

    // register Amplitude analytics tool
    [Amplitude initializeApiKey:@"f1debc1c0ff681ecdb3c1ee808672ce0"];
    
    //register to receive notifications
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]){
        MBDebug(@"iOS 8");
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        MBDebug(@"iOS 7");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                               UIRemoteNotificationTypeBadge |
                                                                               UIRemoteNotificationTypeSound)];
    }
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        NSString *alertMsg = @"";
        if( [apsInfo objectForKey:@"alert"] != NULL)
        {
            alertMsg = [apsInfo objectForKey:@"alert"];
        }
    }
    
    // Override point for customization after application launch.
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor marbleOrange];
    pageControl.backgroundColor = [UIColor clearColor];
    CGRect controlFrame = pageControl.frame;
    controlFrame.origin.y = controlFrame.origin.y - 30;
    [pageControl setFrame:controlFrame];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Push Notification Delegate Methods
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    MBDebug(@"application:didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    
    [KeyChainWrapper storeDeviceToken:deviceToken];
    // Note that ClientManager is called to send device token twice. One is called here. Another one is called when
    // ClientClient receives session token from moose server. The reason is because we don't konw which is received first -
    // device token or session token. Therefore, we call ClientManager to send device token when the app receives either of them
    // and let ClientManager to check if both are ready. If yes, ClientManager sends to device token to moose server.
    [ClientManager sendDeviceToken];
}


- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    MBError(@"Error in registering remote notification: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString * postUUID = [userInfo objectForKey:@"post_uuid"];
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UITabBarController *myTabBarController = (UITabBarController *)[self.window.rootViewController presentedViewController];
        MBDebug(@"tab bar controller: %@", myTabBarController);
        
        NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
        badgeNumber = badgeNumber + 1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
        if (badgeNumber == 0) {
            [[[[myTabBarController tabBar] items] lastObject] setBadgeValue:nil];
        } else {
            [[[[myTabBarController tabBar] items] lastObject] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)badgeNumber]];
        }
        
        MBDebug(@"Received notification while being active, set badge num from %d to %d", (badgeNumber - 1), badgeNumber);

        
//        [Flurry logEvent:@"Receive_Notification_In_Foreground"];
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        AudioServicesPlaySystemSound (1003);
//        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//        NSString *alertMsg = @"";
//        if( [apsInfo objectForKey:@"alert"] != NULL)
//        {
//            alertMsg = [apsInfo objectForKey:@"alert"];
//        }
//        _notifButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -50, WIDTH, 50)];
//        [_notifButton setTag:NOTIF_BUTTON_TAG];
//        [_notifButton setBackgroundColor:[UIColor colorForYoursWhite]];
//        [_notifButton setTitle:alertMsg forState:UIControlStateNormal];
//        [_notifButton setTitleColor:[UIColor colorForYoursOrange] forState:UIControlStateNormal];
//        _notifButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Cn" size:16.0];
//        
//        [_notifButton addTarget:self action:@selector(notifButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [self.window addSubview:_notifButton];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        [UIView animateWithDuration:ANIMATION_KEYBOARD_DURATION
//                              delay:ANIMATION_DELAY
//                            options: (UIViewAnimationOptions)UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             _notifButton.frame =
//                             CGRectMake(0,
//                                        0,
//                                        WIDTH,
//                                        _notifButton.frame.size.height);
//                         }
//                         completion:^(BOOL finished){
//                             [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(dismissNotifButton) userInfo:nil   repeats:NO];
//                         }];
    } else {
//        [Flurry logEvent:@"Open_Notification" withParameters:@{@"Status": @"App running in background"}];
//        [self displayRemoteNotifPost];
    }
    
//    ASYNC({
//        [ClientManager sendBadgeNumber:0];
//    });
}



#pragma mark - Facebook SDK methods
/**
 Processes the response from interacting with the Facebook login process
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
