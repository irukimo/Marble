//
//  QuizTableViewCell.h
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuizTableViewCellDelegate;


@interface QuizTableViewCell : UITableViewCell

@property (nonatomic, weak) id<QuizTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *quizUUID;

-(void) setQuizWithAuthor:(NSString *)authorName andOption0:(NSString *)option0Name andOption1:(NSString *)option1Name andKeyword:(NSString *)keyword;

@end

@protocol QuizTableViewCellDelegate <NSObject>

@required

- (void) commentQuiz:(id)sender withComment:(NSString *)comment;

@end
