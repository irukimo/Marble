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


//#import "TouchTextField.h"

@interface CreateQuizViewController ()
@property (strong, nonatomic) UITextField *keywordTextField;
@property (strong, nonatomic) UITextField *option0NameTextField;
@property (strong, nonatomic) UITextField *option1NameTextField;
@property (strong, nonatomic) UIButton *shuffleAllBtn;
@property (strong, nonatomic) UIButton *shufflePeopleBtn;
@property (strong, nonatomic) UITextField *ongoingTextField;
@property (strong, nonatomic) NSString *keywordCurrentValue;
@property (strong, nonatomic) UIButton *chooseName1Btn;
@property (strong, nonatomic) UIButton *chooseName2Btn;
@property(nonatomic)CGPoint startPoint;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *currentUserfbID;
@property (strong, nonatomic) User *option0;
@property (strong, nonatomic) User *option1;
@property (strong, nonatomic) FBProfilePictureView *option0PicView;
@property (strong, nonatomic) FBProfilePictureView *option1PicView;
@property (strong, nonatomic) UIButton *keywordLockBtn;
@property (strong, nonatomic) UIButton *option0LockBtn;
@property (strong, nonatomic) UIButton *option1LockBtn;
@property (nonatomic) BOOL keywordIsLocked;
@property (nonatomic) BOOL option0IsLocked;
@property (nonatomic) BOOL option1IsLocked;
@end

@implementation CreateQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextFields];
    [self addShuffleButtons];
    [self addPeopleButtons];
    [self initFBProfilePicViews];
    [self addLockBtns];
//    [self.view setAlpha:0.5f];
    [self.view setBackgroundColor:[UIColor marbleOrange]];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)]];
    [self recordData];
    [self setCurrentUserValues];
//    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [grayView setBackgroundColor:[UIColor blackColor]];
//    [grayView setAlpha:0.5];
//    [self.view addSubview:grayView];
    /*
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(setOption0Option1)
                                   userInfo:nil
                                    repeats:NO];*/
    // Do any additional setup after loading the view.
}

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
}

-(void) initFBProfilePicViews{
    _option0PicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(60, 80, 60, 60)];
    _option1PicView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(200,80, 60, 60)];
    _option0PicView.layer.cornerRadius = _option0PicView.frame.size.width/2.0;
    _option0PicView.layer.masksToBounds = YES;
    _option1PicView.layer.cornerRadius = _option1PicView.frame.size.width/2.0;
    [_option0PicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseName1BtnClicked)]];
    [_option1PicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseName2BtnClicked)]];
    _option1PicView.layer.masksToBounds = YES;
    [self.view addSubview:_option0PicView];
    [self.view addSubview:_option1PicView];
}

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
}


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
    _option0 = option0;
    _option0PicView.profileID = _option0.fbID;
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option0.name] attributes:[Utility getCreateQuizNameFontDictionary]];
    [_option0NameTextField setAttributedText:nameString];
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
}

-(void)setCurrentUserValues{
    _currentUserName = [KeyChainWrapper getSelfName];
    _currentUserfbID = [KeyChainWrapper getSelfFBID];
}

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
}

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
    [self shuffleAll:nil];

}

-(void)addTextFields{
    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 20, 150, 40)];
    _option0NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, 120, 50)];
    _option1NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 130, 120, 50)];
    _keywordCurrentValue = @"yay";
    [_keywordTextField setText:_keywordCurrentValue];
    [_keywordTextField setTextAlignment:NSTextAlignmentCenter];
    
    
    
//    _name1CurrentValue = @"Albert";
//    [_option0NameTextField setText:_name1CurrentValue];
//    
//    _name2CurrentValue = @"胖仔";
//    [_option1NameTextField setText:_name2CurrentValue];
    [self.view addSubview:_keywordTextField];
    [self.view addSubview:_option0NameTextField];
    [self.view addSubview:_option1NameTextField];
    [_keywordTextField setBorderStyle:UITextBorderStyleNone];
    [_keywordTextField setDelegate:self];
    [_keywordTextField setBackgroundColor:[UIColor whiteColor]];
    _keywordTextField.layer.cornerRadius = _keywordTextField.frame.size.height/2;
    _keywordTextField.layer.masksToBounds = YES;
    [_keywordTextField setTextAlignment:NSTextAlignmentCenter];
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
    [_keywordTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];

}



-(void)addShuffleButtons{
    _shuffleAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 50)];
    [_shuffleAllBtn setTitle:@"shuffle" forState:UIControlStateNormal];
    [_shuffleAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_shuffleAllBtn];
    [_shuffleAllBtn addTarget:self action:@selector(shuffleAll:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shuffleAll:(id)sender {
    if(!_keywordIsLocked){
        [_keywordTextField setText:[KeyChainWrapper getARandomKeyword]];
        _keywordCurrentValue = [_keywordTextField text];
    }
    
    NSArray *randomUser;
    NSMutableArray *existingUsers = [[NSMutableArray alloc] init];
    if (_option0 != nil) [existingUsers addObject:_option0];
    if (_option1 != nil) [existingUsers addObject:_option1];
    [User getRandomUsersThisMany:2 inThisArray:&randomUser inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext existingUsers:existingUsers];
    if([randomUser count] >= 2) {
        if(!_option0IsLocked){
            [self setOption0:[randomUser firstObject]];
        }
        if(!_option1IsLocked){
            [self setOption1:[randomUser objectAtIndex:1]];
        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"got touched!");
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self.view];
}

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
    [_keywordTextField setText:_keywordCurrentValue];
    [_keywordTextField endEditing:YES];
    [self recordData];
}

-(void) tappedView{
    [self.view endEditing:YES];
    [self presentData];
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

}

-(void)textFieldDidChange :(UITextField *)textField{
    if(textField == _option1NameTextField || textField == _option0NameTextField){
        NSArray *arrayOfUsers;
        [User searchUserThatContains:[textField text]
                 returnThisManyUsers:10 inThisArray:&arrayOfUsers
              inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                       existingUsers:nil];
        if(_delegate && [_delegate respondsToSelector:@selector(gotSearchUsersResult:)]){
            [_delegate gotSearchUsersResult:arrayOfUsers];
        }
    } else{
        NSArray *arrayOfKeywords = [KeyChainWrapper searchKeywordThatContains:[textField text] returnThisManyKeywords:10];
        if(_delegate && [_delegate respondsToSelector:@selector(gotSearchKeywordsResult:)]){
            [_delegate gotSearchKeywordsResult:arrayOfKeywords];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(_delegate && [_delegate respondsToSelector:@selector(backToNormal:)]){
        [_delegate backToNormal:self];
    }
    if(textField == _keywordTextField && ![textField.text isEqualToString:@""] ){
        [self recordData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self presentAndEmptyData:textField];
    _ongoingTextField = textField;
    if(textField == _option0NameTextField || textField == _option1NameTextField){
        if(self.delegate && [_delegate respondsToSelector:@selector(shouldDisplayPeople:withPeople:)]){
            [self.delegate shouldDisplayPeople:self withPeople:nil];
        }
    } else{
        if(_delegate && [_delegate respondsToSelector:@selector(shouldDisplayKeywords:withKeywords:)]){
            [_delegate shouldDisplayKeywords:self withKeywords:nil];
        }
    }
}

-(void) presentAndEmptyData:(UITextField *)textField{
    [self presentData];
    [textField setText:@""];
}

-(void) recordData{
    _keywordCurrentValue = [_keywordTextField text];
}

-(void) presentData{
    [self setOption0:nil];
    [self setOption1:nil];
    [_keywordTextField setText:_keywordCurrentValue];
}

@end
