//
//  QuizTableViewCell.m
//  Marble
//
//  Created by Iru on 10/1/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "QuizTableViewCell.h"
#import "FacebookSDK/FacebookSDK.h"
#import "User+MBUser.h"
#define CORRECT_WRONG_ICON_TAG 768


@interface QuizTableViewCell()
@property(strong,nonatomic) NSString *option0Name;
@property(strong,nonatomic) NSString *option1Name;
@property(strong,nonatomic) NSString *authorName;
@property(strong,nonatomic) NSString *answerName;
@property(strong,nonatomic) NSString *keyword;
@property(strong,nonatomic) UIButton *option0NameButton;
@property(strong,nonatomic) UIButton *option1NameButton;
@property(strong,nonatomic) UIButton *authorNameButton;
@property(strong, nonatomic) UIView *option0Mask;
@property(strong, nonatomic) UIView *option1Mask;
@property(strong, nonatomic) UILabel *option0CorrectIcon;
@property(strong, nonatomic) UILabel *option0WrongIcon;
@property(strong, nonatomic) UILabel *option1CorrectIcon;
@property(strong, nonatomic) UILabel *option1WrongIcon;



@property(strong,nonatomic) UILabel *keywordLabel;


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
        [self initPicViews];
        [self addStaticLabels];
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
    
    _option0Mask = [[UIView alloc] initWithFrame:_option0PicView.frame];
    _option1Mask = [[UIView alloc] initWithFrame:_option1PicView.frame];
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOption0)];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOption1)];
    [_option0Mask setUserInteractionEnabled:YES];
    [_option1Mask setUserInteractionEnabled:YES];
    [_option0Mask addGestureRecognizer:singleTap0];
    [_option1Mask addGestureRecognizer:singleTap1];
    [self initCorrectWrongIcons];
    
    [self.contentView addSubview:_option0PicView];
    [self.contentView addSubview:_option1PicView];
    [self.contentView addSubview:_option0Mask];
    [self.contentView addSubview:_option1Mask];
    [self.contentView addSubview:_option0WrongIcon];
    [self.contentView addSubview:_option0CorrectIcon];
    [self.contentView addSubview:_option1WrongIcon];
    [self.contentView addSubview:_option1CorrectIcon];
    [self.contentView addSubview:whiteView];
    [self.contentView addSubview:_authorPicView];

}
-(void) initCorrectWrongIcons{
    _option0CorrectIcon = [[UILabel alloc] initWithFrame:_option0PicView.frame];
    _option0WrongIcon =[[UILabel alloc] initWithFrame:_option0PicView.frame];
    _option1CorrectIcon = [[UILabel alloc] initWithFrame:_option1PicView.frame];
    _option1WrongIcon =[[UILabel alloc] initWithFrame:_option1PicView.frame];
    [_option0CorrectIcon setText:@"correct"];
    [_option1CorrectIcon setText:@"correct"];
    [_option0WrongIcon setText:@"wrong"];
    [_option1WrongIcon setText:@"wrong"];
    [_option0CorrectIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option1CorrectIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option0WrongIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option1WrongIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option0CorrectIcon setTextColor:[UIColor whiteColor]];
    [_option1CorrectIcon setTextColor:[UIColor whiteColor]];
    [_option0WrongIcon setTextColor:[UIColor whiteColor]];
    [_option1WrongIcon setTextColor:[UIColor whiteColor]];
}

-(void) removeAllCorrectWrongIcons{
    for(UIView *view in self.contentView.subviews){
        if([view tag] == CORRECT_WRONG_ICON_TAG){
            [view removeFromSuperview];
        }
    }
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


-(void)chooseOption0{
    [self displayAlreadyGuessed:_option0Name];
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendGuess:withAnswer:)]){
        [self.delegate sendGuess:_option0PicView withAnswer:_option0Name];
    }

}

-(void)chooseOption1{
    [self displayAlreadyGuessed:_option1Name];
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendGuess:withAnswer:)]){
        [self.delegate sendGuess:_option1PicView withAnswer:_option1Name];
    }
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

    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 120, 100, 20)];
    [_keywordLabel setTextColor:[UIColor whiteColor]];
    



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
    [self removeAllCorrectWrongIcons];
    _quiz = quiz;
    _authorName = [quiz.authorName copy];
    _option0Name = [quiz.option0Name copy];
    _option1Name = [quiz.option1Name copy];
    _answerName = [quiz.answer copy];
    _keyword = [quiz.keyword copy];
    [_compareNumLabel setText:[NSString stringWithFormat:@"%@", quiz.compareNum]];
    
    [self setupProfileViews];
    [self setupNameButtons];
    [_keywordLabel setText:_keyword];
    [_timeLabel setText:[Utility getDateToShow:quiz.time inWhole:NO]];
    
    if(_quiz.guessed){
        [self displayAlreadyGuessed:_quiz.guessed];
    } else{
        [self setUnselectAll];
    }
}

-(void) displayAlreadyGuessed:(NSString *)personGuessed{
    if([personGuessed isEqualToString:_quiz.option0Name]){
        [self setSelectedView:_option0Mask];
        [self setDidNotselectedView:_option1Mask];
        if([personGuessed isEqualToString:_quiz.answer]){
            [self.contentView addSubview:_option0CorrectIcon];
        }else{
            [self.contentView addSubview:_option0WrongIcon];
        }
    } else{
        [self setSelectedView:_option1Mask];
        [self setDidNotselectedView:_option0Mask];
        if([personGuessed isEqualToString:_quiz.answer]){
            [self.contentView addSubview:_option1CorrectIcon];
        }else{
            [self.contentView addSubview:_option1WrongIcon];
        }
    }
}

-(void) setSelectedView:(UIView *)view{
    [view setBackgroundColor:[UIColor clearColor]];
    [view setUserInteractionEnabled:NO];
}

-(void) setDidNotselectedView:(UIView *)view{
    [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [view setUserInteractionEnabled:NO];
}

-(void)setUnselectAll{
    [_option0Mask setBackgroundColor:[UIColor clearColor]];
    [_option1Mask setBackgroundColor:[UIColor clearColor]];
    [_option0Mask setUserInteractionEnabled:YES];
    [_option1Mask setUserInteractionEnabled:YES];
}

-(void) setupProfileViews{
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=120&height=120", _quiz.author];
//    NSString *option0PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=270&height=270", _quiz.option0];
//    NSString *option1PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=270&height=270", _quiz.option1];
//    
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
//    [_option0PicView setImageWithURL:[NSURL URLWithString:option0PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
//    [_option1PicView setImageWithURL:[NSURL URLWithString:option1PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_quiz.author
                                withWidth:120 height:120];
    [Utility setUpProfilePictureImageView:_option0PicView byFBID:_quiz.option0
                                withWidth:270 height:270];
    [Utility setUpProfilePictureImageView:_option1PicView byFBID:_quiz.option1
                                withWidth:270 height:270];
}

-(void)setupNameButtons{
    NSAttributedString *authorNameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_authorName] attributes:[Utility getPostsViewNameFontDictionary]];
    NSAttributedString *option0NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option0Name] attributes:[Utility getPostsViewNameFontDictionary]];
    NSAttributedString *option1NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option1Name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_authorNameButton setAttributedTitle:authorNameString forState:UIControlStateNormal];
    [_option0NameButton setAttributedTitle:option0NameString forState:UIControlStateNormal];
    [_option1NameButton setAttributedTitle:option1NameString forState:UIControlStateNormal];

}





@end
