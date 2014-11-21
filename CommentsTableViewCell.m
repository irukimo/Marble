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
@property (strong, nonatomic) UITextView *commentView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *fbid;

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
    _commentView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT + 45, 20, [KeyChainWrapper getScreenWidth] - (LEFT_ALIGNMENT + 50) - 20, 60)];
    [_commentView setBackgroundColor:[UIColor clearColor]];
    [_commentView setUserInteractionEnabled:NO];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT + 50, 5, 100, 30)];
    [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_nameButton addTarget:self action:@selector(gotoProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentView];
    [self.contentView addSubview:_nameButton];
    [self.contentView addSubview:_timeLabel];
}

-(void)gotoProfile{
    if(_delegate && [_delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [_delegate gotoProfileWithName:_name andID:_fbid];
    }
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, 5, 40, 40)];
    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.height/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment andTime:(NSString *)time{
    _name = name;
    _fbid = fbid;
    NSDate *date = [Utility DateForRFC3339DateTimeString:time];
    NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:date inWhole:NO] attributes:[Utility getWhiteCommentFontDictionary]];
    [_timeLabel setAttributedText:dateString];
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getWhiteCommentFontDictionary]];
    [_commentView setAttributedText:commentString];
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:fbid];
}

@end
