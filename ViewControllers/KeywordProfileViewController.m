//
//  KeywordProfileViewController.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordProfileViewController.h"
#import "MarbleTabBarController.h"

#define RANKING_NAME_KEY @"name"
#define RANKING_FBID_KEY @"fbid"

@interface KeywordProfileViewController()
@property (strong, nonatomic) NSDictionary *ranking;
@property (strong, nonatomic) NSString *creatorName;
@property (strong, nonatomic) NSString *creatorFBID;
@property (strong, nonatomic) NSString *timePlayed;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIImageView *rank1ImageView;
@property (strong, nonatomic) UIImageView *rank2ImageView;
@property (strong, nonatomic) UIImageView *rank3ImageView;

@property (strong, nonatomic) UIImageView *creatorImageView;
@property (strong, nonatomic) UIButton *creatorNameButton;

@property (strong, nonatomic) UIButton *rank1NameButton;
@property (strong, nonatomic) UIButton *rank2NameButton;
@property (strong, nonatomic) UIButton *rank3NameButton;

@property(strong, nonatomic) UILabel *timePlayedLabel;
@property(strong, nonatomic) UILabel *rank0Label;
@property(strong, nonatomic) UILabel *rank1Label;
@property(strong, nonatomic) UILabel *rank2Label;

@property (strong, nonatomic) UIView *whiteView;


@end

@implementation KeywordProfileViewController

- (void)viewDidLoad {
    self.predicate = [NSPredicate predicateWithFormat:@"keyword1 == %@ OR keyword2 == %@ OR keyword3 == %@", _keyword, _keyword, _keyword];
    self.basicParams =  @{@"keyword": _keyword};

    [super viewDidLoad];
    [self setNavbarTitle];
//    self.delegate = self;
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.tableView.contentInset = UIEdgeInsetsMake( CELL_UNIVERSAL_PADDING/2.0f, 0, CELL_UNIVERSAL_PADDING/2.0f, 0);
    [self prepareHeaderView];
    [self initRankingUI];
    self.tableView.tableHeaderView = _headerView;
    [self.tableView.tableHeaderView setClipsToBounds:YES];
    [self getKeywordFromServer];
}

- (void)getKeywordFromServer
{
    if (![KeyChainWrapper isSessionTokenValid]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[_keyword, [KeyChainWrapper getSessionTokenForUser]]
                                                                     forKeys:@[@"keyword", @"auth_token"]];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    requestWithPathForRouteNamed:@"get_keyword"
                                    object:self
                                    parameters:params];
    
    RKHTTPRequestOperation *operation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        MBDebug(@"Fetched keyword");
        NSDictionary *keyword = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
        MBDebug(@"HEY KEYWORD: %@", keyword);
        _creatorFBID = [keyword valueForKeyPath:@"creator.fb_id"];
        _creatorName = [keyword valueForKeyPath:@"creator.name"];
        _timePlayed = [keyword valueForKey:@"times"];
        MBDebug(@"Creator info: %@, %@", _creatorName, _creatorFBID);
        MBDebug(@"Time played: %@", _timePlayed);
        MBDebug(@"Ranking: %@", [keyword valueForKey:@"ranking"]);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSArray *obj in [keyword valueForKey:@"ranking"]){
            [dict setValue:@{RANKING_NAME_KEY: [obj[1] valueForKey:@"name"],
                             RANKING_FBID_KEY: [obj[1] valueForKey:@"fb_id"]} forKey:obj[0]];
        }
        _ranking = dict;
        [self updateLabels];
        [self updateRanking];
        MBDebug(@"Real Ranking: %@", _ranking);
        MBDebug(@"0th: %@", [[_ranking objectForKey:@0] objectForKey:@"fbID"]);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         ASYNC({
                                             [Utility generateAlertWithMessage:@"Network problem"];
                                         });
                                         MBError(@"Cannot fetch keyword!");
                                     }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

-(void) prepareHeaderView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 195)];
    [_headerView setBackgroundColor:[UIColor marbleBackGroundColor]];
    
    _whiteView = [[UIView alloc] init];
    [self resizeWhiteBackground];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    [UIView addBackgroundShadowOnView:_whiteView];
    [_headerView addSubview:_whiteView];
    
