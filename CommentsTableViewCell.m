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
@property (strong, nonatomic) UIButton *nameButton;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
    }
    return self;
}





-(void) addStaticLabels{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth] - 60, 5, 80, 30)];
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT + 50, 22, 150, 30)];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT + 50, 5, 100, 30)];
    [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_nameButton addTarget:_delegate action:@selector(gotoProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentLabel];
    [self.contentView addSubview:_nameButton];
    [self.contentView addSubview:_timeLabel];
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, 5, 40, 40)];
    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.height/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment andTime:(NSString *)time{
    NSDate *date = [Utility DateForRFC3339DateTimeString:time];
    NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:date inWhole:NO] attributes:[Utility getWhiteCommentFontDictionary]];
    [_timeLabel setAttributedText:dateString];
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getWhiteCommentFontDictionary]];
    [_commentLabel setAttributedText:commentString];
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:fbid];
}

@end
