//
//  HomeViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateQuizViewController.h"
#import "SelectPeopleViewController.h"
#import "PostsViewController.h"
#import "SelectKeywordViewController.h"


@interface HomeViewController : UIViewController <CreateQuizViewControllerDelegate, SelectPeopleViewControllerDelegate, PostsViewControllerDelegate, SelectKeywordViewControllerDelegate>

@end
