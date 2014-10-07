//
//  CreateQuizViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//


#import "CreateQuizViewController.h"

#import "KeyChainWrapper.h"
#import "User+MBUser.h"
#import "Quiz.h"


//#import "TouchTextField.h"

@interface CreateQuizViewController ()
@property (strong, nonatomic) UITextField *keywordTextField;
@property (strong, nonatomic) UITextField *option0NameTextField;
@property (strong, nonatomic) UITextField *option1NameTextField;
@property (strong, nonatomic) UIButton *shuffleKeywordBtn;
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

@end

@implementation CreateQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextFields];
    [self addShuffleButtons];
    [self addPeopleButtons];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)]];
    [self recordData];
    [self setCurrentUserValues];
    [self setOption0Option1];
    // Do any additional setup after loading the view.
}

-(void) setOption0Option1{
    NSArray *randomUser;
    [User getRandomUsersThisMany:2 inThisArray:&randomUser inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    [self setOption0:[randomUser firstObject]];
    [self setOption1:[randomUser objectAtIndex:1]];
}
                     
-(void) setOption0:(User *)option0{
    _option0 = option0;
    [_option0NameTextField setText:[Utility getNameToDisplay:_option0.name]];
}

-(void) setOption1:(User *)option1{
    _option1 = option1;
    [_option1NameTextField setText:[Utility getNameToDisplay:_option1.name]];
}

-(void)setCurrentUserValues{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults){
        _currentUserName = [standardUserDefaults objectForKey:@"userName"];
        _currentUserfbID = [standardUserDefaults objectForKey:@"userFBID"];
    }
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
    [self createQuizWithAnswer:(NSString *)_option0.name];
}

-(void)chooseName2BtnClicked{
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
    NSLog(@"%@",quiz);
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[sessionToken] forKeys:@[@"auth_token"]];
    
    [[RKObjectManager sharedManager]
     postObject:quiz
     path:nil
     parameters:params
     success:[Utility successBlockWithDebugMessage:@"Succcessfully posted the quiz"
                                             block:^{                                             }]
     failure:^(RKObjectRequestOperation *operation, NSError *error) {
         [Utility generateAlertWithMessage:@"No network!"];
     }];

}

-(void)addTextFields{
    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 20, 50, 50)];
    _option0NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 120, 50)];
    _option1NameTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 20, 120, 50)];
    _keywordCurrentValue = @"yay";
    [_keywordTextField setText:_keywordCurrentValue];
    
    
    
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
    [_keywordTextField setBackgroundColor:[UIColor yellowColor]];
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
}



-(void)addShuffleButtons{
    _shuffleKeywordBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, 100, 50)];
    _shufflePeopleBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 60, 100, 50)];
    [_shuffleKeywordBtn setTitle:@"關鍵字" forState:UIControlStateNormal];
    [_shufflePeopleBtn setTitle:@"朋友" forState:UIControlStateNormal];
    [_shuffleKeywordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shufflePeopleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_shuffleKeywordBtn];
    [self.view addSubview:_shufflePeopleBtn];
    [_shufflePeopleBtn addTarget:self action:@selector(shufflePeople:) forControlEvents:UIControlEventTouchUpInside];
    [_shuffleKeywordBtn addTarget:self action:@selector(shuffleKeyword:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shuffleKeyword:(id)sender {
    [_keywordTextField setText:@"人性"];
    _keywordCurrentValue = [_keywordTextField text];
}

- (void)shufflePeople:(id)sender {
    [self setOption0Option1];
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
        [User searchUserThatContains:[textField text] returnThisManyUsers:10 inThisArray:&arrayOfUsers inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
        if(_delegate && [_delegate respondsToSelector:@selector(gotSearchUsersResult:)]){
            [_delegate gotSearchUsersResult:arrayOfUsers];
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
    if(textField == _option0NameTextField || textField == _option1NameTextField){
        _ongoingTextField = textField;
        if(self.delegate && [_delegate respondsToSelector:@selector(shouldDisplayPeople:withPeople:)]){
//            NSArray* people = [NSArray arrayWithObjects:@"Iru",@"Wen",@"Henry",@"Albert",@"Sandy",nil];
            [self.delegate shouldDisplayPeople:self withPeople:nil];
        }
    } else{
        if(_delegate && [_delegate respondsToSelector:@selector(shouldDisplayKeywords:withKeywords:)]){
//            NSArray* keywords = [NSArray arrayWithObjects:@"Iru",@"Wen",@"Henry",@"Albert",@"Sandy",nil];
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
    [_option0NameTextField setText:[Utility getNameToDisplay:_option0.name]];
    [_option1NameTextField setText:[Utility getNameToDisplay:_option1.name]];
    [_keywordTextField setText:_keywordCurrentValue];
}

@end
