//
//  CreateQuizViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//


#import "CreateQuizViewController.h"
#import "MarbleTabBarController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "User+MBUser.h"
#import "Quiz.h"
#import "Quiz+MBQuiz.h"
#import "Post+MBPost.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"

#define AUTO_COMPLETE_SELECT_VIEW_TAG 999

static const CGFloat animationDuration = 0.25;
static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;
static const int picviewSize = 112;
static const int picY = 50;


//#import "TouchTextField.h"

@interface CreateQuizViewController ()

@property (strong, nonatomic) SelectPeopleViewController *selectPeopleViewController;
@property (strong, nonatomic) SelectKeywordViewController *selectKeywordViewController;

//@property (strong, nonatomic) UITextField *keywordTextField;
@property (strong, nonatomic) UITextField *option0NameTextField;
@property (strong, nonatomic) UITextField *option1NameTextField;
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
@property (strong, nonatomic) UIImageView *option0PicView;
@property (strong, nonatomic) UIImageView *option1PicView;
@property (nonatomic) CGRect option0PicFrame;
@property (nonatomic) CGRect option1PicFrame;

@property(strong, nonatomic) UIView *mainView;
@property(strong,nonatomic) UIView *maskForDismissingTextField;
/*
@property (strong, nonatomic) UIButton *keywordLockBtn;
@property (strong, nonatomic) UIButton *option0LockBtn;
@property (strong, nonatomic) UIButton *option1LockBtn;
@property (nonatomic) BOOL keywordIsLocked;
@property (nonatomic) BOOL option0IsLocked;
@property (nonatomic) BOOL option1IsLocked;
 */


@property (nonatomic, strong) NSMutableArray *keywordArray;


@property UIView *blurMask;
@property UIImageView *blurredBgImage;

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


-(void)viewWillAppear:(BOOL)animated{
    [_mainView setAlpha:0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [_mainView setAlpha:1];
    [UIView commitAnimations];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //put original view at background first
    [self.view addSubview:[self generateBackgroundView]];
    //everything is in mainView
    [self.view addSubview:[self generateMainView]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.bounds.size.width, 30)];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"Tap on any item to edit" attributes:[Utility getCreateQuizDescFontDictionary]];
    [titleLabel setAttributedText:titleString];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_mainView addSubview:titleLabel];
    
    _keywordArray = [[self defaultKeyword] mutableCopy];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addTextFields];
    [self addShufflePeopleButton];
//    [self addPeopleButtons];
    [self initFBProfilePicViews];
//    [self addLockBtns];
//    [self.view setAlpha:0.5f];
    
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)]];
    
    [self recordData];
    [self setCurrentUserValues];
    
    [self initSwipeFunction];
//    [self initExitButton];
    
    [self generateMaskForDismissingTextField];
    
    [self setOption0Option1];
    [self seeIfDisplayLookingAt];
    
    [self createBlurredView];
    
    NSLog(@"ran did load");
    

}

-(void)seeIfDisplayLookingAt{
    if(!_lookingAtEitherUserOrKeyword){
        return;
    }
    if([_lookingAtEitherUserOrKeyword isKindOfClass:[User class]]){
        [self setOption0:(User *)_lookingAtEitherUserOrKeyword];
    }else if([_lookingAtEitherUserOrKeyword isKindOfClass:[NSString class]]){
        [self setKeyword:(NSString *)_lookingAtEitherUserOrKeyword];
    }
}

-(void)generateMaskForDismissingTextField{
    _maskForDismissingTextField = [[UIView alloc] initWithFrame:self.view.frame];
    [_maskForDismissingTextField setBackgroundColor:[UIColor clearColor]];
    [_maskForDismissingTextField addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)]];
    [_maskForDismissingTextField setTag:AUTO_COMPLETE_SELECT_VIEW_TAG];
    [_maskForDismissingTextField setUserInteractionEnabled:YES];
}

-(UIImageView *)generateBackgroundView{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    if(_delegate && [_delegate isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *vc = (MarbleTabBarController *)_delegate;
        bgView.image = [self takeSnapshotOfView:vc.view withReductionFactor:0.5];
    }
    return bgView;
}

-(UIView *)generateMainView{
    _mainView = [[UIView alloc] initWithFrame:self.view.frame];
    _blurredBgImage = [[UIImageView  alloc] initWithFrame:self.view.frame];
    [_blurredBgImage setContentMode:UIViewContentModeScaleToFill];
    [_mainView addSubview:_blurredBgImage];
    [_blurredBgImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitButtonClicked:)]];
    [_blurredBgImage setUserInteractionEnabled:YES];
    [_mainView setAlpha:0];
    return _mainView;
}

