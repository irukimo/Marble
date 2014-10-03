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
#import "ProfileViewController.h"


@interface HomeViewController ()
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) SelectPeopleViewController *selectPeopleViewController;
@property (strong, nonatomic) PostsViewController *postsViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiatePostsViewController];
    [self initiateCreateQuizViewController];
    [self createAnotherCreateQuizViewController];
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void) initiatePostsViewController{
    _postsViewController = [[PostsViewController alloc] init];
    [_postsViewController.view setFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
//    [self.view addSubview:_postsViewController.view];
    _postsViewController.delegate = self;
}


-(void) initiateCreateQuizViewController{
    _createQuizViewController = [[CreateQuizViewController alloc] init];
    [_createQuizViewController.view setFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    [self.view addSubview:_createQuizViewController.view];
//    [_createQuizViewController setDelegate:self];
}

-(void) createAnotherCreateQuizViewController{
    CreateQuizViewController *createQuizViewController = [[CreateQuizViewController alloc] init];
    [createQuizViewController.view setFrame:CGRectMake(0, 400, self.view.frame.size.width, 100)];
    [self.view addSubview:createQuizViewController.view];
    //    [_createQuizViewController setDelegate:self];
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
    _selectPeopleViewController.view.frame = CGRectMake(0, 150, self.view.bounds.size.width, 200);
    _selectPeopleViewController.view.tag = 100;
    _selectPeopleViewController.delegate = self;
}

-(void) postSelected:(NSString *)name{
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:name];
}

#pragma mark -
#pragma mark SelectPeopleViewController Delegate Methods
- (void)selectedPerson:(NSString *)person{
    [_createQuizViewController setPerson:person];
}

#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
    [self prepareSelectPeopleViewController];
    [_selectPeopleViewController setPeopleArray:people];
//    [self.view addSubview:_selectPeopleViewController.view];
    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
}

- (void)backToNormal:(CreateQuizViewController *)viewController{
    for(id view in self.view.subviews){
        if([view tag] == 100){
            [view removeFromSuperview];
        }
    }
    //    NSLog(@"backtonormal");
    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 20,
                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)gotSearchUsersResult:(NSArray *)arrayOfUsers{
    [_selectPeopleViewController displaySearchResult:arrayOfUsers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *viewController =[segue destinationViewController];
        [viewController setName:(NSString *)sender];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