//    [UIView addLeftBorderOn:_headerView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0f andHeight:0 withOffset:CELL_UNIVERSAL_PADDING/2.0f];
//    [UIView addRightBorderOn:_headerView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0f andHeight:0 withOffset:CELL_UNIVERSAL_PADDING/2.0f];
//    [_headerView.layer setBorderColor:[UIColor marbleBackGroundColor].CGColor];
//    [_headerView.layer setBorderWidth:CELL_UNIVERSAL_PADDING/2.0f];
    
    CGFloat lineX = [KeyChainWrapper getScreenWidth]*0.59f;
    int lineY = 120;
    int lineWidth = 2;
    
    UIView *vertiLine = [[UIView alloc] initWithFrame:CGRectMake(lineX, 0, lineWidth, _headerView.frame.size.height)];
    [vertiLine setBackgroundColor:[UIColor marbleBackGroundColor]];
    [_headerView addSubview:vertiLine];
    UIView *horizLine = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, _headerView.frame.size.width - lineX, lineWidth)];
    [horizLine setBackgroundColor:[UIColor marbleBackGroundColor]];
    [_headerView addSubview:horizLine];
    
    NSAttributedString *overallString = [[NSAttributedString alloc] initWithString:@"overall friend ranking" attributes:[Utility getNotifBlackNormalFontDictionary]];
    UILabel *overallLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, 150, 20)];
    [overallLabel setAttributedText:overallString];
    [_headerView addSubview:overallLabel];
    
    CGFloat creatorX = [KeyChainWrapper getScreenWidth]*0.78 - 30;
    NSAttributedString *createdByString = [[NSAttributedString alloc] initWithString:@"created by" attributes:[Utility getNotifBlackNormalFontDictionary]];
    UILabel *createdByLabel = [[UILabel alloc] initWithFrame:CGRectMake(creatorX, 12, 100, 20)];
    [createdByLabel setAttributedText:createdByString];
    [_headerView addSubview:createdByLabel];
    
    _creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(creatorX, 30, 58, 58)];
    [_creatorImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatorNameButtonClicked:)]];
    [_creatorImageView setUserInteractionEnabled:YES];
    _creatorImageView.layer.cornerRadius = _creatorImageView.frame.size.width/2.0f;
    _creatorImageView.layer.masksToBounds = YES;
    _creatorNameButton = [[UIButton alloc] initWithFrame:CGRectMake(lineX, 90, self.view.frame.size.width - lineX - 10, 20)];
    [_creatorNameButton addTarget:self action:@selector(creatorNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_creatorNameButton];
    [_headerView addSubview:_creatorImageView];
    
    NSAttributedString *timesPlayedString = [[NSAttributedString alloc] initWithString:@"times played" attributes:[Utility getProfileGrayStaticFontDictionary]];
    UILabel *timesPlayedStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(creatorX - 20, 150, 100, 20)];
    [timesPlayedStringLabel setAttributedText:timesPlayedString];
    [timesPlayedStringLabel setTextAlignment:NSTextAlignmentCenter];
    [_headerView addSubview:timesPlayedStringLabel];
    
    _timePlayedLabel = [[UILabel alloc] initWithFrame:CGRectMake(creatorX - 20, 136, 100, 20)];
    [_headerView addSubview:_timePlayedLabel];
    
}

-(void)resizeWhiteBackground{
    int myHeight = _headerView.frame.size.height;
    
    _whiteView.frame = CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.0f, self.view.bounds.size.width - 2*CELL_UNIVERSAL_PADDING, myHeight - CELL_UNIVERSAL_PADDING);
}