-(void)createBlurredView{
    /*:::::::::::::::::::::::: Create Blurred View ::::::::::::::::::::::::::*/
    
    // Blurred with UIImage+ImageEffects
    if(_delegate && [_delegate isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *vc = (MarbleTabBarController *)_delegate;
//        _blurredBgImage.image = [self takeSnapshotOfView:vc.view withReductionFactor:1];
        _blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:vc.view withReductionFactor:2]];
    }

    
    // Blurred with Core Image
    // blurredBgImage.image = [self blurWithCoreImage:[self takeSnapshotOfView:[self createContentView]]];
    
    // Blurring with GPUImage framework
    // blurredBgImage.image = [self blurWithGPUImage:[self takeSnapshotOfView:[self createContentView]]];
    
    /*::::::::::::::::::: Create Mask for Blurred View :::::::::::::::::::::*/
    //Iru: we don't need mask
//    _blurMask = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
//    _blurMask.backgroundColor = [UIColor whiteColor];
//    _blurredBgImage.layer.mask = _blurMask.layer;
    

}

- (UIImage *)blurWithImageEffects:(UIImage *)image
{
//    return [image applyBlurWithRadius:15 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
    return [image applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:1 alpha:0.5] saturationDeltaFactor:1 maskImage:nil];
}
- (UIImage *)takeSnapshotOfView:(UIView *)view withReductionFactor:(CGFloat)factor
{
    CGFloat reductionFactor = factor;
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void) addMaskAndPrepareSelectPeopleViewController{
    [_mainView addSubview:_maskForDismissingTextField];
    _selectPeopleViewController = [[SelectPeopleViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectPeopleViewController.view.frame = [self getSearchRect];
    _selectPeopleViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectPeopleViewController.delegate = self;
    [_mainView addSubview:_selectPeopleViewController.view];
}

-(void) addMaskAndPrepareSelectKeywordViewController{
    [_mainView addSubview:_maskForDismissingTextField];
    _selectKeywordViewController = [[SelectKeywordViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    CGRect searchFrame = [self getSearchRect];
//    searchFrame.origin.y = searchFrame.origin.y ;
    _selectKeywordViewController.view.frame = searchFrame;
    _selectKeywordViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectKeywordViewController.delegate = self;
    [_selectKeywordViewController.view setHidden:YES];
    [_mainView addSubview:_selectKeywordViewController.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _frontCardView.frame = [self frontCardViewFrameWhenEditing];
    [UIView commitAnimations];
    
}

-(void)initExitButton{
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 20, 20, 20)];
    [exitButton setTitle:@"X" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:exitButton];
}

-(void)exitButtonClicked:(id)sender{
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options: (UIViewAnimationOptions)UIViewAnimationCurveLinear
                     animations:^{
                        [_mainView setAlpha:0];
                             }
                     completion:^(BOOL finished){
                        [self dismissViewControllerAnimated:NO completion:nil];
                             }];
}

-(void)initSwipeFunction{
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [_mainView addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [_mainView insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentKeyword);
    [self bouncePicViewsBack];
}

-(void)bouncePicViewsBack{
    [UIView animateWithDuration:0.15
                          delay:0
                        options: (UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                     animations:^{
                         [_option0PicView setFrame:_option0PicFrame];
                         [_option1PicView setFrame:_option1PicFrame];
                     }
                     completion:^(BOOL finished){

                     }];
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
        [_mainView insertSubview:self.backCardView belowSubview:self.frontCardView];
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
    NSString *firstKeyword = [KeyChainWrapper getARandomKeyword];
    NSString *secondKeyword = [KeyChainWrapper getARandomKeyword];
    NSString *thirdKeyword = [KeyChainWrapper getARandomKeyword];

    return @[@"Shy",
             @"Romantic",
             @"Buff",
             @"會咬人",
             @"Thick skinned",
             @"Cheap",
             @"Drinks too much",
             @"愛把妹",
             @"bright",
             @"considerate",
             @"brave",
             @"charming",
             @"careful",
             @"amusing",
             @"creative",
             @"calm",
             @"not calm",
             @"modest",
             @"quick",
             @"polite",
             @"愛放閃",
             @"doesn’t shower",
             @"high GPA",
             @"energetic",
             @"puppy eyes",
             @"skinny dipping",
             @"chipotle",
             @"racist",
             @"愛哭鬼"];
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
    //was originally 160
    options.threshold = 100.f;
    options.nopeText = [Utility getNameToDisplay:_option0.name];
    options.likedText = [Utility getNameToDisplay:_option1.name];
    options.onPan = ^(MDCPanState *state){
        [self cardOnPan:state];
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    KeywordView *keywordView = [[KeywordView alloc] initWithFrame:frame
                                                          keyword:_keywordArray[0]
                                                          options:options];
    keywordView.delegate = self;
    _keywordCurrentValue = _keywordStoreValue;
    _keywordStoreValue = _keywordArray[0];
    [_keywordArray removeObjectAtIndex:0];
    [self checkIfNeedMoreKeyword];
    return keywordView;
}

-(void)cardOnPan:(MDCPanState *)state{
    CGRect frame = [self backCardViewFrame];
    self.backCardView.frame = CGRectMake(frame.origin.x,
                                         frame.origin.y - (state.thresholdRatio * 10.f),
                                         CGRectGetWidth(frame),
                                         CGRectGetHeight(frame));
    if (state.direction == MDCSwipeDirectionNone) {
        //do nothing
    } else if (state.direction == MDCSwipeDirectionLeft) {
        [self expandView:_option0PicView withOriFrame:_option0PicFrame withRatio:state.thresholdRatio];
    } else if (state.direction == MDCSwipeDirectionRight) {
        [self expandView:_option1PicView withOriFrame:_option1PicFrame withRatio:state.thresholdRatio];
    } else if (state.direction == MDCSwipeDirectionBottom) {
        //do nothing
    }
}
-(void)expandView:(UIView *)view withOriFrame:(CGRect)oriFrame withRatio:(CGFloat)ratio{
    CGRect newFrame = oriFrame;
    CGFloat expandWidth = 6.0f;
    newFrame.origin.x = newFrame.origin.x - ratio*expandWidth/2.0f;
    newFrame.origin.y = newFrame.origin.y - ratio*expandWidth/2.0f;
    newFrame.size.width = newFrame.size.width + ratio*expandWidth;
    newFrame.size.height = newFrame.size.height + ratio*expandWidth;
    [self picViewSetFrame:view withFrame:newFrame];
}

-(void)checkIfNeedMoreKeyword{
    if([_keywordArray count] < 2){
        [_keywordArray addObject:[KeyChainWrapper getARandomKeyword]];
    }
}
#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 35.f;
    CGFloat topPadding = 205.f;
    CGFloat bottomPadding = 370.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(_mainView.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(_mainView.frame) - bottomPadding);
}

- (CGRect)frontCardViewFrameWhenEditing {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y -170.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
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
    [_mainView addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(_mainView.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
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
    [_mainView addSubview:button];
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

    [_mainView addSubview:_keywordLockBtn];
    [_mainView addSubview:_option0LockBtn];
    [_mainView addSubview:_option1LockBtn];
}*/



-(void) initFBProfilePicViews{
    _option0PicView = [[UIImageView alloc] initWithFrame:CGRectMake(40, picY, picviewSize, picviewSize)];
    _option1PicView = [[UIImageView alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth]-150,picY, picviewSize, picviewSize)];
    _option0PicView.layer.cornerRadius = _option0PicView.frame.size.width/2.0;
    _option0PicView.layer.masksToBounds = YES;
    _option1PicView.layer.cornerRadius = _option1PicView.frame.size.width/2.0;
    [_option0PicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(option0PicViewClicked)]];
    [_option1PicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(option1PicViewClicked)]];
    _option1PicView.layer.masksToBounds = YES;
    [_option0PicView setUserInteractionEnabled:YES];
    [_option1PicView setUserInteractionEnabled:YES];
    [_mainView addSubview:_option0PicView];
    [_mainView addSubview:_option1PicView];
    _option0PicFrame = _option0PicView.frame;
    _option1PicFrame = _option1PicView.frame;
}

-(void)option0PicViewClicked{
    [_option0NameTextField becomeFirstResponder];
}

-(void)option1PicViewClicked{
    [_option1NameTextField becomeFirstResponder];
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
    if(!option0 && _option0 != nil){
        [self setThisNameTextField:_option0NameTextField withName:_option0.name];
        return;
    } else if (!option0 && _option0 == nil) {
        return;
    } else {
        MBDebug(@"setoption0 %@", option0.name);
        _option0 = option0;
        [Utility setUpProfilePictureImageView:_option0PicView byFBID:_option0.fbID];
        [self setThisNameTextField:_option0NameTextField withName:_option0.name];
        
        [_frontCardView changeNopeTextTo:[Utility getNameToDisplay:_option0.name]];
        [_backCardView changeNopeTextTo:[Utility getNameToDisplay:_option0.name]];
    }
}

-(void) setOption1:(User *)option1{
    if(!option1 && _option1 != nil){
        [self setThisNameTextField:_option1NameTextField withName:_option1.name];
        return;
    } else if (!option1 && _option1 == nil) {
        return;
    } else {
        _option1 = option1;
        [Utility setUpProfilePictureImageView:_option1PicView byFBID:_option1.fbID];
        [self setThisNameTextField:_option1NameTextField withName:_option1.name];
        
        [_frontCardView changeLikedTextTo:[Utility getNameToDisplay:_option1.name]];
        [_backCardView changeLikedTextTo:[Utility getNameToDisplay:_option1.name]];
    }
}

-(void)setThisNameTextField:(UITextField *)textfield withName:(NSString *)name{
    NSAttributedString *nameString;
    if(textfield == _option0NameTextField){
        nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getCreateQuizLeftNameFontDictionary]];
    } else{
        nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getCreateQuizRightNameFontDictionary]];
    }
    [textfield setAttributedText:nameString];
    [textfield setTextAlignment:NSTextAlignmentCenter];
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
    [_mainView addSubview:_chooseName1Btn];
    [_mainView addSubview:_chooseName2Btn];
}*/

