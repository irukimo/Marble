//
//  QuizTableViewCell.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "QuizTableViewCell.h"

@interface QuizTableViewCell()
@property(strong,nonatomic) NSString *option0Name;
@property(strong,nonatomic) NSString *option1Name;
@property(strong,nonatomic) NSString *authorName;
@property(strong,nonatomic) NSString *keyword;
@property(strong,nonatomic) UILabel *option0NameLabel;
@property(strong,nonatomic) UILabel *option1NameLabel;
@property(strong,nonatomic) UILabel *authorNameLabel;
@property(strong,nonatomic) UILabel *keywordLabel;

// for temporary commenting use
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@end

@implementation QuizTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setLabels];
        // Initialization code
    }
    return self;
}

-(void)setLabels{
    _authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 50)];
    _option0NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 60, 50)];
    _option1NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, 60, 50)];
    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 15, 60, 50)];
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(40, 70, 150, 30)];
    [_commentField setBorderStyle:UITextBorderStyleLine];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 70, 60, 30)];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentQuizClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_authorNameLabel];
    [self.contentView addSubview:_option0NameLabel];
    [self.contentView addSubview:_option1NameLabel];
    [self.contentView addSubview:_keywordLabel];
    [self.contentView addSubview:_commentField];
    [self.contentView addSubview:_commentBtn];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setQuizWithAuthor:(NSString *)authorName andOption0:(NSString *)option0Name andOption1:(NSString *)option1Name andKeyword:(NSString *)keyword{
    _authorName = [authorName copy];
    _option0Name = [option0Name copy];
    _option1Name = [option1Name copy];
    _keyword = [keyword copy];

    [_authorNameLabel setText:_authorName];
    [_option0NameLabel setText:_option0Name];
    [_option1NameLabel setText:_option1Name];
    [_keywordLabel setText:_keyword];
}

-(void) commentQuizClicked:(id)sender{
    MBDebug(@"comment quiz clicked!");
    if(_delegate && [_delegate respondsToSelector:@selector(commentQuiz:withComment:)]){
        [_delegate commentQuiz:sender withComment:_commentField.text];
    }
}


@end
