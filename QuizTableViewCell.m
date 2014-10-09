//
//  QuizTableViewCell.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "QuizTableViewCell.h"
#import "FacebookSDK/FacebookSDK.h"

@interface QuizTableViewCell()
@property(strong,nonatomic) NSString *option0Name;
@property(strong,nonatomic) NSString *option1Name;
@property(strong,nonatomic) NSString *authorName;
@property(strong,nonatomic) NSString *answerName;
@property(strong,nonatomic) NSString *keyword;

@property(strong,nonatomic) UILabel *keywordLabel;
@property(strong,nonatomic) UILabel *resultLabel;


// for temporary use
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@property(strong, nonatomic) UIButton *chooseOption0Button;
@property(strong, nonatomic) UIButton *chooseOption1Button;

@end

@implementation QuizTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setLabels];
        [self addChoiceButtons];
        [self addResultLabel];
        [self initFBPicViews];
        // Initialization code
    }
    return self;
}

-(void) initFBPicViews{
    _option0PicView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 50, 50)];
    _option1PicView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 45, 50, 50)];
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    _option0PicView.layer.cornerRadius = 5;
    _option0PicView.layer.masksToBounds = YES;
    _option1PicView.layer.cornerRadius = 5;
    _option1PicView.layer.masksToBounds = YES;
    _authorPicView.layer.cornerRadius = 15;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_option0PicView];
    [self.contentView addSubview:_option1PicView];
    [self.contentView addSubview:_authorPicView];
}

-(void) addChoiceButtons{
    _chooseOption0Button = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, 100, 20)];
    _chooseOption1Button = [[UIButton alloc] initWithFrame:CGRectMake(115, 100, 100, 20)];
    [_chooseOption0Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseOption0Button setTitle:@"choose" forState:UIControlStateNormal];
    [_chooseOption1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseOption1Button setTitle:@"choose" forState:UIControlStateNormal];
    [_chooseOption0Button addTarget:self action:@selector(chooseOption0:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseOption1Button addTarget:self action:@selector(chooseOption1:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chooseOption0Button];
    [self addSubview:_chooseOption1Button];
}

-(void) chooseOption0:(id)sender{
    NSLog(@"answer is %@, chose %@",_answerName,_option0Name);
    if([_option0Name isEqualToString:_answerName]){
        [_resultLabel setText:@"correct"];
    } else{
        [_resultLabel setText:@"wrong"];
    }
    MBDebug(@"choose option0 clicked! %@", _option0Name);
    if(_delegate && [_delegate respondsToSelector:@selector(sendGuess:withAnswer:)]){
        [_delegate sendGuess:sender withAnswer:_option0Name];
    }

}

-(void) chooseOption1:(id)sender{
    NSLog(@"answer is %@, chose %@",_answerName,_option1Name);
    if([_option1Name isEqualToString:_answerName]){
        [_resultLabel setText:@"correct"];
    } else{
        [_resultLabel setText:@"wrong"];
    }
    MBDebug(@"choose option0 clicked! %@", _option0Name);
    if(_delegate && [_delegate respondsToSelector:@selector(sendGuess:withAnswer:)]){
        [_delegate sendGuess:sender withAnswer:_option1Name];
    }
}

-(void) addResultLabel{
    _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 45, 100, 50)];
    [self addSubview:_resultLabel];
}


-(void)setLabels{
    _authorNameButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 100, 20)];
    _option0NameButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 100, 20)];
    _option1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 30, 100, 20)];
    
    [_authorNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option0NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option1NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 15, 60, 20)];
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(40, 120, 150, 30)];
    [_commentField setBorderStyle:UITextBorderStyleLine];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 120, 50, 30)];

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


-(void) setQuizWithAuthor:(NSString *)authorName withID:(NSString *)authorID andOption0:(NSString *)option0Name withID:(NSString *)option0ID andOption1:(NSString *)option1Name withID:(NSString *)option1ID andKeyword:(NSString *)keyword andAnswer:(NSString *)answer{
    _authorName = [authorName copy];
    _option0Name = [option0Name copy];
    _option1Name = [option1Name copy];
    _answerName = [answer copy];
    _keyword = [keyword copy];
    
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", authorID];
    NSString *option0PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100", option0ID];
    NSString *option1PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100", option1ID];
    
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [_option0PicView setImageWithURL:[NSURL URLWithString:option0PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [_option1PicView setImageWithURL:[NSURL URLWithString:option1PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    

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
