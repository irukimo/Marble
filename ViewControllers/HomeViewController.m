//
//  HomeViewController.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateQuizViewController.h"
#import "SelectPeopleViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) CreateQuizViewController *CreateQuizViewController;
@property (strong, nonatomic) SelectPeopleViewController *selectPeopleViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _CreateQuizViewController = [[CreateQuizViewController alloc] init];
    [_CreateQuizViewController.view setFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
    [self.view addSubview:_CreateQuizViewController.view];
    [_CreateQuizViewController setDelegate:self];
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void) prepareSelectPeopleViewController{
    _selectPeopleViewController = [[SelectPeopleViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectPeopleViewController.view.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
    _selectPeopleViewController.view.tag = 100;
    _selectPeopleViewController.delegate = self;
}

#pragma mark -
#pragma mark SelectPeopleViewController Delegate Methods
- (void)selectedPerson:(NSString *)person{
    [_CreateQuizViewController setPerson:person];
}

#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
    [self prepareSelectPeopleViewController];
    [_selectPeopleViewController setPeopleArray:people];
    [self.view addSubview:_selectPeopleViewController.view];
    _CreateQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                                self.view.bounds.size.width, _CreateQuizViewController.view.frame.size.height);
    
}

- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
    _CreateQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                                self.view.bounds.size.width, _CreateQuizViewController.view.frame.size.height);
}

- (void)backToNormal:(CreateQuizViewController *)viewController{
    for(id view in self.view.subviews){
        if([view tag] == 100){
            [view removeFromSuperview];
        }
    }
    //    NSLog(@"backtonormal");
    _CreateQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 100,
                                                self.view.bounds.size.width, _CreateQuizViewController.view.frame.size.height);
    
}



@end
