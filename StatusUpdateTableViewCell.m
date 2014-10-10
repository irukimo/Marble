//
//  StatusUpdateTableViewCell.m
//  Marble
//
//  Created by Iru on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "StatusUpdateTableViewCell.h"

@interface StatusUpdateTableViewCell()
    @property(strong, nonatomic) UILabel *statusLabel;
    @property(strong, nonatomic) UILabel *nameLabel;

@end

@implementation StatusUpdateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 150, 30)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
        [self.contentView addSubview:_statusLabel];
        [self.contentView addSubview:_nameLabel];
        // Initialization code
    }
    return self;
}

- (void) setName:(NSString *)name andStatus:(NSString *)status
{
    [_nameLabel setText:[name copy]];
    [_statusLabel setText:[status copy]];
}

@end
