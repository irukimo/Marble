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

@interface PostsViewController : UITableViewController <NSFetchedResultsControllerDelegate, PostsTableViewSuperCellDelegate,UIScrollViewDelegate >

@property (strong, nonatomic) NSPredicate *predicate;
@property (strong, nonatomic) NSDictionary *basicParams;
@property (nonatomic, weak) id<PostsViewControllerDelegate> delegate;
- (void) commentPostAtIndexPath:(NSIndexPath *)indexPath withComment:(NSString *)comment;
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid;
-(void)sendGuessForQuiz:(Quiz *)quiz andAnswer:(NSString *)answer;
-(void)commentPostForPost:(Post *)post withComment:(NSString *)comment;
- (NSMutableDictionary *)generateBasicParams;
@end


@protocol PostsViewControllerDelegate <NSObject>
-(void)sideMenuClicked:(id)sender;


@end

