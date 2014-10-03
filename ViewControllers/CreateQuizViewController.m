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
@property (strong, nonatomic) UITextField *name1TextField;
@property (strong, nonatomic) UITextField *name2TextField;
@property (strong, nonatomic) UIButton *shuffleKeywordBtn;
@property (strong, nonatomic) UIButton *shufflePeopleBtn;
@property (strong, nonatomic) UITextField *ongoingTextField;
@property (strong, nonatomic) NSString *name1CurrentValue;
@property (strong, nonatomic) NSString *name2CurrentValue;
@property (strong, nonatomic) NSString *keywordCurrentValue;
@property (strong, nonatomic) UIButton *chooseName1Btn;
@property (strong, nonatomic) UIButton *chooseName2Btn;
@property(nonatomic)CGPoint startPoint;

@end

@implementation CreateQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextFields];
    [self addShuffleButtons];
    [self addPeopleButtons];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)]];
    [self recordData];

    // Do any additional setup after loading the view.
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
    NSLog(@"author chose %@ over %@ for keyword: %@", _name1CurrentValue, _name2CurrentValue, _keywordCurrentValue);
    
    Quiz *quiz = [NSEntityDescription insertNewObjectForEntityForName:@"Quiz"
                                               inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext];
    
    [quiz setKeyword:_keywordCurrentValue];
    [quiz setOption0:_name1CurrentValue];
    [quiz setOption1:_name2CurrentValue];
    [quiz setAnswer:_name1CurrentValue];
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

-(void)chooseName2BtnClicked{
    NSLog(@"author chose %@ over %@ for keyword: %@", _name2CurrentValue, _name1CurrentValue, _keywordCurrentValue);
}

-(void)addTextFields{
    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, 50, 50)];
    _name1TextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 100, 50)];
    _name2TextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 20, 100, 50)];
    [_keywordTextField setText:@"yay"];
    [_name1TextField setText:@"Albert"];
    [_name2TextField setText:@"胖仔"];
    [self.view addSubview:_keywordTextField];
    [self.view addSubview:_name1TextField];
    [self.view addSubview:_name2TextField];
    [_keywordTextField setBorderStyle:UITextBorderStyleNone];
    [_keywordTextField setDelegate:self];
    [_keywordTextField setBackgroundColor:[UIColor yellowColor]];
    [_keywordTextField setTextAlignment:NSTextAlignmentCenter];
    [_name1TextField setBorderStyle:UITextBorderStyleNone];
    [_name2TextField setBorderStyle:UITextBorderStyleNone];
    [_name1TextField setTextAlignment:NSTextAlignmentCenter];
    [_name2TextField setTextAlignment:NSTextAlignmentCenter];
    [_name1TextField setDelegate:self];
    [_name2TextField setDelegate:self];
    [_name1TextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    [_name2TextField addTarget:self
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
    [_name1TextField setText:@"王大明"];
    [_name2TextField setText:@"范冰冰"];
    _name1CurrentValue = [_name1TextField text];
    _name2CurrentValue = [_name2TextField text];
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

-(void) setPerson:(NSString *)person{
    [_ongoingTextField setText:person];
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
    if(textField == _name2TextField || textField == _name1TextField){
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
    if(textField == _name1TextField || textField == _name2TextField){
        _ongoingTextField = textField;
        if(self.delegate && [_delegate respondsToSelector:@selector(shouldDisplayPeople:withPeople:)]){
            NSArray* people = [NSArray arrayWithObjects:@"Iru",@"Wen",@"Henry",@"Albert",@"Sandy",nil];
            [self.delegate shouldDisplayPeople:self withPeople:people];
        }
    } else{
        if(_delegate && [_delegate respondsToSelector:@selector(shouldDisplayKeywords:withKeywords:)]){
            NSArray* keywords = [NSArray arrayWithObjects:@"Iru",@"Wen",@"Henry",@"Albert",@"Sandy",nil];
            [_delegate shouldDisplayKeywords:self withKeywords:keywords];
        }
    }
}

-(void) presentAndEmptyData:(UITextField *)textField{
    [self presentData];
    [textField setText:@""];
}

-(void) recordData{
    _name1CurrentValue = [_name1TextField text];
    _name2CurrentValue = [_name2TextField text];
    _keywordCurrentValue = [_keywordTextField text];
}

-(void) presentData{
    [_name1TextField setText:_name1CurrentValue];
    [_name2TextField setText:_name2CurrentValue];
    [_keywordTextField setText:_keywordCurrentValue];
}

@end