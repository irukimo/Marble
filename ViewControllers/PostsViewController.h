//
//  PostsViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizTableViewCell.h"

@protocol PostsViewControllerDelegate;

@interface PostsViewController : UITableViewController <NSFetchedResultsControllerDelegate, QuizTableViewCellDelegate>
@property (strong, nonatomic) NSArray *postArray;
@property (nonatomic, weak) id<PostsViewControllerDelegate> delegate;

@end


@protocol PostsViewControllerDelegate <NSObject>

- (void)postSelected:(NSString *)name andID:(NSString *)fbid;


@end

