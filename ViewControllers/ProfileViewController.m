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
#import "SVPullToRefresh.h"

#define SEND_BUTTON_TAG 116
#define GOLDEN_LEFT_ALIGNMENT 130
#define GRAY_Y 26
#define HEADER_VIEW_HEIGHT_WITH_KEYWORDS 195
#define HEADER_VIEW_HEIGHT_WITHOUT_KEYWORDS 150


@interface ProfileViewController ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) PostsViewController *postsViewController;
@property (strong, nonatomic) UITextView *statusTextView;
@property (strong, nonatomic) UIButton *statusBtn;
@property (strong, nonatomic) UIButton *viewKeywordBtn;
@property ( nonatomic) BOOL isSelf;
@property (strong, nonatomic) FBProfilePictureView *profilePicView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *createdNumLabel;
@property (strong, nonatomic) UILabel *receivedNumLabel;
@property (strong, nonatomic) UILabel *solvedNumLabel;
@property (strong, nonatomic) UIView *keywordsView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    self.predicate = [NSPredicate predicateWithFormat:@"fbID1 == %@ OR fbID2 == %@ OR fbID3 == %@", _user.fbID, _user.fbID, _user.fbID];
    self.basicParams =  @{@"fb_id": _user.fbID};
    
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
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTableView)]];
    
}

-(void)addTextFieldAndButtons{

}

-(void)tappedTableView{
    [_statusTextView resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
}

-(void) removeAllKeywords{
    for(UIView *view in _keywordsView.subviews){
        [view removeFromSuperview];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    MBDebug(@"view did appear for %@", _user.name);
    [self setNavbarTitle];
}

-(void) viewKeywordBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"KeywordListViewControllerSegue" sender:_user.keywords];
}

-(void) initFBProfilePicViews{
    _profilePicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(20, 15, 100, 100)];
    _profilePicView.layer.cornerRadius = _profilePicView.frame.size.width/2.0f;
    _profilePicView.layer.masksToBounds = YES;
    _profilePicView.profileID = _user.fbID;
}

//-(void)setNavigationAttributes{

