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
    
    //set tabbaritem image
    [self setTabBarItemImages];
    // set tabbaritem font
    NSDictionary *selectedFont = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor marbleBlue] ,NSForegroundColorAttributeName,nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
