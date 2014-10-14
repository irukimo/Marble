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
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fbid;
@property (strong,nonatomic) NSArray *comments;
@property(strong, nonatomic) UIButton *commentBtn;
@property(strong, nonatomic) UITextField *commentField;
@end

@implementation KeywordUpdateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initStaticButtonsAndLabels];
        [self addTextFields];

        [self initProfilePic];
        self.cellType = KEYWORD_UPDATE_CELL_TYPE;
        [super addStatsLabels];
        // Initialization code
    }
    return self;
}


-(void)initStaticButtonsAndLabels{
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 300, 30)];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_nameButton];
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
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    [_descriptionLabel setText:[desc copy]];
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
}

-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    _authorPicView.layer.cornerRadius = 22;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

@end
