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
#import "MarbleTabBarController.h"
#import "UIColor+MBColor.h"
#import <QuartzCore/QuartzCore.h>


#define SEND_BUTTON_TAG 116
#define GOLDEN_LEFT_ALIGNMENT 130
#define GRAY_Y 30
#define HEADER_VIEW_HEIGHT_WITH_KEYWORDS 200
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
@property (strong, nonatomic) UIView *whiteView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    self.predicate = [NSPredicate predicateWithFormat:@"fbID1 == %@ OR fbID2 == %@ OR fbID3 == %@", _user.fbID, _user.fbID, _user.fbID];
    self.basicParams =  @{@"fb_id": _user.fbID};
    
    [super viewDidLoad];
    [self prepareHeaderView];
//    [self initiateCreateQuizViewController];
//    [self setNavbarTitle];
    if(!_profilePicView){
        [self initFBProfilePicViews];
    }
    //profileview
    self.tableView.tableHeaderView = _headerView;
    [self.tableView.tableHeaderView setClipsToBounds:YES];

    
}

-(void)addTextFieldAndButtons{

}

-(void)tappedTableView{
    [_statusTextView resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
    MBDebug(@"profile view will appeared called");
    [self getStatus];
}



-(void) removeAllKeywords{
    for(UIView *view in _keywordsView.subviews){
        [view removeFromSuperview];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    MBDebug(@"view did appear for %@", _user.name);
    [self setNavbarTitle];
    if([self.tabBarController isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *tabbarcontroller = (MarbleTabBarController *)self.tabBarController;
        tabbarcontroller.lookingAtEitherUserOrKeyword = _user;
    }
    [super viewDidAppear:animated];
}

-(void) viewKeywordBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"KeywordListViewControllerSegue" sender:[NSNumber numberWithLong:0]];
}

-(void) initFBProfilePicViews{
    _profilePicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(25, 20, 100, 100)];
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
    [_headerView setBackgroundColor:[UIColor marbleBackGroundColor]];
    [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTableView)]];
    _whiteView = [[UIView alloc] init];
    [self resizeWhiteBackground];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    [UIView addBackgroundShadowOnView:_whiteView];
    [_headerView addSubview:_whiteView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT + 10, 50, self.view.frame.size.width, 35)];

    
    if(_isSelf == true || _user.status){
        [_nameLabel removeFromSuperview];
        
    }else{
        NSAttributedString *nameString =[[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_user.name] attributes:[Utility getBigNameFontDictionary]];
        [_nameLabel setAttributedText:nameString];
        [_headerView addSubview:_nameLabel];
    }
    
    _viewKeywordBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 15, 80, 20)];
    NSAttributedString *moreString = [[NSAttributedString alloc] initWithString:@"more >>" attributes:[Utility getProfileMoreFontDictionary]];
    [_viewKeywordBtn setAttributedTitle:moreString forState:UIControlStateNormal];
    [_viewKeywordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_viewKeywordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _statusTextView = [[UITextView alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT - 3, 70, [KeyChainWrapper getScreenWidth] - GOLDEN_LEFT_ALIGNMENT - 20 -33, 40)];
    [_statusTextView setText:@""];
    [_statusTextView setScrollEnabled:NO];
    [_statusTextView setReturnKeyType:UIReturnKeySend];
    [_statusTextView setBackgroundColor:[UIColor clearColor]];
    if(_isSelf){
        [_statusTextView setEditable:YES];
        [_statusTextView setUserInteractionEnabled:YES];
    }else{
        [_statusTextView setEditable:NO];
        [_statusTextView setUserInteractionEnabled:NO];
    }

    _statusBtn = [[UIButton alloc] initWithFrame:[self getSendStatusBtnFrame]];
    [_statusTextView setDelegate:self];
//    [_statusBtn setTitle:@"edit" forState:UIControlStateNormal];
//    [_statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusBtn setImage:[UIImage imageNamed:@"pen_icon.png"] forState:UIControlStateNormal];
    
    [_statusBtn addTarget:self action:@selector(sendStatusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_viewKeywordBtn addTarget:self action:@selector(viewKeywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [UIView addLeftBorderOn:_headerView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:0 withOffset:CELL_UNIVERSAL_PADDING/2.0];
//    [UIView addRightBorderOn:_headerView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:0 withOffset:CELL_UNIVERSAL_PADDING/2.0];
//    
    _keywordsView = [[UIView alloc] initWithFrame:CGRectMake(25, 130, self.view.frame.size.width, 50)];
    
    [_headerView addSubview:_keywordsView];
    
    [_headerView addSubview:_profilePicView];
//    [_headerView.layer setBorderColor:[UIColor marbleBackGroundColor].CGColor];
//    [_headerView.layer setBorderWidth:CELL_UNIVERSAL_PADDING/2.0];
    if(_isSelf){
        [_headerView addSubview:_statusBtn];
    }
    [self addGrayStaticLabels];
    [_headerView addSubview:_statusTextView];
}

-(void)resizeWhiteBackground{
    int myHeight = (_user.keywords)? HEADER_VIEW_HEIGHT_WITH_KEYWORDS: HEADER_VIEW_HEIGHT_WITHOUT_KEYWORDS;
    
    _whiteView.frame = CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.0f, [KeyChainWrapper getScreenWidth] - 2*CELL_UNIVERSAL_PADDING, myHeight - CELL_UNIVERSAL_PADDING);
}

-(void)addGrayStaticLabels{
    NSAttributedString *createdString = [[NSAttributedString alloc] initWithString:@"compared" attributes:[Utility getProfileGrayStaticFontDictionary]];
    NSAttributedString *receivedString = [[NSAttributedString alloc] initWithString:@"received" attributes:[Utility getProfileGrayStaticFontDictionary]];
    NSAttributedString *solvedString = [[NSAttributedString alloc] initWithString:@"correct" attributes:[Utility getProfileGrayStaticFontDictionary]];
    UILabel *createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT, GRAY_Y, createdString.size.width, createdString.size.height)];
    UILabel *receivedLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT + createdString.size.width + 12, GRAY_Y, receivedString.size.width, receivedString.size.height)];
    UILabel *solvedLabel = [[UILabel alloc] initWithFrame:CGRectMake(GOLDEN_LEFT_ALIGNMENT + createdString.size.width + receivedString.size.width + 24, GRAY_Y, solvedString.size.width, solvedString.size.height)];
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
        MBError(@"Cannot find or create the user (id: %@, name: %@)", fbid,name);
        return;
    }
    _user = user;
    [self setUserInformation:isSentFromTabbar];
}

