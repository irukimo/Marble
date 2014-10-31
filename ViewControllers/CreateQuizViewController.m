//
//  CreateQuizViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//


#import "CreateQuizViewController.h"

#import "FacebookSDK/FacebookSDK.h"
#import "User+MBUser.h"
#import "Quiz.h"
#import "Quiz+MBQuiz.h"
#import "Post+MBPost.h"
#import <QuartzCore/QuartzCore.h>

#define AUTO_COMPLETE_SELECT_VIEW_TAG 999

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;


//#import "TouchTextField.h"

@interface CreateQuizViewController ()

@property (strong, nonatomic) SelectPeopleViewController *selectPeopleViewController;
@property (strong, nonatomic) SelectKeywordViewController *selectKeywordViewController;

//@property (strong, nonatomic) UITextField *keywordTextField;
@property (strong, nonatomic) UITextField *option0NameTextField;
@property (strong, nonatomic) UITextField *option1NameTextField;
@property (strong, nonatomic) UIButton *shuffleAllBtn;
@property (strong, nonatomic) UIButton *shufflePeopleBtn;
@property (strong, nonatomic) UITextField *ongoingTextField;

@property (strong, nonatomic) NSString *keywordCurrentValue;
@property (strong, nonatomic) NSString *keywordStoreValue;

@property (strong, nonatomic) UIButton *chooseName1Btn;
@property (strong, nonatomic) UIButton *chooseName2Btn;
@property(nonatomic)CGPoint startPoint;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *currentUserfbID;
@property (strong, nonatomic) User *option0;
@property (strong, nonatomic) User *option1;
@property (strong, nonatomic) FBProfilePictureView *option0PicView;
@property (strong, nonatomic) FBProfilePictureView *option1PicView;



/*
@property (strong, nonatomic) UIButton *keywordLockBtn;
@property (strong, nonatomic) UIButton *option0LockBtn;
@property (strong, nonatomic) UIButton *option1LockBtn;
@property (nonatomic) BOOL keywordIsLocked;
@property (nonatomic) BOOL option0IsLocked;
@property (nonatomic) BOOL option1IsLocked;
 */


@property (nonatomic, strong) NSMutableArray *keywordArray;
@end

@implementation CreateQuizViewController

-(instancetype) init{
    self = [super init];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.


    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    _keywordArray = [[self defaultKeyword] mutableCopy];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addTextFields];
    [self addShuffleButtons];
//    [self addPeopleButtons];
    [self initFBProfilePicViews];
//    [self addLockBtns];
//    [self.view setAlpha:0.5f];
    
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)]];
    
    [self recordData];
    [self setCurrentUserValues];
    
    [self initSwipeFunction];
    [self initExitButton];
    
    [self setOption0Option1];

}

