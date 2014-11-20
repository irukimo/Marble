//
//  PostsTableViewSuperCell.h
//  Marble
//
//  Created by Iru on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostsTableViewSuperCellDelegate;

@interface PostsTableViewSuperCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, weak) id delegate;
@property (nonatomic) PostCellType cellType;
-(void)setCommentsForPostSuperCell:(NSArray *)comments;
-(void) initializeAccordingToType;
-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment;
-(void)resizeWhiteBackground;
-(void)setTimeForTimeLabel:(NSDate *)time;
@end


@protocol PostsTableViewSuperCellDelegate <NSObject>

@required

- (void) commentPost:(id)sender withComment:(NSString *)comment;
- (void) sendGuess:(id)sender withAnswer:(NSString *)answer;
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid;
-(void) presentCellWithKeywordOn:(id) sender;
-(void) endPresentingCellWithKeywordOn;
-(void) viewMoreComments:(id)sender;
-(void) gotoKeywordProfileWithKeyword:(NSString *)keyword;
-(void)tappedTableView;
@end
