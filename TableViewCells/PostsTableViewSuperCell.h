//
//  PostsTableViewSuperCell.h
//  Marble
//
//  Created by Iru on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewSuperCell : UITableViewCell

@property (strong, nonatomic) NSString *cellType;
-(void)setCommentsForPostSuperCell:(NSArray *)comments;
-(void) addStatsLabels;
-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment;

@end
