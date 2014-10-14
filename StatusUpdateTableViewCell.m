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
@property (strong, nonatomic) UIImageView *authorPicView;
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@property(strong,nonatomic) NSArray *comments;

@end

@implementation StatusUpdateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStaticLabels];
        [self addTextFields];
        [self initPicView];
        self.cellType = STATUS_UPDATE_CELL_TYPE;
        [super addStatsLabels];
        // Initialization code
    }
    return self;
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

    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 150, 30)];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addSubview:_nameLabel];
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    _authorPicView.layer.cornerRadius = 15;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andStatus:(NSString *)status
{

    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameLabel setAttributedText:nameString];
    [_statusLabel setText:[status copy]];
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
}



@end