-(void) setUserInformation:(BOOL) isSentFromTabbar{
    if(_isSelf == true || _user.status){
        [_nameLabel removeFromSuperview];

    }else{
        NSAttributedString *nameString =[[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_user.name] attributes:[Utility getBigNameFontDictionary]];
        [_nameLabel setAttributedText:nameString];
        [_headerView addSubview:_nameLabel];
    }
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
//    [self getStatus];
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
    MBDebug(@"About to get user object: %@", _user.name);
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionaryWithObjects:@[[KeyChainWrapper getSessionTokenForUser], _user.fbID]
                                   forKeys:@[@"auth_token", @"fb_id"]];

    [[RKObjectManager sharedManager]
     getObject:_user
     path:nil //previously defined Class routes
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//         MBDebug(@"status result: %@", [mappingResult array]);
         if([_user isKindOfClass:[User class]]){
             [self setStatusWithText:_user.status];
             [self displayKeywords];
             [self setNumbersWithReceived:_user.received withCreated:_user.created withSolved:_user.solved];
             if(_user.status){
                 [_nameLabel removeFromSuperview];
             }
         }
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         MBDebug(@"failed to get user fb id: %@", _user.fbID);
     }];
}



-(void) displayKeywords{
    [self removeAllKeywords];
//    NSLog(@"_user.keywords %@ for _user %@", _user.keywords, _user.name);
    [self resizeWhiteBackground];

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
        [self addKeywordLabelAtX:100 andY:100 withKeyword:keyword atIndex:-1];
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
            //for too many keywords
            if(y > 30 || (x > 180 && y == 30)){
                break;
            }
            [self addKeywordLabelAtX:x andY:y withKeyword:keyword atIndex:[keywordArray indexOfObject:obj]];
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
    moreFrame.origin.y = y + 2;
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

    [_createdNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_receivedNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_solvedNumLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void) setStatusWithText:(NSString *)status{
    NSAttributedString *statusString;
    if(!status || [status isEqualToString:@""]){
        if(_user.status){
            statusString =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"",_user.status] attributes:[Utility getProfileStatusFontDictionary]];
            [_statusTextView setAttributedText:statusString];
        }else{
            if(_isSelf){
                statusString =[[NSAttributedString alloc] initWithString:@"[update status]" attributes:[Utility getProfileUpdateStatusFontDictionary]];
                [_statusTextView setAttributedText:statusString];
            } else{
                [_statusTextView setText:@""];
            }
        }
    }else{
        NSLog(@"status %@", status);
        statusString =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"",status] attributes:[Utility getProfileStatusFontDictionary]];
        [_statusTextView setAttributedText:statusString];
    }
    CGRect btnframe = [self getSendStatusBtnFrame];
    CGFloat increment = (statusString.size.width < _statusTextView.frame.size.width)? statusString.size.width : _statusTextView.frame.size.width;
    btnframe.origin.x = _statusTextView.frame.origin.x + increment + 7;
    [_statusBtn setFrame:btnframe];
    
}

