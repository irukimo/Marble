//
//  MarbleTabBarController.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "MarbleTabBarController.h"
#import "ProfileNavigationController.h"
#import "HomeNavigationController.h"

#define AUTO_COMPLETE_SELECT_VIEW_TAG 999

@interface MarbleTabBarController ()
@property (strong, nonatomic) CreateQuizViewController *createQuizViewController;
@property (strong, nonatomic) SelectPeopleViewController *selectPeopleViewController;
@property (strong, nonatomic) SelectKeywordViewController *selectKeywordViewController;
@property (strong, nonatomic) UIView *createQuizWholeView;
@property (nonatomic) BOOL isCreatingMarble;
@end

@implementation MarbleTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCreateQuizView];
    self.delegate = self;
    _isCreatingMarble = FALSE;
    
    //set tabbaritem image
    [self setTabBarItemImages];
    // set tabbaritem font
    NSDictionary *selectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor marbleOrange] ,NSForegroundColorAttributeName,nil];
    NSDictionary *unSelectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor unselected] ,NSForegroundColorAttributeName,nil];
    for(UIViewController *v in self.customizableViewControllers){
        [v.tabBarItem setTitleTextAttributes:unSelectedFont forState:UIControlStateNormal];
        [v.tabBarItem setTitleTextAttributes:selectedFont forState:UIControlStateHighlighted];
        v.tabBarItem.image = [v.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        v.tabBarItem.selectedImage = [v.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    // Do any additional setup after loading the view.
}

#pragma mark - UI methods
-(void) setTabBarItemImages{
    
    UIViewController *firstVC = [self.customizableViewControllers objectAtIndex:0];
    [firstVC.tabBarItem setImage:[UIImage imageNamed:@"home-unselected.png"]];
    [firstVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"home-selected.png"]];
    UIViewController *secondVC = [self.customizableViewControllers objectAtIndex:1];
    [secondVC.tabBarItem setImage:[UIImage imageNamed:@"explore-unselected.png"]];
    [secondVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"explore-selected.png"]];
    UIViewController *thirdVC = [self.customizableViewControllers objectAtIndex:2];
    [thirdVC.tabBarItem setImage:[UIImage imageNamed:@"user-unselected.png"]];
    [thirdVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"user-selected.png"]];
    UIViewController *fourthVC = [self.customizableViewControllers objectAtIndex:3];
    [fourthVC.tabBarItem setImage:[UIImage imageNamed:@"notif-unselected.png"]];
    [fourthVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"notif-selected.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    NSLog(@"selectedViewController");
    if([viewController isKindOfClass:[HomeNavigationController class]]){
        HomeNavigationController *homeNavigationController = (HomeNavigationController *)viewController;
        [homeNavigationController backToRoot];
    }
    if([viewController isKindOfClass:[ProfileNavigationController class]]){
        ProfileNavigationController *profileNavigationController = (ProfileNavigationController *)viewController;
        [profileNavigationController setSelf];
        [profileNavigationController backToRoot];
        NSLog(@"sent Iru Wang");
    }
    //    if([viewController isKindOfClass:MyPostsViewController.class]){
    //        //dont add it in here, add it in my post
    //        //self.navigationItem.rightBarButtonItem = _settingBtn;
    //        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, WIDTH, NAVIGATION_BAR_CUT_DOWN_HEIGHT)];
    //    }
    //    else{
    //        self.navigationItem.rightBarButtonItem = NULL;
    //        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, NAVIGATION_BAR_CUT_DOWN_HEIGHT, NAVIGATION_BAR_CUT_DOWN_HEIGHT)];
    //    }
}

-(void) marbleButtonClicked{
    if(_isCreatingMarble){
        [_createQuizWholeView removeFromSuperview];
        _isCreatingMarble = FALSE;
    } else{
        [self.view addSubview:_createQuizWholeView];
        _isCreatingMarble = TRUE;
    }
    
}


-(void)initCreateQuizView{
    UIView *blackBGView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [blackBGView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marbleButtonClicked)];
    [blackBGView addGestureRecognizer:singleTap];
    
    _createQuizViewController = [[CreateQuizViewController alloc] init];
    _createQuizViewController.delegate = self;
    _createQuizViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    _createQuizWholeView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [_createQuizWholeView addSubview:blackBGView];
    [_createQuizWholeView addSubview:_createQuizViewController.view];

}

-(void) prepareSelectPeopleViewController{
    _selectPeopleViewController = [[SelectPeopleViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectPeopleViewController.view.frame = CGRectMake(0, 150, self.view.bounds.size.width, 200);
    _selectPeopleViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectPeopleViewController.delegate = self;
    [_createQuizWholeView addSubview:_selectPeopleViewController.view];
}

-(void) prepareSelectKeywordViewController{
    _selectKeywordViewController = [[SelectKeywordViewController alloc] init];
    //    _selectPeopleViewController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200, self.view.bounds.size.width, 100);
    _selectKeywordViewController.view.frame = CGRectMake(0, 150, self.view.bounds.size.width, 200);
    _selectKeywordViewController.view.tag = AUTO_COMPLETE_SELECT_VIEW_TAG;
    _selectKeywordViewController.delegate = self;
    [_createQuizWholeView addSubview:_selectKeywordViewController.view];
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
    for(id view in _createQuizWholeView.subviews){
        if([view tag] == AUTO_COMPLETE_SELECT_VIEW_TAG){
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

#pragma mark -
#pragma mark SelectPeopleViewController Delegate Methods
- (void)selectedPerson:(User *)user{
    [_createQuizViewController setUser:user];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
