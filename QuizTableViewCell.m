//
//  QuizTableViewCell.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "QuizTableViewCell.h"
#import "FacebookSDK/FacebookSDK.h"
#import "KeyChainWrapper.h"
#import "User+MBUser.h"



@interface QuizTableViewCell()
@property(strong,nonatomic) NSString *option0Name;
@property(strong,nonatomic) NSString *option1Name;
@property(strong,nonatomic) NSString *authorName;
@property(strong,nonatomic) NSString *answerName;
@property(strong,nonatomic) NSString *keyword;
@property(strong,nonatomic) UIButton *option0NameButton;
@property(strong,nonatomic) UIButton *option1NameButton;
@property(strong,nonatomic) UIButton *authorNameButton;

@property(strong,nonatomic) UILabel *keywordLabel;
@property(strong,nonatomic) UILabel *resultLabel;


// for temporary use

@property(strong, nonatomic) UIButton *chooseOption0Button;
@property(strong, nonatomic) UIButton *chooseOption1Button;

@property(strong, nonatomic) UILabel *compareNumLabel;

@property(strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) UIImageView *option0PicView;
@property (strong, nonatomic) UIImageView *option1PicView;

@property(strong, nonatomic) Quiz *quiz;
@end

@implementation QuizTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStaticLabels];
//        [self addChoiceButtons];
        [self addResultLabel];
        [self initPicViews];
        self.cellType = QUIZ_CELL_TYPE;
        [super initializeAccordingToType];
        // Initialization code
    }
    return self;
}


-(void) initPicViews{
    _option0PicView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 45, 135, 135)];
    _option1PicView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 45, 135, 135)];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 50, 50)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    whiteView.layer.cornerRadius = 25;
    whiteView.layer.masksToBounds = YES;
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    _authorPicView.layer.cornerRadius = 22;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_option0PicView];
    [self.contentView addSubview:_option1PicView];
    [self.contentView addSubview:whiteView];
    [self.contentView addSubview:_authorPicView];
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personClicked0)];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personClicked1)];
    [_option0PicView setUserInteractionEnabled:YES];
    [_option1PicView setUserInteractionEnabled:YES];
    [_option0PicView addGestureRecognizer:singleTap0];
    [_option1PicView addGestureRecognizer:singleTap1];
}

/*
-(void) addChoiceButtons{
    _chooseOption0Button = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, 100, 20)];
    _chooseOption1Button = [[UIButton alloc] initWithFrame:CGRectMake(115, 100, 100, 20)];
    [_chooseOption0Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseOption0Button setTitle:@"choose" forState:UIControlStateNormal];
    [_chooseOption1Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseOption1Button setTitle:@"choose" forState:UIControlStateNormal];
    [_chooseOption0Button addTarget:self action:@selector(chooseOption0:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseOption1Button addTarget:self action:@selector(chooseOption1:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chooseOption0Button];
    [self.contentView addSubview:_chooseOption1Button];
}*/


-(void)personClicked0{
    NSLog(@"answer is %@, chose %@",_answerName,_option0Name);
    if([_option0Name isEqualToString:_answerName]){
        [_resultLabel setText:@"correct"];
    } else{
        [_resultLabel setText:@"wrong"];
    }
    MBDebug(@"choose option0 clicked! %@", _option0Name);
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendGuess:withAnswer:)]){
        [self.delegate sendGuess:_option0PicView withAnswer:_option0Name];
    }

}

-(void)personClicked1{
    NSLog(@"answer is %@, chose %@",_answerName,_option1Name);
    if([_option1Name isEqualToString:_answerName]){
        [_resultLabel setText:@"correct"];
    } else{
        [_resultLabel setText:@"wrong"];
    }
    MBDebug(@"choose option0 clicked! %@", _option0Name);
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendGuess:withAnswer:)]){
        [self.delegate sendGuess:_option1PicView withAnswer:_option1Name];
    }
}

-(void) addResultLabel{
    _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 100, 50)];
    [self addSubview:_resultLabel];
}


-(void)addStaticLabels{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(285, 5, 70, 20)];

    _compareNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 180, 50, 20)];

    
    _authorNameButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 8, 120, 20)];
    _option0NameButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 25, 120, 20)];
    _option1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 25, 120, 20)];
    
    [_authorNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option0NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option1NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_option0NameButton addTarget:self action:@selector(option0Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_option1NameButton addTarget:self action:@selector(option1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_authorNameButton addTarget:self action:@selector(authorClicked:) forControlEvents:UIControlEventTouchUpInside];

    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 15, 100, 20)];
    



    [self.contentView addSubview:_compareNumLabel];
    [self.contentView addSubview:_authorNameButton];
    [self.contentView addSubview:_option0NameButton];
    [self.contentView addSubview:_option1NameButton];
    [self.contentView addSubview:_keywordLabel];

    [self.contentView addSubview:_timeLabel];

}

-(void)option0Clicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_quiz.option0Name andID:_quiz.option0];
    }
}
-(void)option1Clicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_quiz.option1Name andID:_quiz.option1];
    }
}

-(void)authorClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_quiz.authorName andID:_quiz.author];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setQuiz:(Quiz *)quiz{
    _quiz = quiz;
    _authorName = [quiz.authorName copy];
    _option0Name = [quiz.option0Name copy];
    _option1Name = [quiz.option1Name copy];
    _answerName = [quiz.answer copy];
    _keyword = [quiz.keyword copy];
    [_compareNumLabel setText:[NSString stringWithFormat:@"%@", quiz.compareNum]];
    
    
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=60&height=60", quiz.author];
    NSString *option0PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=135&height=135", quiz.option0];
    NSString *option1PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=135&height=135", quiz.option1];
    
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [_option0PicView setImageWithURL:[NSURL URLWithString:option0PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [_option1PicView setImageWithURL:[NSURL URLWithString:option1PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    
    NSAttributedString *authorNameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_authorName] attributes:[Utility getPostsViewNameFontDictionary]];
    NSAttributedString *option0NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option0Name] attributes:[Utility getPostsViewNameFontDictionary]];
    NSAttributedString *option1NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option1Name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_authorNameButton setAttributedTitle:authorNameString forState:UIControlStateNormal];
    [_option0NameButton setAttributedTitle:option0NameString forState:UIControlStateNormal];
    [_option1NameButton setAttributedTitle:option1NameString forState:UIControlStateNormal];
    [_keywordLabel setText:_keyword];
    [_timeLabel setText:[Utility getDateToShow:quiz.time inWhole:NO]];
}





@end
