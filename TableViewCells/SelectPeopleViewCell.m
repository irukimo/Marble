//
//  SelectPeopleViewCell.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "SelectPeopleViewCell.h"

@interface SelectPeopleViewCell()
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *IDLabel;
@end

@implementation SelectPeopleViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.contentView addSubview:_nameLabel];
        _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 320, 50)];
        [self.contentView addSubview:_IDLabel];
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setPersonName:(NSString *)personName{
    _personName = personName;
    [_nameLabel setText:personName];
}

-(void) setID:(NSString *)ID{
    _ID = ID;
    [_IDLabel setText:ID];
}

@end
