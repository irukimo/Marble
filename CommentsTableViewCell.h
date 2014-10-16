//
//  CommentsTableViewCell.h
//  Marble
//
//  Created by Iru on 10/15/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsTableViewCellDelegate;

@interface CommentsTableViewCell : UITableViewCell
- (void) setName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment andTime:(NSString *)time;
@property (nonatomic, weak) id<CommentsTableViewCellDelegate> delegate;
@end


@protocol CommentsTableViewCellDelegate <NSObject>

@required
-(void) gotoProfile:(id)sender;
@end