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

@property(strong,nonatomic) UIButton *option0NameButton;
@property(strong,nonatomic) UIButton *option1NameButton;
@property(strong,nonatomic) UIButton *authorNameButton;


@property (nonatomic, weak) id<QuizTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *quizUUID;

-(void) setQuiz:(Quiz *)quiz;

@end

@protocol QuizTableViewCellDelegate <NSObject>

@required

- (void) commentPost:(id)sender withComment:(NSString *)comment;
- (void) sendGuess:(id)sender withAnswer:(NSString *)answer;

@end
