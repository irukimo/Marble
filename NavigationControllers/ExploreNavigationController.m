//
//  ExploreNavigationController.m
//  Marble
//
//  Created by Iru on 10/17/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "ExploreNavigationController.h"
#import "ExploreCollectionViewController.h"

@implementation ExploreNavigationController
-(void)backToRoot{
//    [self popToRootViewControllerAnimated:NO];
    if([[self.viewControllers firstObject] isKindOfClass:[ExploreCollectionViewController class]]){
        ExploreCollectionViewController *exploreCollectionViewController = [self.viewControllers firstObject];
        [exploreCollectionViewController initSearchResults];
    }
}
@end