//}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [myNavBar setTitleTextAttributes:[Utility getNavigationBarTitleFontDictionary]];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareHeaderView{
    int height = (_user.keywords)? HEADER_VIEW_HEIGHT_WITH_KEYWORDS: HEADER_VIEW_HEIGHT_WITHOUT_KEYWORDS;
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    [_headerView setBackgroundColor:[UIColor whiteColor]];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT, 43, self.view.frame.size.width, 35)];
    NSAttributedString *nameString =[[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_user.name] attributes:[Utility getBigNameFontDictionary]];
    [_nameLabel setAttributedText:nameString];
    
    _viewKeywordBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 80, 20)];
    [_viewKeywordBtn setTitle:@"more" forState:UIControlStateNormal];
    [_viewKeywordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _statusTextView = [[UITextView alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT - 3, 70, self.view.frame.size.width - GOLDEN_LEFT_ALIGNMENT - 20, 40)];
    [_statusTextView setText:@""];
    [_statusTextView setScrollEnabled:NO];
    [_statusTextView setBackgroundColor:[UIColor clearColor]];
    if(_isSelf){
        [_statusTextView setEditable:YES];
        [_statusTextView setUserInteractionEnabled:YES];
    }else{
        [_statusTextView setEditable:NO];
        [_statusTextView setUserInteractionEnabled:NO];
    }

    _statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 110, 40, 20)];
    [_statusTextView setDelegate:self];
    [_statusBtn setTitle:@"edit" forState:UIControlStateNormal];
    [_statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_statusBtn addTarget:self action:@selector(sendStatusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_viewKeywordBtn addTarget:self action:@selector(viewKeywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [UIView addLeftBorderOn:_headerView withColor:[UIColor marbleLightGray] andWidth:5 andHeight:0 withOffset:5];
    [UIView addRightBorderOn:_headerView withColor:[UIColor marbleLightGray] andWidth:5 andHeight:0 withOffset:5];
    
    _keywordsView = [[UIView alloc] initWithFrame:CGRectMake(25, 125, self.view.frame.size.width, 50)];
    
    [_headerView addSubview:_keywordsView];
    
    [_headerView addSubview:_profilePicView];
    [_headerView.layer setBorderColor:[UIColor marbleLightGray].CGColor];
    [_headerView.layer setBorderWidth:5.0f];
    if(_isSelf){
        [_headerView addSubview:_statusBtn];
    }
    [self addGrayStaticLabels];
    [_headerView addSubview:_nameLabel];
    [_headerView addSubview:_statusTextView];
}

-(void)addGrayStaticLabels{
    NSAttributedString *createdString = [[NSAttributedString alloc] initWithString:@"created" attributes:[Utility getProfileGrayStaticFontDictionary]];
    NSAttributedString *receivedString = [[NSAttributedString alloc] initWithString:@"received" attributes:[Utility getProfileGrayStaticFontDictionary]];
    NSAttributedString *solvedString = [[NSAttributedString alloc] initWithString:@"solved" attributes:[Utility getProfileGrayStaticFontDictionary]];
    UILabel *createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT, GRAY_Y, createdString.size.width, createdString.size.height)];
    UILabel *receivedLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT + createdString.size.width + 15, GRAY_Y, receivedString.size.width, receivedString.size.height)];
    UILabel *solvedLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT + createdString.size.width + receivedString.size.width + 30, GRAY_Y, solvedString.size.width, solvedString.size.height)];
    [createdLabel setAttributedText:createdString];
    [receivedLabel setAttributedText:receivedString];
    [solvedLabel setAttributedText:solvedString];
    [_headerView addSubview:createdLabel];
    [_headerView addSubview:receivedLabel];
    [_headerView addSubview:solvedLabel];
    
    CGRect createdFrame = createdLabel.frame;
    createdFrame.origin.y = createdFrame.origin.y - 12;
    CGRect receivedFrame = receivedLabel.frame;
    receivedFrame.origin.y = receivedFrame.origin.y - 12;
    CGRect solvedFrame = solvedLabel.frame;
    solvedFrame.origin.y = solvedFrame.origin.y - 12;
    
    _createdNumLabel = [[UILabel alloc] initWithFrame:createdFrame];
    _receivedNumLabel = [[UILabel alloc] initWithFrame:receivedFrame];
    _solvedNumLabel = [[UILabel alloc] initWithFrame:solvedFrame];
    
    NSAttributedString *zeroString = [[NSAttributedString alloc] initWithString:@"0" attributes:[Utility getNotifBlackNormalFontDictionary]];
    
    [_createdNumLabel setAttributedText:zeroString];
    [_receivedNumLabel setAttributedText:zeroString];
    [_solvedNumLabel setAttributedText:zeroString];
    
    [_createdNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_receivedNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_solvedNumLabel setTextAlignment:NSTextAlignmentCenter];

    [_headerView addSubview:_createdNumLabel];
    [_headerView addSubview:_receivedNumLabel];
    [_headerView addSubview:_solvedNumLabel];
    
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
    
    NSAttributedString *nameString =[[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_user.name] attributes:[Utility getBigNameFontDictionary]];
    [_nameLabel setAttributedText:nameString];
    NSLog(@"profilename %@", _user.name);
    
    NSString *selfFBID = [KeyChainWrapper getSelfFBID];
    
    if(!_profilePicView){
        [self initFBProfilePicViews];
    }
    _profilePicView.profileID = _user.fbID;
    //    [self setNavbarTitle];
    //    [self setTitle:[Utility getNameToDisplay:name]];
    

    
    _isSelf = ([_user.fbID isEqualToString:selfFBID])? TRUE : FALSE;
    if(_isSelf){
//        if(!isSentFromTabbar){
//            [self setTitle:[Utility getNameToDisplay:_user.name]];
//        }
//        [self setTitle:[Utility getNameToDisplay:_user.name]];
        [_statusTextView setEditable:YES];
        [_statusTextView setUserInteractionEnabled:YES];
        [_headerView addSubview:_statusBtn];
    } else{
//        if(!isSentFromTabbar){
//            [self setTitle:[Utility getNameToDisplay:_user.name]];
//        }
        [_statusTextView setUserInteractionEnabled:NO];
        [_statusTextView setEditable:NO];
        [_statusBtn removeFromSuperview];
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
             [self setStatusWithText:_user.status];
             [self displayKeywords];
             [self setNumbersWithReceived:_user.received withCreated:_user.created withSolved:_user.solved];
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         MBDebug(@"failed to get status");
     }];
}



