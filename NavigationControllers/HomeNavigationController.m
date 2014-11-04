//
//  HomeNavigationController.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "HomeNavigationController.h"
#import "MarbleTabBarController.h"

@interface HomeNavigationController ()

@end

@implementation HomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToRoot{
    [self popToRootViewControllerAnimated:NO];
    if([self.tabBarController isKindOfClass:[MarbleTabBarController class]]){
        MarbleTabBarController *tabbarcontroller = (MarbleTabBarController *)self.tabBarController;
        tabbarcontroller.lookingAtEitherUserOrKeyword = nil;
    }
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
