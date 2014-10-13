//
//  KeywordUpdateTableViewCell.h
//  Marble
//
//  Created by Iru on 10/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeywordUpdateTableViewCellDelegate;


@interface KeywordUpdateTableViewCell : UITableViewCell

@property(strong, nonatomic) UIButton *nameButton;
@property (nonatomic, weak) id<KeywordUpdateTableViewCellDelegate> delegate;
-(void)setComments:(NSArray *)comments;
- (void) setName:(NSString *)name andID:(NSString *)fbid andDescription:(NSString *)desc;
@end


@protocol KeywordUpdateTableViewCellDelegate <NSObject>

@required

-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid;
-(void) commentPost:(id)sender withComment:(NSString *)comment;
@end
