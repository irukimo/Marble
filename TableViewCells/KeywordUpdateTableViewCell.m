//
//  KeywordUpdateTableViewCell.m
//  Marble
//
//  Created by Iru on 10/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordUpdateTableViewCell.h"

@interface KeywordUpdateTableViewCell()
@property(strong, nonatomic) UILabel *descriptionLabel;
@property(strong, nonatomic) UILabel *nameLabel;

@end

@implementation KeywordUpdateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
        [self.contentView addSubview:_descriptionLabel];
//        [self.contentView addSubview:_nameLabel];

        // Initialization code
    }
    return self;
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andDescription:(NSString *)desc
{
    [_nameLabel setText:[name copy]];
    [_descriptionLabel setText:[desc copy]];
}

@end
