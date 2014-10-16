//
//  LoginViewController.m
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "User+MBUser.h"
#import "dispatch/semaphore.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSString *userName;
@property dispatch_semaphore_t mysemaphore;
    
@property (strong, nonatomic) NSArray *fbEngUsers;
@property (strong, nonatomic) NSArray *fbChUsers;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *kerker = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [kerker setText:@"hello"];
    [self.view addSubview:kerker];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backgroundView setImage:[UIImage imageNamed:@"login.png"]];
    [self.view addSubview:backgroundView];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]]];
    // Do any additional setup after loading the view.
    
    _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    _loginView.delegate = self;
    // Align the button in the center horizontally
    _loginView.frame = CGRectOffset(_loginView.frame, (self.view.center.x - (_loginView.frame.size.width / 2)), 500);
    [self.view addSubview:_loginView];
    _mysemaphore = dispatch_semaphore_create(1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Facebook Login View

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    _userName = [user.name copy];
    [_nameLabel setText:_userName];
    
    _fbChUsers = nil;
    _fbEngUsers = nil;
    [self getFriendsNamesIsEngish:true];
    [self getFriendsNamesIsEngish:false];
    
    [KeyChainWrapper storeSelfName:_userName andID:user.id];

}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [_statusLabel setText:@"You can pass now."];

    FBAccessTokenData *accessTokenData = FBSession.activeSession.accessTokenData;
    NSString *FBAccessToken = accessTokenData.accessToken;
    
    MBDebug(@"FB Access Token: %@", FBAccessToken);
    
    [ClientManager login:FBAccessToken delegate:self];
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    [_statusLabel setText:@"You shall not pass!"];
    [ClientManager logout];
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
//                                           for(User *opt in [mappingResult array]) {
//                                               MBDebug(@"%@", opt.name);
//                                           }
                                       }
                                       failure:[Utility failureBlockWithAlertMessage:@"Can't connect to the server"
                                                                               block:^{MBError(@"Cannot load options");}]
     ];
    
    
    [self performSegueWithIdentifier:@"homeSegue" sender:nil];
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
    [ClientManager logout];
    [KeyChainWrapper cleanUpCredentials];
    [self logoutFBUser];
}

-(void) logoutFBUser{
    [FBSession.activeSession closeAndClearTokenInformation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) getFriendsNamesIsEngish:(BOOL)isEnglish
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
                                      
                                      if(isEnglish) {
                                          _fbEngUsers = friends;
                                      } else {
                                          _fbChUsers = friends;
                                      }

                                      if (_fbEngUsers != nil && _fbChUsers != nil) {
                                          NSManagedObjectContext *context = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];
//                                          NSManagedObjectContext *context = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
                                          [User createUsersInBatchForEng:_fbEngUsers andChinese:_fbChUsers inManagedObjectContext:context];
                                      }
                                  }else{
                                      NSLog(@"error%@", error);
                                  }
                              });
                          }];

}

@end
