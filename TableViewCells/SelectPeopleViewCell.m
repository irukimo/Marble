//
//  SelectPeopleViewCell.m
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "SelectPeopleViewCell.h"

static const imageWidth = 40;

@interface SelectPeopleViewCell()
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *IDLabel;
@property(strong, nonatomic) UIImageView *personImageView;
@end

@implementation SelectPeopleViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 320, 50)];
        [self.contentView addSubview:_nameLabel];
        _personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, imageWidth, imageWidth)];
        [_personImageView.layer setCornerRadius:imageWidth/2.0f];
        [_personImageView.layer setMasksToBounds:YES];
        [self.contentView addSubview:_personImageView];
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

-(void) setPersonName:(NSString *)personName andfbID:(NSString *)fbID{
    _personName = personName;
    NSAttributedString *personString = [[NSAttributedString alloc] initWithString:_personName attributes:[Utility getSearchResultFontDictionary]];
    [_nameLabel setAttributedText:personString];
    [Utility setUpProfilePictureImageView:_personImageView byFBID:fbID];
}

@end
