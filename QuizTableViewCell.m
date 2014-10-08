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
    _authorNameButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _option0NameButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 35, 100, 50)];
    _option1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 35, 100, 50)];
    [_authorNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option0NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option1NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 15, 60, 50)];
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(40, 70, 150, 30)];
    [_commentField setBorderStyle:UITextBorderStyleLine];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 70, 60, 30)];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentQuizClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_authorNameButton];
    [self.contentView addSubview:_option0NameButton];
    [self.contentView addSubview:_option1NameButton];
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

    [_authorNameButton setTitle:[Utility getNameToDisplay:_authorName] forState:UIControlStateNormal];
    [_option0NameButton setTitle:[Utility getNameToDisplay:_option0Name] forState:UIControlStateNormal];
    [_option1NameButton setTitle:[Utility getNameToDisplay:_option1Name] forState:UIControlStateNormal];
    [_keywordLabel setText:_keyword];
}

-(void) commentQuizClicked:(id)sender{
    MBDebug(@"comment quiz clicked!");
    if(_delegate && [_delegate respondsToSelector:@selector(commentQuiz:withComment:)]){
        [_delegate commentQuiz:sender withComment:_commentField.text];
    }
}


@end
