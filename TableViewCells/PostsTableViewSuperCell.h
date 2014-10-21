//
//  PostsTableViewSuperCell.h
//  Marble
//
//  Created by Iru on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostsViewControllerDelegate;

@interface PostsTableViewSuperCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, weak) id delegate;
@property (strong, nonatomic) NSString *cellType;
-(void)setCommentsForPostSuperCell:(NSArray *)comments;
-(void) initializeAccordingToType;
-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment;

@end


@protocol PostsViewControllerDelegate <NSObject>

@required

- (void) commentPost:(id)sender withComment:(NSString *)comment;
- (void) sendGuess:(id)sender withAnswer:(NSString *)answer;
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid;
-(void) presentCellWithKeywordOn:(id) sender;
-(void) endPresentingCellWithKeywordOn;
-(void) viewMoreComments:(id)sender;
-(void) gotoKeywordProfileWithKeyword:(NSString *)keyword;
@end
