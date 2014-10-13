//
//  QuizTableViewCell.h
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"

@protocol QuizTableViewCellDelegate;


@interface QuizTableViewCell : UITableViewCell




@property (nonatomic, weak) id<QuizTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *quizUUID;
-(void)setComments:(NSArray *)comments;
-(void) setQuiz:(Quiz *)quiz;

@end

@protocol QuizTableViewCellDelegate <NSObject>

@required

- (void) commentPost:(id)sender withComment:(NSString *)comment;
- (void) sendGuess:(id)sender withAnswer:(NSString *)answer;
-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid;

@end
