//
//  PostsViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizTableViewCell.h"
#import "StatusUpdateTableViewCell.h"
#import "KeywordUpdateTableViewCell.h"
#import "PostsTableViewSuperCell.h"

@protocol PostsViewControllerDelegate;

@interface PostsViewController : UITableViewController <NSFetchedResultsControllerDelegate, PostsViewControllerDelegate >

@property (strong, nonatomic) NSArray *postArray;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSPredicate *predicate;
@property (nonatomic, weak) id<PostsViewControllerDelegate> delegate;

@end


@protocol PostsViewControllerDelegate <NSObject>



@end