-(void)chooseName1BtnClicked{
    if(!_option0 || !_option1){
        return;
    }
    [self startBounce:_option0PicView withOriFrame:_option0PicFrame];
    [self createQuizWithAnswer:(NSString *)_option0.name];
}

-(void)chooseName2BtnClicked{
    if(!_option0 || !_option1){
        return;
    }
    [self startBounce:_option1PicView withOriFrame:_option1PicFrame];
    [self createQuizWithAnswer:(NSString *)_option1.name];
}


-(void)startBounce:(UIView *)view withOriFrame:(CGRect)oriFrame{
    int expandWidth = 10;
    CGRect newFrame = oriFrame;
    newFrame.origin.x = newFrame.origin.x - expandWidth/2.0f;
    newFrame.origin.y = newFrame.origin.y - expandWidth/2.0f;
    newFrame.size.width = newFrame.size.width + expandWidth;
    newFrame.size.height = newFrame.size.height + expandWidth;
    [UIView animateWithDuration:0.15
                          delay:0
                        options: (UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                     animations:^{
                         [view setFrame:newFrame];
                     }
                     completion:^(BOOL finished){
                         [self endBounce:view withNewFrame:newFrame andOriFrame:oriFrame];
                     }];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:oriFrame.size.width/2.0f];
    animation.toValue = [NSNumber numberWithFloat:newFrame.size.width/2.0f];
    animation.duration = 0.15;
    [view.layer addAnimation:animation forKey:@"cornerRadius"];
    
}

