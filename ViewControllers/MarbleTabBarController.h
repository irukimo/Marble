//
//  MarbleTabBarController.h
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateQuizViewController.h"
#import "CommentsTableViewController.h"


@interface MarbleTabBarController : UITabBarController <UITabBarControllerDelegate,   UITextFieldDelegate, CommentsTableViewControllerDelegate>
-(void) marbleButtonClickedWithUser:(User *)user orKeyword:(NSString *)keyword;
-(void) viewMoreComments:(NSArray *)commentArray atIndexPath:(NSIndexPath *)indexPath calledBy:(id)viewController;
-(void) updateComments:(NSArray *)commentArray;
@end
