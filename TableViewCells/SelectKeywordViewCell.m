//
//  SelectKeywordViewCell.m
//  Marble
//
//  Created by Iru on 10/14/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//


#import "SelectKeywordViewCell.h"

@interface SelectKeywordViewCell()
@property(strong, nonatomic) UILabel *keywordLabel;
@end

@implementation SelectKeywordViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.contentView addSubview:_keywordLabel];
        // Initialization code
    }
    return self;
}
-(void) setKeyword:(NSString *)keyword{
    _keyword = keyword;
    [_keywordLabel setText:keyword];
}


@end