-(void)endBounce:(UIView *)view withNewFrame:(CGRect)newFrame andOriFrame:(CGRect)oriFrame{
    [UIView animateWithDuration:0.15
                          delay:0
                        options: (UIViewAnimationOptions)UIViewAnimationCurveEaseIn
                     animations:^{
                         [self picViewSetFrame:view withFrame:oriFrame];
                     }
                     completion:^(BOOL finished){
                     }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fromValue = [NSNumber numberWithFloat:newFrame.size.width/2.0f];
    animation.toValue = [NSNumber numberWithFloat:oriFrame.size.width/2.0f];
    animation.duration = 0.15;
    [view.layer addAnimation:animation forKey:@"cornerRadius"];
}

-(void)picViewSetFrame:(UIView *)view withFrame:(CGRect)frame{
    [view setFrame:frame];
    [view.layer setCornerRadius:frame.size.width/2.0f];
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
    [KeyChainWrapper addKeyword:_keywordCurrentValue];
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
    _option0NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, picY + picviewSize+3, 120, 30)];
    _option1NameTextField = [[UITextField alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth] - 150, picY + picviewSize+3, 120, 30)];
    _keywordCurrentValue = @"yay";
//    [_keywordTextField setText:_keywordCurrentValue];
//    [_keywordTextField setTextAlignment:NSTextAlignmentCenter];
    
    
    