-(void) addKeywordLabelAtX:(int)x andY:(int)y withKeyword:(NSString *)string atIndex:(NSInteger)index{
    UIButton *keywordBtn = [Utility getKeywordButtonAtX:x andY:y andString:string];
    [keywordBtn setTag:index];
    [keywordBtn addTarget:self action:@selector(keywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_keywordsView addSubview:keywordBtn];
}




-(void) keywordBtnClicked:(id)sender{
    /*NSString *keyword;
    if([sender tag] == -1){
        keyword = (NSString *)[_user.keywords objectAtIndex:1];
    } else{
        MBDebug(@"SELECTED KEYWORD: %@", [_user.keywords objectAtIndex:[sender tag]]);
        keyword = [[_user.keywords objectAtIndex:[sender tag]] objectAtIndex:1];
    }*/
    NSNumber *index = [NSNumber numberWithLong:[sender tag]];
    [self performSegueWithIdentifier:@"KeywordListViewControllerSegue" sender:index];
}

-(void) postSelected:(NSString *)name{
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:name];
}

-(void) sendStatusBtnClicked
{
    if([_statusTextView isFirstResponder]){
        NSString *status = _statusTextView.text;
        if(![status isEqualToString:@""]){
            MBDebug(@"To send status: %@", status);
            [Utility sendThroughRKRoute:@"send_status" withParams:@{@"status": status}
                           successBlock:^{
                               [self getStatus];
                           }
                    failureBlock:^{MBError(@"Did not send successfully");}];
            [_statusTextView resignFirstResponder];
            [self.tableView triggerPullToRefresh];
        }
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
        [keywordListViewController setKeywords:_user.keywords withCollapseIndex:sender];
        keywordListViewController.subject = _user;
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

-(CGRect)getSendStatusBtnFrame{
    return CGRectMake([KeyChainWrapper getScreenWidth] - 50, 70, 35, 35);
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
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:@"y" attributes:[Utility getProfileStatusFontDictionary]];
    [textView setAttributedText:defaultText];
    [textView setText:@""];
    [textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [textView.layer setBorderWidth:0.5];
    
    //The rounded corner part, where you specify your view's corner radius:
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    [_statusBtn setImage:[UIImage imageNamed:@"send-border.png"] forState:UIControlStateNormal];
    [_statusBtn setFrame:[self getSendStatusBtnFrame]];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    [self setStatusWithText:textView.text];
    [textView.layer setBorderWidth:0];
    [_statusBtn setImage:[UIImage imageNamed:@"pen_icon.png"] forState:UIControlStateNormal];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self sendStatusBtnClicked];
        return NO;
    }
    
        
    // limit the number of lines in textview
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    // pretend there's more vertical space to get that extra line to check on
    CGSize tallerSize = CGSizeMake(textView.frame.size.width-15, textView.frame.size.height*2);
    
    CGRect newSize = [newText boundingRectWithSize:tallerSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[Utility getProfileStatusFontDictionary] context:nil];
//    CGSize newSize = [newText sizeWithFont:textView.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (newSize.size.height > textView.frame.size.height)
    {
        NSLog(@"two lines are full");
        return NO;
    }

    
    
    return YES;
}





@end
