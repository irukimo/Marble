//
//  QuizViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()
@property (strong, nonatomic) UITextField *keywordTextField;
@property (strong, nonatomic) UITextField *name1TextField;
@property (strong, nonatomic) UITextField *name2TextField;
@property (strong, nonatomic) UIButton *shuffleKeywordBtn;
@property (strong, nonatomic) UIButton *shufflePeopleBtn;
@property (strong, nonatomic) UITextField *ongoingTextField;
@property (strong, nonatomic) NSString *name1CurrentValue;
@property (strong, nonatomic) NSString *name2CurrentValue;
@property (strong, nonatomic) NSString *keywordCurrentValue;

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextFields];
    [self addShuffleButtons];

    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    // Do any additional setup after loading the view.
}

-(void)addTextFields{
    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 50, 50)];
    _name1TextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
    _name2TextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 10, 100, 50)];
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
}

- (void)shufflePeople:(id)sender {
    [_name1TextField setText:@"王大明"];
    [_name2TextField setText:@"范冰冰"];
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

    
//
        
        
        
    [Utility generateAlertWithMessage:@"請選一個朋友"];
    return YES;

//    }
//    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.delegate){
        [self.delegate backToNormal:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self recordAndEmptyData:textField];
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

-(void) recordAndEmptyData:(UITextField *)textField{
    _name1CurrentValue = [_name1TextField text];
    _name2CurrentValue = [_name2TextField text];
    _keywordCurrentValue = [_keywordTextField text];
    [textField setText:@""];
}

@end