-(void) initRankingUI{
    const int RANKING_Y_START = 40;
    const int IMAGE_LEFT_ALIGN = 50;
    const int RANKING_Y_INCREMENT = 50;
    const int IMAGE_SIZE = 40;
    CGFloat lineX = [KeyChainWrapper getScreenWidth]*0.59f;

    
    for(int i = 0; i < 3; i++) {
        NSAttributedString *rankNum = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"#%d",i+1] attributes:[Utility getNotifBlackBoldFontDictionary]];
        switch (i) {
            case 0:
                _rank0Label = [[UILabel alloc] initWithFrame:CGRectMake(30, RANKING_Y_START + i*RANKING_Y_INCREMENT + 12, 20, 20)];
                [_rank0Label setAttributedText:rankNum];
                [_headerView addSubview:_rank0Label];
                break;
            case 1:
                _rank1Label = [[UILabel alloc] initWithFrame:CGRectMake(30, RANKING_Y_START + i*RANKING_Y_INCREMENT + 12, 20, 20)];
                [_rank1Label setAttributedText:rankNum];
                [_headerView addSubview:_rank1Label];
                break;
            default:
                _rank2Label = [[UILabel alloc] initWithFrame:CGRectMake(30, RANKING_Y_START + i*RANKING_Y_INCREMENT + 12, 20, 20)];
                [_rank2Label setAttributedText:rankNum];
                [_headerView addSubview:_rank2Label];
                break;
                break;
        }
    }
    
    CGFloat imageWidth = lineX - (IMAGE_LEFT_ALIGN + IMAGE_SIZE + 3);
    _rank1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + IMAGE_SIZE + 3, RANKING_Y_START + 10, imageWidth, 20)];
    [_rank1NameButton setTag:0];
    _rank2NameButton = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + IMAGE_SIZE + 3, RANKING_Y_START + RANKING_Y_INCREMENT + 10, imageWidth, 20)];
    [_rank2NameButton setTag:1];
    _rank3NameButton = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + IMAGE_SIZE + 3, RANKING_Y_START + RANKING_Y_INCREMENT*2 + 10, imageWidth, 20)];
    [_rank3NameButton setTag:2];
    [_rank1NameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_rank2NameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_rank3NameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_rank1NameButton addTarget:self action:@selector(rankNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rank2NameButton addTarget:self action:@selector(rankNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rank3NameButton addTarget:self action:@selector(rankNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _rank1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN, RANKING_Y_START, IMAGE_SIZE, IMAGE_SIZE)];
    _rank2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN, RANKING_Y_START + RANKING_Y_INCREMENT, IMAGE_SIZE, IMAGE_SIZE)];
    _rank3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN, RANKING_Y_START + 2*RANKING_Y_INCREMENT, IMAGE_SIZE, IMAGE_SIZE)];
    
    [_rank1ImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rank1NameButtonClicked)]];
    [_rank2ImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rank2NameButtonClicked)]];
    [_rank3ImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rank3NameButtonClicked)]];
    
    [_rank1ImageView setUserInteractionEnabled:YES];
    [_rank2ImageView setUserInteractionEnabled:YES];
    [_rank3ImageView setUserInteractionEnabled:YES];
    
    _rank1ImageView.layer.cornerRadius = IMAGE_SIZE/2.0f;
    _rank1ImageView.layer.masksToBounds = YES;
    _rank2ImageView.layer.cornerRadius = IMAGE_SIZE/2.0f;
    _rank2ImageView.layer.masksToBounds = YES;
    _rank3ImageView.layer.cornerRadius = IMAGE_SIZE/2.0f;
    _rank3ImageView.layer.masksToBounds = YES;
    
    [_headerView addSubview:_rank1ImageView];
    [_headerView addSubview:_rank2ImageView];
    [_headerView addSubview:_rank3ImageView];
    [_headerView addSubview:_rank1NameButton];
    [_headerView addSubview:_rank2NameButton];
    [_headerView addSubview:_rank3NameButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
}

-(void)viewDidAppear:(BOOL)animated{
    [self setNavbarTitle];
    if([self.tabBarController isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *tabbarcontroller = (MarbleTabBarController *)self.tabBarController;
        tabbarcontroller.lookingAtEitherUserOrKeyword = _keyword;
    }
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [myNavBar setTitleTextAttributes:[Utility getNavigationBarTitleFontDictionary]];
    [[myNavBar topItem] setTitle:[NSString stringWithFormat:@"\"%@\"", _keyword]];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self setTitle:title];
}

-(void)updateLabels{
    if(_creatorFBID){
        [Utility setUpProfilePictureImageView:_creatorImageView byFBID:_creatorFBID];
    } else{
        [_creatorImageView setImage:[UIImage imageNamed:MARBLE_IMAGE_NAME]];
    }
    if(_creatorName){
        NSAttributedString *creatorNameString = [[NSAttributedString alloc] initWithString:_creatorName attributes:[Utility getPostsViewNameFontDictionary]];
        [_creatorNameButton setAttributedTitle:creatorNameString forState:UIControlStateNormal];
    }
    if(_timePlayed){
        NSAttributedString *timeplayString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _timePlayed] attributes:[Utility getNotifBlackNormalFontDictionary]];
        [_timePlayedLabel setAttributedText:timeplayString];
        [_timePlayedLabel setTextAlignment:NSTextAlignmentCenter];
    }
}

