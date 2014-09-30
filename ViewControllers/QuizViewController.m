//
//  QuizViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UITextField *name1TextField;
@property (weak, nonatomic) IBOutlet UITextField *name2TextField;

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_keywordTextField setText:@"yay"];
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

    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shuffleKeyword:(id)sender {
    [_keywordTextField setText:@"人性"];
}
- (IBAction)shufflePeople:(id)sender {
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

#pragma mark -
#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == _keywordTextField) {
    [textField resignFirstResponder];
    if(self.delegate){
        [self.delegate backToNormal:self];
    }
    return NO;

//    }
//    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.delegate){
        [self.delegate backToNormal:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _name1TextField || _name2TextField){
        if(self.delegate){
            NSArray* people = [NSArray arrayWithObjects:@"obj1",@"obj2",@"ibj3",@"obj4",@"obj5",nil];
            [self.delegate shouldDisplayPeople:self withPeople:people];
        }
    } else{
        if(self.delegate){
            NSArray* keywords = [NSArray arrayWithObjects:@"obj1",@"obj2",@"ibj3",@"obj4",@"obj5",nil];
            [self.delegate shouldDisplayKeywords:self withKeywords:keywords];
        }
    }
}

@end
