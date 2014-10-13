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

@protocol PostsViewControllerDelegate;

@interface PostsViewController : UITableViewController <NSFetchedResultsControllerDelegate, QuizTableViewCellDelegate,StatusUpdateTableViewCellDelegate, KeywordUpdateTableViewCellDelegate >
@property (strong, nonatomic) NSArray *postArray;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, weak) id<PostsViewControllerDelegate> delegate;

@end


@protocol PostsViewControllerDelegate <NSObject>

- (void)postSelected:(NSString *)name andID:(NSString *)fbid;


@end