-(void)updateRanking{
    [self updateRankingImageViews];
    [self updateRankingNameButton];
}

-(void)updateRankingImageViews{
    NSString *rank1fbID = [[_ranking objectForKey:@0] objectForKey:RANKING_FBID_KEY];
    if(rank1fbID){
        [Utility setUpProfilePictureImageView:_rank1ImageView byFBID:rank1fbID];
        [_rank1ImageView setUserInteractionEnabled:YES];
    }else{
        [_rank0Label setHidden:YES];
        [_rank1ImageView setUserInteractionEnabled:NO];
    }
    NSString *rank2fbID = [[_ranking objectForKey:@1] objectForKey:RANKING_FBID_KEY];
    if(rank2fbID){
        [Utility setUpProfilePictureImageView:_rank2ImageView byFBID:rank2fbID];
        [_rank2ImageView setUserInteractionEnabled:YES];
    }else{
        [_rank1Label setHidden:YES];
        [_rank2ImageView setUserInteractionEnabled:NO];
    }
    NSString *rank3fbID = [[_ranking objectForKey:@2] objectForKey:RANKING_FBID_KEY];
    if(rank3fbID){
        [Utility setUpProfilePictureImageView:_rank3ImageView byFBID:rank3fbID];
        [_rank3ImageView setUserInteractionEnabled:YES];
    }else{
        [_rank2Label setHidden:YES];
        [_rank3ImageView setUserInteractionEnabled:NO];
    }
}

-(void)updateRankingNameButton{
    NSString *rank1Name = [[_ranking objectForKey:@0] objectForKey:RANKING_NAME_KEY];
    if(rank1Name){
        NSAttributedString *rank1NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:rank1Name] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank1NameButton setAttributedTitle:rank1NameString forState:UIControlStateNormal];
        [_rank1NameButton setEnabled:YES];
    }else{
        [_rank1NameButton setEnabled:NO];
    }
    NSString *rank2Name = [[_ranking objectForKey:@1] objectForKey:RANKING_NAME_KEY];
    if(rank2Name){
        NSAttributedString *rank2NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:rank2Name] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank2NameButton setAttributedTitle:rank2NameString forState:UIControlStateNormal];
        [_rank2NameButton setEnabled:YES];
    }else{
        [_rank2NameButton setEnabled:NO];
    }
    NSString *rank3Name = [[_ranking objectForKey:@2] objectForKey:RANKING_NAME_KEY];
    if(rank3Name){
        NSAttributedString *rank3NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:rank3Name] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank3NameButton setAttributedTitle:rank3NameString forState:UIControlStateNormal];
        [_rank3NameButton setEnabled:YES];
    }else{
        [_rank3NameButton setEnabled:NO];
    }

}

-(void)rank1NameButtonClicked{
    [self rankNameButtonClicked:[NSNumber numberWithInt:0]];
}
-(void)rank2NameButtonClicked{
    [self rankNameButtonClicked:[NSNumber numberWithInt:1]];
}
-(void)rank3NameButtonClicked{
    [self rankNameButtonClicked:[NSNumber numberWithInt:2]];
}
-(void)rankNameButtonClicked:(id)sender{
    int rankNum;
    if([sender isKindOfClass:[NSNumber class]]){
        rankNum = (int)[sender integerValue];
    }else{
        rankNum = (int)[sender tag];
    }
    NSNumber *number = [[NSNumber alloc] initWithInt:rankNum];
    NSString *name = [[_ranking objectForKey:number] objectForKey:RANKING_NAME_KEY];
    NSString *fbid = [[_ranking objectForKey:number] objectForKey:RANKING_FBID_KEY];
    NSArray *infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:infoBundle];
}


-(void)creatorNameButtonClicked:(id)sender{
    NSArray *infoBundle = [NSArray arrayWithObjects:_creatorName,_creatorFBID, nil];
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:infoBundle];
}



-(void) setKeyword:(NSString *)keyword{
    _keyword = keyword;
}

@end
