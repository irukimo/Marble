//
//  KeywordListTableViewCell.h
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol KeywordListTableViewCellDelegate;

@interface KeywordListTableViewCell : UITableViewCell

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSNumber *index;

-(void) setKeyword:(NSString *)keyword;
@property (strong, nonatomic) User *subject;
@end

@protocol KeywordListTableViewCellDelegate <NSObject>
-(void) gotoKeywordProfileWithKeyword:(NSString *)keyword;
-(void) gotoProfile:(id)sender;
@end