//    _name1CurrentValue = @"Albert";
//    [_option0NameTextField setText:_name1CurrentValue];
//    
//    _name2CurrentValue = @"胖仔";
//    [_option1NameTextField setText:_name2CurrentValue];
//    [_mainView addSubview:_keywordTextField];
    [_mainView addSubview:_option0NameTextField];
    [_mainView addSubview:_option1NameTextField];
    
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




-(void)addShufflePeopleButton{
    _shufflePeopleBtn = [[UIButton alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth]/2.f - 80, [KeyChainWrapper getScreenHeight]-118, 170, 50)];
    NSAttributedString *shuffleString = [[NSAttributedString alloc] initWithString:@"shuffle friends" attributes:[Utility getCreateQuizShuffleButtonFontDictionary]];
    [_shufflePeopleBtn setAttributedTitle:shuffleString forState:UIControlStateNormal];
    [_shufflePeopleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mainView addSubview:_shufflePeopleBtn];
    [_shufflePeopleBtn addTarget:self action:@selector(shufflePeople:) forControlEvents:UIControlEventTouchUpInside];
    [_shufflePeopleBtn setBackgroundColor:[UIColor marbleOrange]];
    [_shufflePeopleBtn.layer setCornerRadius:_shufflePeopleBtn.frame.size.height/2.0];
    [_shufflePeopleBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)shufflePeople:(id)sender {
    
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


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"got touched!");
//    UITouch *touch = [touches anyObject];
//    _startPoint = [touch locationInView:_mainView];
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
    _frontCardView.keyword = keyword;
    
    
    [_ongoingTextField endEditing:YES];
    [self recordData];
}

-(void) tappedView{
//    CGPoint tappedPoint = [recognizer locationInView:_mainView];
//    CGRect searchFrame = [self getSearchRect];
//    if(CGRectContainsPoint(searchFrame, tappedPoint)){
//        return;
//    }
    [_mainView endEditing:YES];
    [self presentData];
}

-(CGRect)getSearchRect{
    return CGRectMake(0, picviewSize+picY+40
                      , _mainView.bounds.size.width, 200);
}

#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    MBDebug(@"return clicked");
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    for(id view in _mainView.subviews){
        if([view tag] == AUTO_COMPLETE_SELECT_VIEW_TAG){
            [view removeFromSuperview];
        }
    }
    if(textField!=_option0NameTextField && textField!=_option1NameTextField){
        if([textField.text isEqualToString:@""]){
            _frontCardView.keyword = _keywordCurrentValue;
        } else{
            _keywordCurrentValue = textField.text;
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _frontCardView.frame = [self frontCardViewFrame];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self presentAndEmptyData:textField];
    _ongoingTextField = textField;
    if(textField == _option0NameTextField || textField == _option1NameTextField){
        [self addMaskAndPrepareSelectPeopleViewController];
    } else{
        [self addMaskAndPrepareSelectKeywordViewController];
    }
}


//not a delegate method, need to set fire
-(void)textFieldDidChange :(UITextField *)textField{
    if(textField == _option1NameTextField || textField == _option0NameTextField){
        NSArray *existingUsers = (textField == _option0NameTextField) ? @[_option1] : @[_option0];
        NSArray *arrayOfUsers;
        [User searchUserThatContains:[textField text]
                 returnThisManyUsers:10 inThisArray:&arrayOfUsers
              inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                       existingUsers:existingUsers];
        [_selectPeopleViewController displaySearchResult:arrayOfUsers];
    } else{
        NSArray *arrayOfKeywords = [KeyChainWrapper searchKeywordThatContains:[textField text] returnThisManyKeywords:10];
        if([arrayOfKeywords count] == 0){
            [_selectKeywordViewController.view setHidden:YES];
        } else{
            [_selectKeywordViewController.view setHidden:NO];
            [_selectKeywordViewController displaySearchResult:arrayOfKeywords];
        }
    }
}


-(void) presentAndEmptyData:(UITextField *)textField{
    [self presentData];
    [textField setText:@""];
    [textField setTextAlignment:NSTextAlignmentCenter];
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
