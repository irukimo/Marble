//
//  SearchViewController.m
//  Marble
//
//  Created by Iru on 10/6/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "ExploreViewController.h"

@implementation ExploreViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbarTitle];
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_CreateQuizViewController.view action:@selector(endEditing:)]];
    //    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}
-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [[myNavBar topItem] setTitle:@"EXPLORE"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleBlue]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
