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
@property (strong, nonatomic) SelectKeywordViewController *selectKeywordViewController;
@property (strong, nonatomic) PostsViewController *postsViewController;
@property (nonatomic) BOOL isCreatingMarble;
@property (strong, nonatomic) UIView *marbleView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initiatePostsViewController];
    [self initiateMarbleViewAndCreateQuizViewController];
    [self setNavbarTitle];
    [self addMarbleButton];
    _isCreatingMarble = FALSE;
    self.delegate = self;
    self.type = HOME_POSTS_TYPE;
    

    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustFloatingViewFrame];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        [self adjustFloatingViewFrame];
    }
}

- (void)adjustFloatingViewFrame
{
    CGRect newFrame = _marbleView.frame;
    
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y;
    
    _marbleView.frame = newFrame;
    [self.tableView bringSubviewToFront:_marbleView];
}

-(void) addMarbleButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"+"
                                   style: UIBarButtonItemStyleBordered
                                    target:self action: @selector(marbleButtonClicked:)];
    
    [self.navigationItem setRightBarButtonItem:rightButton];
}

-(void) marbleButtonClicked:(id)sender{
    if(_isCreatingMarble){
        [_marbleView removeFromSuperview];
//        [self.tableView setUserInteractionEnabled:YES];
        _isCreatingMarble = FALSE;
    } else{
        [self.view addSubview:_marbleView];
//        [self.tableView setUserInteractionEnabled:NO];
        _isCreatingMarble = TRUE;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [[myNavBar topItem] setTitle:@"MARBLES"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleOrange]];
}
    
-(void) initiatePostsViewController{
    _postsViewController = [[PostsViewController alloc] init];
    [_postsViewController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TABBAR_HEIGHT)];
    [self.view addSubview:_postsViewController.view];
    _postsViewController.delegate = self;
}


-(void) initiateMarbleViewAndCreateQuizViewController{
    _marbleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _marbleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    _createQuizViewController = [[CreateQuizViewController alloc] init];
    _createQuizViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [_createQuizViewController setDelegate:self];
    [_marbleView addSubview:_createQuizViewController.view];
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
    [_marbleView addSubview:_selectPeopleViewController.view];
}

-(void) prepareSelectKeywordViewController{
    _selectKeywordViewController = [[SelectKeywordViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectKeywordViewController.view.frame = CGRectMake(0, 150, self.view.bounds.size.width, 200);
    _selectKeywordViewController.view.tag = 100;
    _selectKeywordViewController.delegate = self;
    [_marbleView addSubview:_selectKeywordViewController.view];
}

-(void) postSelected:(NSString *)name andID:(NSString *)fbid{
    
}

#pragma mark -
#pragma mark SelectPeopleViewController Delegate Methods
- (void)selectedPerson:(User *)user{
    [_createQuizViewController setUser:user];
}

#pragma mark -
#pragma mark CreateQuizViewController Delegate Methods
- (void)shouldDisplayPeople:(CreateQuizViewController *)viewController withPeople:(NSArray *)people{
    [self prepareSelectPeopleViewController];
//    [_selectPeopleViewController setPeopleArray:people];
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 50,
//                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)shouldDisplayKeywords:(CreateQuizViewController *)viewController withKeywords:(NSArray *)keywords{
    [self prepareSelectKeywordViewController];
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 50,
//                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
}

- (void)backToNormal:(CreateQuizViewController *)viewController{
    for(id view in _marbleView.subviews){
        if([view tag] == 100){
            [view removeFromSuperview];
        }
    }
    //    NSLog(@"backtonormal");
//    _createQuizViewController.view.frame = CGRectMake(self.view.frame.origin.x, 65,
//                                                self.view.bounds.size.width, _createQuizViewController.view.frame.size.height);
    
}

- (void)gotSearchUsersResult:(NSArray *)arrayOfUsers{
    [_selectPeopleViewController displaySearchResult:arrayOfUsers];
}



@end
