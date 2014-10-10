//
//  StatusUpdateTableViewCell.h
//  Marble
//
//  Created by Iru on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusUpdateTableViewCellDelegate;


@interface StatusUpdateTableViewCell : UITableViewCell

- (void) setName:(NSString *)name andID:(NSString *)fbid andStatus:(NSString *)status;
@property (nonatomic, weak) id<StatusUpdateTableViewCellDelegate> delegate;
@end


@protocol StatusUpdateTableViewCellDelegate <NSObject>

@required

- (void) commentPost:(id)sender withComment:(NSString *)comment;

@end
