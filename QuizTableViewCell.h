//
//  QuizTableViewCell.h
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizTableViewCell : UITableViewCell

-(void) setQuizWithAuthor:(NSString *)authorName andOption0:(NSString *)option0Name andOption1:(NSString *)option1Name andKeyword:(NSString *)keyword;

@end
