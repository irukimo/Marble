//
//  CommentsTableViewCell.m
//  Marble
//
//  Created by Iru on 10/15/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "CommentsTableViewCell.h"

@interface CommentsTableViewCell()
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@implementation CommentsTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStaticLabels];
        [self initPicView];
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}





-(void) addStaticLabels{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(290, 5, 30, 30)];
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT + 50, 22, 150, 30)];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT + 50, 5, 100, 30)];
    [self.contentView addSubview:_commentLabel];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_timeLabel];
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, 5, 40, 40)];
    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.height/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment andTime:(NSString *)time{
    NSLog(@"%@", time);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    [_timeLabel setText:[Utility getDateToShow:date inWhole:NO]];
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameLabel setAttributedText:nameString];
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getWhiteCommentFontDictionary]];
    [_commentLabel setAttributedText:commentString];
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
}

@end
