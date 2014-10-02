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

@interface MarbleTabBarController ()

@end

@implementation MarbleTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
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
        [profileNavigationController setSelf:@"Iru Wang"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
