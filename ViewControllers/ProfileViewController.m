//
//  ProfileViewController.m
//  
//
//  Created by Iru on 10/1/14.
//
//

#import "ProfileViewController.h"
#import "KeyChainWrapper.h"
#import "FacebookSDK/FacebookSDK.h"

#define SEND_BUTTON_TAG 116

@interface ProfileViewController ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) PostsViewController *postsViewController;
@property (strong, nonatomic) UITextField *statusTextField;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *fbid;
@property (strong, nonatomic) UIButton *statusBtn;
@property ( nonatomic) BOOL isSelf;
@property (strong, nonatomic) FBProfilePictureView *profilePicView;
@end

@implementation ProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProfileUI];
    [self initiateCreateQuizViewController];
    [self initiatePostsViewController];
    [self setNavbarTitle];
    [self addTextFieldAndButtons];
    if(!_profilePicView){
        [self initFBProfilePicViews];
    }
//    [self setNavigationAttributes];
    // Do any additional setup after loading the view.
    
}

-(void)addTextFieldAndButtons{
    _statusTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, 100, 20)];
    [_statusTextField setText:@""];
    _statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 40, 20)];
    [_statusTextField setDelegate:self];
    [_statusBtn setTitle:@"send" forState:UIControlStateNormal];
    [_statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusBtn setTag:SEND_BUTTON_TAG];
    [_statusTextField setBorderStyle:UITextBorderStyleLine];
    [self.view addSubview:_statusTextField];
    [self.view addSubview:_statusBtn];
    [_statusBtn addTarget:self action:@selector(sendStatusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void) initFBProfilePicViews{
    _profilePicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    _profilePicView.layer.cornerRadius = 25.0f;
    _profilePicView.layer.masksToBounds = YES;
    [self.view addSubview:_profilePicView];
    _profilePicView.profileID = _fbid;
}

//-(void)setNavigationAttributes{
//    self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"yes" style:UIBarButtonItemStylePlain target:nil action:nil];
//}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
//    [[myNavBar topItem] setTitle:@"YOUR PROFILE"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleBlue]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleBlue]];
}

-(void) initiatePostsViewController{
    _postsViewController = [[PostsViewController alloc] init];
    [_postsViewController.view setFrame:CGRectMake(0, 250, self.view.frame.size.width, 200)];
    [self.view addSubview:_postsViewController.view];
    _postsViewController.delegate = self;
}


-(void) initiateCreateQuizViewController{
    _createQuizViewController = [[CreateQuizViewController alloc] init];
    [_createQuizViewController.view setFrame:CGRectMake(0, 150, self.view.frame.size.width, 200)];
    [self.view addSubview:_createQuizViewController.view];
    [_createQuizViewController setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addProfileUI{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 100, 30)];
    [_nameLabel setText:@"Hello"];
    if(_name){
        [_nameLabel setText:[Utility getNameToDisplay:_name]];
    }
    [self.view addSubview:_nameLabel];
}

-(void) setName:(NSString *)name andID:(NSString *)fbid{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selfFBID = nil;
    if (standardUserDefaults){
        selfFBID = [standardUserDefaults objectForKey:@"userFBID"];
    }
    _name = [name copy];
    _fbid = [fbid copy];
    if(!_profilePicView){
        [self initFBProfilePicViews];
    }
    _profilePicView.profileID = _fbid;
    [_nameLabel setText:[Utility getNameToDisplay:name]];
    _isSelf = ([_fbid isEqualToString:selfFBID])? TRUE : FALSE;
    NSLog(@"personid %@, selfid %@", _fbid, selfFBID);
    if(_isSelf){
        [_statusTextField setEnabled:YES];
    } else{
        [_statusTextField setEnabled:NO];
        for(id view in self.view.subviews){
            if([view isKindOfClass:[UIButton class]]){
                UIButton *btn = view;
                if([btn tag] == SEND_BUTTON_TAG){
                    [view removeFromSuperview];
                }
            }
        }
    }
    [self getStatus];
}

//#TODO: Handle the case when the user has not been created yet
-(void) getStatus{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:
//     [NSEntityDescription entityForName:@"User" inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext]];
//    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"fbID = %@", _fbid]];
//    
//    // Execute the fetch.
//    NSError *error;
//    NSArray *matches = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest error:&error];
//    User *user = [matches firstObject];
    User *user = nil;
    if (![User findOrCreateUserForName:_name withfbID:_fbid returnAsEntity:&user
           inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext])
    {
        MBError(@"Cannot find or create the user (id: %@, name: %@)", _fbid, _name);
        return;
    }
        
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[[KeyChainWrapper getSessionTokenForUser], user.fbID]
                                   forKeys:@[@"auth_token", @"fb_id"]];

    [[RKObjectManager sharedManager]
     getObject:user
     path:nil //previously defined Class routes
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         MBDebug(@"status result: %@", [mappingResult array]);
         if([user isKindOfClass:[User class]]){
             [_statusTextField setText:user.status];
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         MBDebug(@"failed to get status");
     }];

}

-(void) postSelected:(NSString *)name{
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:name];
}

-(void) sendStatusBtnClicked
{
    NSString *status = _statusTextField.text;
    MBDebug(@"To send status: %@", status);
    [Utility sendThroughRKRoute:@"send_status" withParams:@{@"status": status}];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backToNormal:(CreateQuizViewController *)viewController{
    for(id view in self.view.subviews){
        if([view tag] == 100){
            [view removeFromSuperview];
        }
    }
    //    NSLog(@"backtonormal");
    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 150,
                                                      self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

#pragma mark -
#pragma mark UITextfield Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return (_isSelf)? YES: NO;
}



#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
//- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
//    [self prepareSelectPeopleViewController];
//    [_selectPeopleViewController setPeopleArray:people];
//    [self.view addSubview:_selectPeopleViewController.view];
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
//                                                      self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
//    
//}
//
//- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
//                                                      self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass:[ProfileViewController class]]){
        if([sender isKindOfClass:[NSArray class]]){
            ProfileViewController *viewController =[segue destinationViewController];
            [viewController setName:(NSString *)[sender firstObject] andID:[sender objectAtIndex:1]];
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark -
#pragma mark PostViewController Delegate Methods
-(void) postSelected:(NSString *)name andID:(NSString *)fbid{
    NSArray *infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:infoBundle];
}

@end
