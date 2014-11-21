//
//  LaunchViewController.m
//  Marble
//
//  Created by Iru on 11/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "LaunchViewController.h"
#import "dispatch/semaphore.h"
#import "User+MBUser.h"


@interface LaunchViewController()
@property (strong, nonatomic) FBLoginView *loginView;
@property dispatch_semaphore_t mysemaphore;
@property (strong, nonatomic) NSArray *fbEngUsers;
@property (strong, nonatomic) NSArray *fbChUsers;

@end

@implementation LaunchViewController
-(void)viewDidLoad{
    _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    _loginView.delegate = self;
    // Align the button in the center horizontally
    _loginView.frame = CGRectOffset(_loginView.frame, (self.view.center.x - (_loginView.frame.size.width / 2)), 500);
//    [self.view addSubview:_loginView];
    _mysemaphore = dispatch_semaphore_create(1);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"launchImage.png"]];
    [self.view addSubview:imageView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(logoutUser) name:MBSignOutNotification object:nil];
}
#pragma mark -
#pragma mark Facebook Login View

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    _fbChUsers = nil;
    _fbEngUsers = nil;
    

    MBDebug(@"storename %@, %@",user.name, user.id);
    
    [KeyChainWrapper storeSelfName:user.name andID:user.id];
    
}


-(void)getFriendsNamesInEngOnly
{
    [self getFriendsNamesIsEngish:true bilingual:false];
}


-(void)getFriendsNamesInEngAndCh
{
    [self getFriendsNamesIsEngish:true bilingual:true];
    [self getFriendsNamesIsEngish:false bilingual:true];
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    FBAccessTokenData *accessTokenData = FBSession.activeSession.accessTokenData;
    NSString *FBAccessToken = accessTokenData.accessToken;
    
    MBDebug(@"FB Access Token: %@", FBAccessToken);
    [self dismissViewControllerAnimated:NO completion:nil];
    [ClientManager login:FBAccessToken delegate:self];
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    [ClientManager logout];
    [self performSegueWithIdentifier:@"LoginViewControllerSegue" sender:self];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark -
#pragma mark ClientClient Delegate methods
- (void) afterLoggedIn
{
    [ClientManager getKeywords];
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[sessionToken] forKeys:@[@"auth_token"]];
    MBDebug(@"Loading options...");
    
    [[RKObjectManager sharedManager] getObject:[User alloc]
                                          path:@"options"
                                    parameters:params
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           MBDebug(@"Successfully loadded options from server");
                                           MBDebug(@"%ld options were loaded.", [[mappingResult array] count]);
                                           //    [self getFriendsNamesInEngOnly];
                                           [self getFriendsNamesInEngAndCh];
                                           //                                           for(User *opt in [mappingResult array]) {
                                           //                                               MBDebug(@"%@", opt.name);
                                           //                                           }
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{MBError(@"Cannot load options");}]
     ];
    
    [self performSegueWithIdentifier:@"MarbleTabBarControllerSegue" sender:nil];
}

- (void) ClientLoggedIn
{
    //Set Badge number to 0
    ASYNC({
        //        [ClientManager sendBadgeNumber:0];
    });
    [self afterLoggedIn];
}

- (void) ClientLoggingInFailed
{
    [self logoutFBUser];
}

- (void) ClientSignedUp
{
    //Set Badge number to 0
    ASYNC({
        //        [ClientManager sendBadgeNumber:0];
    });
    
    [self afterLoggedIn];
}

#pragma mark - log out user method
-(void) logoutUser{
    MBDebug(@"Received SignOutNotification");
    [self dismissViewControllerAnimated:YES completion:nil];
    [ClientManager logout];
    [KeyChainWrapper cleanUpCredentials];
    [self logoutFBUser];
}

-(void) logoutFBUser{
    [FBSession.activeSession closeAndClearTokenInformation];
    [self performSegueWithIdentifier:@"LoginViewControllerSegue" sender:self];
}
-(void) getFriendsNamesIsEngish:(BOOL)isEnglish bilingual:(BOOL)bilingual
{
    NSDictionary *params = nil;
    if (isEnglish) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"en_US",  @"locale", nil];
    } else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"zh_TW",  @"locale", nil];
    }
    
    NSLog(@"executed get names");
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters: params
                                 HTTPMethod:nil
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              ASYNC({
                                  if (!error) {
                                      // Get the result
                                      NSArray* friends = [result objectForKey:@"data"];
                                      NSLog(@"Found: %lu friends", (unsigned long)friends.count);
                                      
                                      NSManagedObjectContext *context = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];

                                      @synchronized(self) {
                                          if(isEnglish) {
                                              _fbEngUsers = friends;
                                          } else {
                                              _fbChUsers = friends;
                                          }

                                          [User createUsersInBatchForEng:_fbEngUsers
                                                              andChinese:_fbChUsers
                                                               bilingual:bilingual
                                                  inManagedObjectContext:context];
                                      }
                                  }else{
                                      NSLog(@"error%@", error);
                                  }
                              });
                          }];
    
}
@end
