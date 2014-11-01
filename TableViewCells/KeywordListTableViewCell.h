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
-(void) setKeyword:(NSString *)keyword;
@property (strong, nonatomic) User *subject;
@end

@protocol KeywordListTableViewCellDelegate <NSObject>
-(void) gotoKeywordProfileWithKeyword:(NSString *)keyword;
@end