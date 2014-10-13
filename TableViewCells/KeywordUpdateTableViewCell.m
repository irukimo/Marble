//
//  KeywordUpdateTableViewCell.m
//  Marble
//
//  Created by Iru on 10/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordUpdateTableViewCell.h"
#define COMMENT_LABEL_TAG 456

@interface KeywordUpdateTableViewCell()
@property(strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fbid;
@property (strong,nonatomic) NSArray *comments;
@property(strong, nonatomic) UILabel *commentNumLabel;
@property(strong, nonatomic) UIButton *commentBtn;
@property(strong, nonatomic) UITextField *commentField;
@end

@implementation KeywordUpdateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initStaticButtonsAndLabels];
        [self addTextFields];

        [self initProfilePic];
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

-(void)initStaticButtonsAndLabels{
    _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 15, 50, 20)];
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 300, 30)];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_nameButton];
    [self.contentView addSubview:_commentNumLabel];
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

-(void)nameClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [_delegate gotoProfileWithName:_name andID:_fbid];
    }
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andDescription:(NSString *)desc
{
    _name = [name copy];
    _fbid = [fbid copy];
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:_name attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    [_descriptionLabel setText:[desc copy]];
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
}

-(void)setComments:(NSArray *)comments{
    _comments = [comments copy];
    [_commentNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_comments count]]];
    [self showComments];
}

-(void) showComments{;
    int y = 70;
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 100, 20)];
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 150, 20)];
    [nameLabel setTag:COMMENT_LABEL_TAG];
    [commentLabel setTag:COMMENT_LABEL_TAG];
    [nameLabel setText:name];
    [commentLabel setText:comment];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:commentLabel];
}


-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    _authorPicView.layer.cornerRadius = 22;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

@end
