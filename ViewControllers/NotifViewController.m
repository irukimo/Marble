//
//  NotifViewController.m
//  Marble
//
//  Created by Albert Shih on 10/7/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "NotifViewController.h"

@interface NotifViewController ()

@end

@implementation NotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbarTitle];
    // Do any additional setup after loading the view.
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [[myNavBar topItem] setTitle:@"NOTIFICATIONS"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleBlue]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleBlue]];
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
