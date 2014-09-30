//
//  LoginViewController.m
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
    @property (strong, nonatomic) FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSString *userName;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *kerker = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [kerker setText:@"hello"];
    [self.view addSubview:kerker];
    // Do any additional setup after loading the view.
    
    _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_birthday"]];
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
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
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [_statusLabel setText:@"You can pass now."];

    FBAccessTokenData *accessTokenData = FBSession.activeSession.accessTokenData;
    NSString *FBAccessToken = accessTokenData.accessToken;
    
    MSDebug(@"FB Access Token: %@", FBAccessToken);
    
    [ClientManager login:FBAccessToken delegate:self];
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    for(UIView *view in self.view.subviews){
        if(view.tag == NAME_LOGINOUT_TAG){
            [view removeFromSuperview];
        }
    }
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
#pragma mark TVMClient Delegate methods
- (void) TVMLoggedIn
{
    //Set Badge number to 0
    ASYNC({
        [ClientManager sendBadgeNumber:0];
    });
    [self performSegueWithIdentifier:@"viewMultiPostsSegue" sender:nil];
}

- (void) TVMLoggingInFailed
{
    [self logoutFBUser];
}

- (void) TVMSignedUp
{
    [Flurry logEvent:@"Signed_Up"];
    //Set Badge number to 0
    ASYNC({
        [ClientManager sendBadgeNumber:0];
    });
    [self performSegueWithIdentifier:@"viewMultiPostsSegue" sender:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
