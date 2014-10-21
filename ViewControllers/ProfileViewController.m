//
//  ProfileViewController.m
//  
//
//  Created by Iru on 10/1/14.
//
//

#import "ProfileViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "KeywordListViewController.h"
#import "KeywordProfileViewController.h"

#define SEND_BUTTON_TAG 116

@interface ProfileViewController ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) PostsViewController *postsViewController;
@property (strong, nonatomic) UITextField *statusTextField;
@property (strong, nonatomic) UIButton *statusBtn;
@property (strong, nonatomic) UIButton *viewKeywordBtn;
@property ( nonatomic) BOOL isSelf;
@property (strong, nonatomic) FBProfilePictureView *profilePicView;
@property (strong, nonatomic) UIView *headerView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    self.predicate = [NSPredicate predicateWithFormat:@"fbID1 == %@ OR fbID2 == %@ OR fbID3 == %@", _user.fbID, _user.fbID, _user.fbID];
    [super viewDidLoad];
    [self prepareHeaderView];
//    [self initiateCreateQuizViewController];
    [self setNavbarTitle];
    if(!_profilePicView){
        [self initFBProfilePicViews];
    }
    self.delegate = self;
    //profileview
    self.tableView.tableHeaderView = _headerView;
    
}

-(void)addTextFieldAndButtons{

}


-(void) viewKeywordBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"KeywordListViewControllerSegue" sender:_user.keywords];
}

-(void) initFBProfilePicViews{
    _profilePicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    _profilePicView.layer.cornerRadius = 25.0f;
    _profilePicView.layer.masksToBounds = YES;
    [self.view addSubview:_profilePicView];
    _profilePicView.profileID = _user.fbID;
}

//-(void)setNavigationAttributes{

//}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [[myNavBar topItem] setTitle:[Utility getNameToDisplay:_user.name]];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleOrange]];
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

-(void) prepareHeaderView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 30)];
    _viewKeywordBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 120, 80, 20)];
    [_viewKeywordBtn setTitle:@"view all" forState:UIControlStateNormal];
    [_viewKeywordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _statusTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 70, 100, 20)];
    [_statusTextField setText:@""];
    _statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 70, 40, 20)];
    [_statusTextField setDelegate:self];
    [_statusBtn setTitle:@"send" forState:UIControlStateNormal];
    [_statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusBtn setTag:SEND_BUTTON_TAG];
    [_statusTextField setBorderStyle:UITextBorderStyleLine];
    
    [_statusBtn addTarget:self action:@selector(sendStatusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_viewKeywordBtn addTarget:self action:@selector(viewKeywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_headerView.layer setBorderWidth:5.0f];
    [_headerView addSubview:_nameLabel];
    [_headerView addSubview:_statusTextField];
    [_headerView addSubview:_statusBtn];
    [_headerView addSubview:_viewKeywordBtn];
}

-(void)setByUserObject:(User *)user sentFromTabbar:(BOOL)isSentFromTabbar {
    _user = user;
    [self setUserInformation:isSentFromTabbar];
}
-(void) setName:(NSString *)name andID:(NSString *)fbid sentFromTabbar:(BOOL) isSentFromTabbar{
    User *user = nil;
    if (![User findOrCreateUserForName:name withfbID:fbid returnAsEntity:&user
                inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext])
    {
        MBError(@"Cannot find or create the user (id: %@, name: %@)", name, fbid);
        return;
    }
    _user = user;
    [self setUserInformation:isSentFromTabbar];
}

-(void) setUserInformation:(BOOL) isSentFromTabbar{
    NSString *selfFBID = [KeyChainWrapper getSelfFBID];
    
    if(!_profilePicView){
        [self initFBProfilePicViews];
    }
    _profilePicView.profileID = _user.fbID;
    //    [self setNavbarTitle];
    //    [self setTitle:[Utility getNameToDisplay:name]];
    //    [_nameLabel setText:[Utility getNameToDisplay:name]];
    _isSelf = ([_user.fbID isEqualToString:selfFBID])? TRUE : FALSE;
    if(_isSelf){
        [self setTitle:[Utility getNameToDisplay:_user.name]];
        [_statusTextField setEnabled:YES];
    } else{
        if(!isSentFromTabbar){
            [self setTitle:[Utility getNameToDisplay:_user.name]];
        }
        [_statusTextField setEnabled:NO];
        for(id view in _headerView.subviews){
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
    
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[[KeyChainWrapper getSessionTokenForUser], _user.fbID]
                                   forKeys:@[@"auth_token", @"fb_id"]];

    [[RKObjectManager sharedManager]
     getObject:_user
     path:nil //previously defined Class routes
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         MBDebug(@"status result: %@", [mappingResult array]);
         if([_user isKindOfClass:[User class]]){
             [_statusTextField setText:_user.status];
             [self displayKeywords];
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         MBDebug(@"failed to get status");
     }];
}

-(void) displayKeywords{
    if(_user.keywords){
        if([_user.keywords isKindOfClass:[NSString class]]){
            NSString *keyword = (NSString *)_user.keywords;
            NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
            [self addKeywordLabelAtX:100 andY:100 withKeyword:keywordString atIndex:-1];
        } else if([_user.keywords isKindOfClass:[NSArray class]]){
            NSArray *keywordArray = (NSArray *)_user.keywords;
            int x = 40;
            int y = 100;
            for(NSString *keyword in keywordArray){
                NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
                [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:[keywordArray indexOfObject:keyword]];
                x+= keywordString.size.width + 20;
                if(x>250){
                    x=40;
                    y+=20;
                }
            }
        }
    }
}

-(void) addKeywordLabelAtX:(int)x andY:(int)y withKeyword:(NSAttributedString *)string atIndex:(NSInteger)index{
    UIButton *keywordBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, string.size.width, string.size.height)];
    [keywordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [keywordBtn setAttributedTitle:string forState:UIControlStateNormal];
    [keywordBtn setTag:index];
    [keywordBtn addTarget:self action:@selector(keywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:keywordBtn];
}

-(void) keywordBtnClicked:(id)sender{
    NSString *keyword;
    if([sender tag] == -1){
        keyword = (NSString *)_user.keywords;
    } else{
        keyword = [_user.keywords objectAtIndex:[sender tag]];
    }
    [self performSegueWithIdentifier:@"KeywordProfileViewControllerSegue" sender:keyword];
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
    NSLog(@"segue %@", [[segue destinationViewController] class]);
    if([[segue destinationViewController] isKindOfClass:[KeywordListViewController class]]){
        KeywordListViewController *keywordListViewController =[segue destinationViewController];
        [keywordListViewController setKeywords:sender];
    } else if([[segue destinationViewController] isKindOfClass:[ProfileViewController class]]){
         if([sender isKindOfClass:[NSArray class]]){
         ProfileViewController *viewController =[segue destinationViewController];
             [viewController setName:(NSString *)[sender firstObject] andID:[sender objectAtIndex:1] sentFromTabbar:NO];
         }
    } else if([[segue destinationViewController] isKindOfClass:[KeywordProfileViewController class]]){
        KeywordProfileViewController *viewController =[segue destinationViewController];
        [viewController setKeyword:sender];
    }
}

#pragma mark -
#pragma mark PostViewController Delegate Methods
-(void) postSelected:(NSString *)name andID:(NSString *)fbid{
    NSArray *infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:infoBundle];
}

@end
