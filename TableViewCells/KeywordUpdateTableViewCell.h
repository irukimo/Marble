//
//  KeywordUpdateTableViewCell.h
//  Marble
//
//  Created by Iru on 10/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsTableViewSuperCell.h"
#import "KeywordUpdate.h"



@interface KeywordUpdateTableViewCell : PostsTableViewSuperCell
@property(strong, nonatomic) UIButton *nameButton;
- (void) setKeywordUpdate:(KeywordUpdate *)keywordUpdate;
@end

