//
//  ProfileNavigationController.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "ProfileNavigationController.h"
#import "ProfileViewController.h"

@interface ProfileNavigationController ()

@end

@implementation ProfileNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelf{
    if([[self.viewControllers firstObject] isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *profileViewController = [self.viewControllers firstObject];
        [profileViewController setName:[KeyChainWrapper getSelfName] andID:[KeyChainWrapper getSelfFBID] sentFromTabbar:YES];
    }
}

-(void)backToRoot{
//    [self popToRootViewControllerAnimated:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",[segue destinationViewController]);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
