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
#import "MarbleTabBarController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbarTitle];
   
    [self.tableView triggerPullToRefresh];
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [self setNavbarTitle];
}

-(void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self setNavbarTitle];
}
#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self adjustFloatingViewFrame];
//}

#pragma mark - KVO

//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context {
//    if([keyPath isEqualToString:@"frame"]) {
//        [self adjustFloatingViewFrame];
//    }
//}
//
//- (void)adjustFloatingViewFrame
//{
//    CGRect newFrame = _marbleView.frame;
//    
//    newFrame.origin.x = 0;
//    newFrame.origin.y = self.tableView.contentOffset.y;
//    
//    _marbleView.frame = newFrame;
//    [self.tableView bringSubviewToFront:_marbleView];
//}






-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [myNavBar setTitleTextAttributes:[Utility getNavigationBarTitleFontDictionary]];
    [[myNavBar topItem] setTitle:@"News Feed"];

    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleOrange]];
    UIImage *sliderImage = [Utility imageWithImage:[UIImage imageNamed:@"slider_menu.png"] scaledToSize:CGSizeMake(25, 25)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                            initWithImage:sliderImage
                                   style: UIBarButtonItemStyleBordered
                                   target:self action:@selector(menuButtonClicked:)];
    
    [self.navigationItem setRightBarButtonItem:menuButton];
}

-(void)menuButtonClicked:(id)sender{
    if([[self tabBarController] isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *tb = (MarbleTabBarController *)[self tabBarController];
        [tb menuButtonClicked:sender];
    }
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






@end