-(void) displayKeywords{
    [self removeAllKeywords];
    NSLog(@"_user.keywords %@ for _user %@", _user.keywords, _user.name);

    if(!_user.keywords){
        [self setNoKeywordsSetting];
        return;
    }
    CGRect headerFrame = _headerView.frame;
    headerFrame.size.height = HEADER_VIEW_HEIGHT_WITH_KEYWORDS;
    [_headerView setFrame:headerFrame];
    [self.tableView setTableHeaderView:_headerView];
    
    int x = 0;
    int y = 0;
    if([_user.keywords isKindOfClass:[NSString class]]){
        NSString *keyword = (NSString *)[_user.keywords objectAtIndex:1];
        NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [self addKeywordLabelAtX:100 andY:100 withKeyword:keywordString atIndex:-1];
    } else if([_user.keywords isKindOfClass:[NSArray class]]){
        NSArray *keywordArray = (NSArray *)_user.keywords;
        if([keywordArray count] == 0){
            [self setNoKeywordsSetting];
            return;
        }
        for(NSArray *obj in keywordArray){
            NSString *keyword = obj[1];
            NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
            int tempX = x + keywordString.size.width + 20;
            if(tempX >290){
                x=0;
                y+=30;
            }
            [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:[keywordArray indexOfObject:obj]];
            x += keywordString.size.width + 20; 
        }
    }
    if(x >260){
        x=0;
        y+=30;
    }
    MBDebug(@"moreframe %d %d", x, y);
    CGRect moreFrame = _viewKeywordBtn.frame;
    moreFrame.origin.x = x;
    moreFrame.origin.y = y;
    _viewKeywordBtn.frame = moreFrame;
    [_keywordsView addSubview:_viewKeywordBtn];
}

-(void) setNoKeywordsSetting{
    CGRect headerFrame = _headerView.frame;
    headerFrame.size.height = HEADER_VIEW_HEIGHT_WITHOUT_KEYWORDS;
    [_headerView setFrame:headerFrame];
    [self.tableView setTableHeaderView:_headerView];
    [_viewKeywordBtn removeFromSuperview];
}

- (void) setNumbersWithReceived:(NSNumber *)received withCreated:(NSNumber *)created withSolved:(NSNumber *)solved
{
    NSAttributedString *createdAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", created] attributes:[Utility getNotifBlackNormalFontDictionary]];
    NSAttributedString *receivedAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", received] attributes:[Utility getNotifBlackNormalFontDictionary]];
    NSAttributedString *solvedAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", solved] attributes:[Utility getNotifBlackNormalFontDictionary]];
    
    [_createdNumLabel setAttributedText:createdAttributedString];
    [_receivedNumLabel setAttributedText:receivedAttributedString];
    [_solvedNumLabel setAttributedText:solvedAttributedString];
}

-(void) setStatusWithText:(NSString *)status{
    if(!status){
        if(_isSelf){
            NSAttributedString *statusString =[[NSAttributedString alloc] initWithString:@"[update your status...]" attributes:[Utility getPostsViewCommentFontDictionary]];
            [_statusTextView setAttributedText:statusString];
            return;
        } else{
            [_statusTextView setText:@""];
            return;
        }
    }
    NSLog(@"status %@", status);
    NSAttributedString *statusString =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"",_user.status] attributes:[Utility getProfileStatusFontDictionary]];
    [_statusTextView setAttributedText:statusString];
}

-(void) addKeywordLabelAtX:(int)x andY:(int)y withKeyword:(NSAttributedString *)string atIndex:(NSInteger)index{
    UIButton *keywordBtn = [Utility getKeywordButtonAtX:x andY:y andString:string];
    [keywordBtn setTag:index];
    [keywordBtn addTarget:self action:@selector(keywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_keywordsView addSubview:keywordBtn];
}

-(void) keywordBtnClicked:(id)sender{
    NSString *keyword;
    if([sender tag] == -1){
        keyword = (NSString *)[_user.keywords objectAtIndex:1];
    } else{
        MBDebug(@"SELECTED KEYWORD: %@", [_user.keywords objectAtIndex:[sender tag]]);
        keyword = [[_user.keywords objectAtIndex:[sender tag]] objectAtIndex:1];
    }
    [self performSegueWithIdentifier:@"KeywordProfileViewControllerSegue" sender:keyword];
}

-(void) postSelected:(NSString *)name{
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:name];
}

-(void) sendStatusBtnClicked
{
    if([_statusTextView isFirstResponder]){
        NSString *status = _statusTextView.text;
        MBDebug(@"To send status: %@", status);
        [Utility sendThroughRKRoute:@"send_status" withParams:@{@"status": status}];
        [self getStatus];
        [_statusTextView resignFirstResponder];
        [self.tableView triggerPullToRefresh];
    } else{
        [_statusTextView becomeFirstResponder];
    }

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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @" "
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    

    
    
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

#pragma mark -
#pragma mark TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *) textView
{
    [textView setText:@""];
    [textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [textView.layer setBorderWidth:0.5];
    
    //The rounded corner part, where you specify your view's corner radius:
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    [_statusBtn setTitle:@"send" forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    [_statusBtn setTitle:@"edit" forState:UIControlStateNormal];
    [self setStatusWithText:_user.status];
    [textView.layer setBorderWidth:0];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