-(void) prepareSelectPeopleViewController{
    _selectPeopleViewController = [[SelectPeopleViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectPeopleViewController.view.frame = [self getSearchRect];
    _selectPeopleViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectPeopleViewController.delegate = self;
    [self.view addSubview:_selectPeopleViewController.view];
}

-(void) prepareSelectKeywordViewController{
    _selectKeywordViewController = [[SelectKeywordViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectKeywordViewController.view.frame = [self getSearchRect];   _selectKeywordViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectKeywordViewController.delegate = self;
    [self.view addSubview:_selectKeywordViewController.view];
}

-(void)initExitButton{
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 20, 20, 20)];
    [exitButton setTitle:@"X" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}

-(void)exitButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initSwipeFunction{
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentKeyword);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentKeyword);
        [self chooseName1BtnClicked];
    } else if (direction == MDCSwipeDirectionBottom) {
        NSLog(@"You trash %@.", self.currentKeyword);
    } else {
        NSLog(@"You liked %@.", self.currentKeyword);
        [self chooseName2BtnClicked];
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(KeywordView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentKeyword = frontCardView.keyword;
}

- (NSArray *)defaultKeyword {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    return @[@"demanding", @"humorous", @"what the heck", @"why not?",@"demanding", @"humorous", @"what the heck", @"why not?",@"demanding", @"humorous", @"what the heck", @"why not?",@"demanding", @"humorous", @"what the heck", @"why not?"];
}

- (KeywordView *)popPersonViewWithFrame:(CGRect)frame {
    if ([_keywordArray count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.nopeText = [Utility getNameToDisplay:_option0.name];
    options.likedText = [Utility getNameToDisplay:_option1.name];
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    KeywordView *keywordView = [[KeywordView alloc] initWithFrame:frame
                                                          keyword:_keywordArray[0]
                                                          options:options];
    _keywordCurrentValue = _keywordStoreValue;
    _keywordStoreValue = _keywordArray[0];
    [_keywordArray removeObjectAtIndex:0];
    return keywordView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 150.f;
    CGFloat bottomPadding = 300.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

/*
-(void)addLockBtns{
    _keywordIsLocked = FALSE;
    _option0IsLocked = FALSE;
    _option1IsLocked = FALSE;
    _keywordLockBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 10, 70, 50)];
    _option0LockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 70, 50)];
    _option1LockBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 80, 70, 50)];
    [_keywordLockBtn setTitle:@"lock" forState:UIControlStateNormal];
    [_option0LockBtn setTitle:@"lock" forState:UIControlStateNormal];
    [_option1LockBtn setTitle:@"lock" forState:UIControlStateNormal];
    [_keywordLockBtn addTarget:self action:@selector(keywordLockBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_option0LockBtn addTarget:self action:@selector(option0LockBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_option1LockBtn addTarget:self action:@selector(option1LockBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_keywordLockBtn];
    [self.view addSubview:_option0LockBtn];
    [self.view addSubview:_option1LockBtn];
}*/



-(void) initFBProfilePicViews{
    _option0PicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(60, 50, 60, 60)];
    _option1PicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(200,50, 60, 60)];
    _option0PicView.layer.cornerRadius = _option0PicView.frame.size.width/2.0;
    _option0PicView.layer.masksToBounds = YES;
    _option1PicView.layer.cornerRadius = _option1PicView.frame.size.width/2.0;
    [_option0PicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseName1BtnClicked)]];
    [_option1PicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseName2BtnClicked)]];
    _option1PicView.layer.masksToBounds = YES;
    [self.view addSubview:_option0PicView];
    [self.view addSubview:_option1PicView];
}



/*
-(void) keywordLockBtnClicked:(id)sender{
    if(_keywordIsLocked){
        [_keywordLockBtn setTitle:@"lock" forState:UIControlStateNormal];
        _keywordIsLocked = FALSE;
    } else {
        [_keywordLockBtn setTitle:@"unlock" forState:UIControlStateNormal];
        _keywordIsLocked = TRUE;
    }
}
-(void) option0LockBtnClicked:(id)sender{
    if(_option0IsLocked){
        [_option0LockBtn setTitle:@"lock" forState:UIControlStateNormal];
        _option0IsLocked = FALSE;
    } else {
        [_option0LockBtn setTitle:@"unlock" forState:UIControlStateNormal];
        _option0IsLocked = TRUE;
    }
}
-(void) option1LockBtnClicked:(id)sender{
    if(_option1IsLocked){
        [_option1LockBtn setTitle:@"lock" forState:UIControlStateNormal];
        _option1IsLocked = FALSE;
    } else {
        [_option1LockBtn setTitle:@"unlock" forState:UIControlStateNormal];
        _option1IsLocked = TRUE;
    }
}*/


-(void) setOption0Option1{
    NSArray *randomUser;
    NSMutableArray *existingUsers = [[NSMutableArray alloc] init];
    if (_option0 != nil) [existingUsers addObject:_option0];
    if (_option1 != nil) [existingUsers addObject:_option1];
    [User getRandomUsersThisMany:2 inThisArray:&randomUser inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext existingUsers:existingUsers];
    if([randomUser count] >= 2) {
        [self setOption0:[randomUser firstObject]];
        [self setOption1:[randomUser objectAtIndex:1]];
    }
}

-(void) setOption0:(User *)option0{
    if(!option0){
        NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option0.name] attributes:[Utility getCreateQuizNameFontDictionary]];
        [_option0NameTextField setAttributedText:nameString];
        return;
    }
    MBDebug(@"setoption0 %@", option0.name);
    _option0 = option0;
    _option0PicView.profileID = _option0.fbID;
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option0.name] attributes:[Utility getCreateQuizNameFontDictionary]];
    [_option0NameTextField setAttributedText:nameString];
    [_frontCardView changeNopeTextTo:[Utility getNameToDisplay:_option0.name]];
    [_backCardView changeNopeTextTo:[Utility getNameToDisplay:_option0.name]];
}

