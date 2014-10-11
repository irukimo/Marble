//
//  KeywordListTableViewCell.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordListTableViewCell.h"

@interface KeywordListTableViewCell()
@property(strong, nonatomic) UILabel *keywordLabel;
@end


@implementation KeywordListTableViewCell

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
    [_keywordLabel setText:keyword];
}

@end
