//
//  StatusUpdateTableViewCell.m
//  Marble
//
//  Created by Iru on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "StatusUpdateTableViewCell.h"

#define COMMENT_LABEL_TAG 456


@interface StatusUpdateTableViewCell()
@property(strong, nonatomic) UILabel *statusLabel;
@property(strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@property(strong, nonatomic) UILabel *commentNumLabel;
@property(strong,nonatomic) NSArray *comments;

@end

@implementation StatusUpdateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addStaticLabels];
        [self addTextFields];
        [self initPicView];
        // Initialization code
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self removeAllComments];
}

-(void) removeAllComments{
    for(id view in self.contentView.subviews){
        if([view tag] == COMMENT_LABEL_TAG){
            [view removeFromSuperview];
        }
    }
}

-(void) addTextFields{
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, 150, 20)];
    [_commentField setBorderStyle:UITextBorderStyleLine];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, 30, 50, 20)];
    
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentPostClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
    [self.contentView addSubview:_commentField];

}


-(void) commentPostClicked:(id)sender{
    MBDebug(@"comment on status clicked!");
    if(_delegate && [_delegate respondsToSelector:@selector(commentPost:withComment:)]){
        [_delegate commentPost:sender withComment:_commentField.text];
    }
}



-(void) addStaticLabels{
    _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 15, 50, 20)];
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 150, 30)];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_commentNumLabel];
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    _authorPicView.layer.cornerRadius = 15;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andStatus:(NSString *)status
{
    [_nameLabel setText:[name copy]];
    [_statusLabel setText:[status copy]];
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
}

-(void)setComments:(NSArray *)comments{
    _comments = [comments copy];
    [_commentNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_comments count]]];
    [self showComments];
}

-(void) showComments{;
    int y = 50;
    int increment = 20;
    int i = 0;
    for (NSDictionary *cmt in _comments) {
        if(i > 2){
            return;
        }
        [self addCommentAtY:(y+i*increment) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"]];
        i++;
    }
}

-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 100, 20)];
    [nameLabel setTag:COMMENT_LABEL_TAG];
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    CGSize nameSize = [nameString size];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25+3+nameSize.width, y, 150, 20)];
    [commentLabel setTag:COMMENT_LABEL_TAG];
    
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getPostsViewCommentFontDictionary]];
    [nameLabel setAttributedText:nameString];
    [commentLabel setAttributedText:commentString];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:commentLabel];
}


@end