-(void) setOption1:(User *)option1{
    if(!option1){
        NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option1.name] attributes:[Utility getCreateQuizNameFontDictionary]];
        [_option1NameTextField setAttributedText:nameString];
        return;
    }
    _option1 = option1;
    _option1PicView.profileID = _option1.fbID;
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option1.name] attributes:[Utility getCreateQuizNameFontDictionary]];
    [_option1NameTextField setAttributedText:nameString];
    [_frontCardView changeLikedTextTo:[Utility getNameToDisplay:_option1.name]];
    [_backCardView changeLikedTextTo:[Utility getNameToDisplay:_option1.name]];
}

-(void)setCurrentUserValues{
    _currentUserName = [KeyChainWrapper getSelfName];
    _currentUserfbID = [KeyChainWrapper getSelfFBID];
}

/*
-(void) addPeopleButtons{
    _chooseName1Btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    _chooseName2Btn =[[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 20)];
    [_chooseName1Btn setTitle:@"Choose" forState:UIControlStateNormal];
    [_chooseName2Btn setTitle:@"Choose" forState:UIControlStateNormal];
    [_chooseName1Btn addTarget:self action:@selector(chooseName1BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_chooseName2Btn addTarget:self action:@selector(chooseName2BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_chooseName1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseName2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_chooseName1Btn];
    [self.view addSubview:_chooseName2Btn];
}*/

-(void)chooseName1BtnClicked{
    if(!_option0 || !_option1){
        return;
    }
    [self createQuizWithAnswer:(NSString *)_option0.name];
}

-(void)chooseName2BtnClicked{
    if(!_option0 || !_option1){
        return;
    }
    [self createQuizWithAnswer:(NSString *)_option1.name];
}

-(void)createQuizWithAnswer:(NSString *)answer{
    Quiz *quiz = [NSEntityDescription insertNewObjectForEntityForName:@"Quiz"
                                               inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];

    [quiz setAuthor:_currentUserfbID];
    [quiz setAuthorName:_currentUserName];
    [quiz setUuid:[Utility generateUUID]];
    [quiz setKeyword:_keywordCurrentValue];
    [quiz setOption0Name:_option0.name];
    [quiz setOption0:_option0.fbID];
    [quiz setOption1Name:_option1.name];
    [quiz setOption1:_option1.fbID];
    [quiz setAnswer:answer];
    [quiz initParentAttributes];
    NSLog(@"%@",quiz);
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[sessionToken] forKeys:@[@"auth_token"]];
    
    [[RKObjectManager sharedManager]
     postObject:quiz
     path:nil
     parameters:params
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         [Post setIndicesAsRefreshing:[mappingResult array]];
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         [Utility generateAlertWithMessage:@"No network!"];
     }];
//    [self shuffleAll:nil];

}

-(void)addTextFields{
//    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 20, 150, 40)];
    _option0NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 120, 50)];
    _option1NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 110, 120, 50)];
    _keywordCurrentValue = @"yay";
//    [_keywordTextField setText:_keywordCurrentValue];
//    [_keywordTextField setTextAlignment:NSTextAlignmentCenter];
    
    
    
//    _name1CurrentValue = @"Albert";
//    [_option0NameTextField setText:_name1CurrentValue];
//    
//    _name2CurrentValue = @"胖仔";
//    [_option1NameTextField setText:_name2CurrentValue];
//    [self.view addSubview:_keywordTextField];
    [self.view addSubview:_option0NameTextField];
    [self.view addSubview:_option1NameTextField];
    
    /*
    [_keywordTextField setBorderStyle:UITextBorderStyleNone];
    [_keywordTextField setDelegate:self];
    [_keywordTextField setBackgroundColor:[UIColor whiteColor]];
    _keywordTextField.layer.cornerRadius = _keywordTextField.frame.size.height/2;
    _keywordTextField.layer.masksToBounds = YES;
    [_keywordTextField setTextAlignment:NSTextAlignmentCenter];
    */
    
    
    [_option0NameTextField setBorderStyle:UITextBorderStyleNone];
    [_option1NameTextField setBorderStyle:UITextBorderStyleNone];
    [_option0NameTextField setTextAlignment:NSTextAlignmentCenter];
    [_option1NameTextField setTextAlignment:NSTextAlignmentCenter];
    [_option0NameTextField setDelegate:self];
    [_option1NameTextField setDelegate:self];
    [_option0NameTextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    [_option1NameTextField addTarget:self
                   action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    /*
    [_keywordTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];*/

}




-(void)addShuffleButtons{
    _shuffleAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 450, 100, 50)];
    [_shuffleAllBtn setTitle:@"shuffle" forState:UIControlStateNormal];
    [_shuffleAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_shuffleAllBtn];
    [_shuffleAllBtn addTarget:self action:@selector(shuffleAll:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)shuffleAll:(id)sender {
//    if(!_keywordIsLocked){
//        [_keywordTextField setText:[KeyChainWrapper getARandomKeyword]];
//        _keywordCurrentValue = [_keywordTextField text];
//    }
    
    NSArray *randomUser;
    NSMutableArray *existingUsers = [[NSMutableArray alloc] init];
    if (_option0 != nil) [existingUsers addObject:_option0];
    if (_option1 != nil) [existingUsers addObject:_option1];
    [User getRandomUsersThisMany:2 inThisArray:&randomUser inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext existingUsers:existingUsers];
    if([randomUser count] >= 2) {
//        if(!_option0IsLocked){
            [self setOption0:[randomUser firstObject]];
//        }
//        if(!_option1IsLocked){
            [self setOption1:[randomUser objectAtIndex:1]];
//        }
    }
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"got touched!");
//    UITouch *touch = [touches anyObject];
//    _startPoint = [touch locationInView:self.view];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) setUser:(User *)user{
    if(_ongoingTextField == _option0NameTextField){
        [self setOption0:user];
    } else if(_ongoingTextField == _option1NameTextField){
        [self setOption1:user];
    }
    [_ongoingTextField endEditing:YES];
    [self recordData];
}

