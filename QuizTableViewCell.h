//
//  QuizTableViewCell.h
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsTableViewSuperCell.h"
#import "Quiz.h"




@interface QuizTableViewCell : PostsTableViewSuperCell
@property (nonatomic, strong) NSString *quizUUID;
-(void) setQuiz:(Quiz *)quiz;

@end
