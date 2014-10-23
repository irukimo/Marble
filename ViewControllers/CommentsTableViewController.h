//
//  CommentsTableViewController.h
//  Marble
//
//  Created by Iru on 10/15/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsTableViewCell.h"

@protocol CommentsTableViewControllerDelegate;

@interface CommentsTableViewController : UITableViewController <CommentsTableViewCellDelegate>

-(void)setCommentArray:(NSArray *)commentArray;
@property (nonatomic, weak) id<CommentsTableViewControllerDelegate> delegate;
@end

@protocol CommentsTableViewControllerDelegate <NSObject>
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid;

@end