-(void) resetAllOptions{
    
}

-(void) setKeyword:(NSString *)keyword{
    NSLog(@"keyword set %@", keyword);
    _keywordCurrentValue = [keyword copy];
    /*
    [_keywordTextField setText:_keywordCurrentValue];
    [_keywordTextField endEditing:YES];
     */
    [self recordData];
}

-(void) tappedView{
//    CGPoint tappedPoint = [recognizer locationInView:self.view];
//    CGRect searchFrame = [self getSearchRect];
//    if(CGRectContainsPoint(searchFrame, tappedPoint)){
//        return;
//    }
    [self.view endEditing:YES];
    [self presentData];
}

-(CGRect)getSearchRect{
    return CGRectMake(0, 150, self.view.bounds.size.width, 200);
}

#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    if (textField == _keywordTextField) {
    //    [textField resignFirstResponder];
    //    if(self.delegate){
    //        [self.delegate backToNormal:self];
    //    }
    
    // Alert style
 /*
    if(textField == _keywordTextField){
        [textField resignFirstResponder];
        if(_delegate && [_delegate respondsToSelector:@selector(backToNormal:)]){
            [_delegate backToNormal:self];
        }
        [self recordData];
        return NO;
    } else{
        [Utility generateAlertWithMessage:@"請選一個朋友"];
        return YES;
    }
    */
    [self tappedView];
    return  NO;

}

-(void)textFieldDidChange :(UITextField *)textField{
    if(textField == _option1NameTextField || textField == _option0NameTextField){
        NSArray *arrayOfUsers;
        [User searchUserThatContains:[textField text]
                 returnThisManyUsers:10 inThisArray:&arrayOfUsers
              inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                       existingUsers:nil];
        [_selectPeopleViewController displaySearchResult:arrayOfUsers];
    } else{
        NSArray *arrayOfKeywords = [KeyChainWrapper searchKeywordThatContains:[textField text] returnThisManyKeywords:10];
        [_selectKeywordViewController displaySearchResult:arrayOfKeywords];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    for(id view in self.view.subviews){
        if([view tag] == AUTO_COMPLETE_SELECT_VIEW_TAG){
            [view removeFromSuperview];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self presentAndEmptyData:textField];
    _ongoingTextField = textField;
    if(textField == _option0NameTextField || textField == _option1NameTextField){
        [self prepareSelectPeopleViewController];
    } else{
        [self prepareSelectKeywordViewController];
    }
}

-(void) presentAndEmptyData:(UITextField *)textField{
    [self presentData];
    [textField setText:@""];
}

-(void) recordData{
//    _keywordCurrentValue = [_keywordTextField text];
}

-(void) presentData{
    [self setOption0:nil];
    [self setOption1:nil];
//    [_keywordTextField setText:_keywordCurrentValue];
}

#pragma mark -
#pragma mark SelectPeopleViewController Delegate Methods
- (void)selectedPerson:(User *)user{
    MBDebug(@"setoption %@", user.name);
    [self setUser:user];
}


#pragma mark -
#pragma mark SelectKeywordViewController Delegate Methods
- (void)selectedKeyword:(NSString *)keyword{
    NSLog(@"tabbar got selected");
    [self setKeyword:keyword];
}

@end
