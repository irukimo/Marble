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
#define WORD_SEPARATION 5
#define OPTION_SQUARE_WIDTH 123


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
@property(strong, nonatomic) UILabel *compareTextLabel;
@property(strong, nonatomic) UILabel *andTextLabel;
@property(strong, nonatomic) UIView *grayLine;

@property(strong,nonatomic) UIButton *keywordButton;


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
    _option0PicView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 115, OPTION_SQUARE_WIDTH, OPTION_SQUARE_WIDTH)];
    _option1PicView = [[UIImageView alloc] initWithFrame:CGRectMake(165, 115, OPTION_SQUARE_WIDTH, OPTION_SQUARE_WIDTH)];
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];
    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.width/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    
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
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 34, 70, 20)];

    _compareNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, QuizTableViewCellHeight - 45, 50, 20)];

    
    _authorNameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 120, 20)];
    _option0NameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 17, 120, 20)];
    _option1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(160, NAME_TOP_ALIGNMENT + 17, 120, 20)];
    

    NSAttributedString *compareTextString = [[NSAttributedString alloc] initWithString:@"compared" attributes:[Utility getNotifBlackNormalFontDictionary]];
    NSAttributedString *andTextString = [[NSAttributedString alloc] initWithString:@"and" attributes:[Utility getNotifBlackNormalFontDictionary]];
    _compareTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT + _authorNameButton.frame.size.width, NAME_TOP_ALIGNMENT + 3, compareTextString.size.width, compareTextString.size.height)];
    _andTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT + _option0NameButton.frame.size.width, NAME_TOP_ALIGNMENT + 20 , andTextString.size.width, andTextString.size.height)];
    [_compareTextLabel setAttributedText:compareTextString];
    [_andTextLabel setAttributedText:andTextString];

    
    
    [_authorNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_option0NameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_option1NameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_authorNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option0NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option1NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_option0NameButton addTarget:self action:@selector(option0Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_option1NameButton addTarget:self action:@selector(option1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_authorNameButton addTarget:self action:@selector(authorClicked:) forControlEvents:UIControlEventTouchUpInside];

    _keywordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, NAME_TOP_ALIGNMENT + 60  , self.contentView.frame.size.width, 30)];
    [_keywordButton.layer setCornerRadius:_keywordButton.frame.size.height/2.0];
    [_keywordButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [_keywordButton.layer setBorderWidth:1.0f];
    [_keywordButton.layer setMasksToBounds:YES];
    [_keywordButton addTarget:self action:@selector(keywordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    _grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, NAME_TOP_ALIGNMENT + 55, self.contentView.frame.size.width, 1)];
    [_grayLine setBackgroundColor:[UIColor marbleLightGray]];

    [self.contentView addSubview:_grayLine];
    [self.contentView addSubview:_compareNumLabel];
    [self.contentView addSubview:_authorNameButton];
    [self.contentView addSubview:_option0NameButton];
    [self.contentView addSubview:_option1NameButton];
    [self.contentView addSubview:_keywordButton];
    [self.contentView addSubview:_timeLabel];
    
    [self.contentView addSubview:_compareTextLabel];
    [self.contentView addSubview:_andTextLabel];

}

-(void) keywordButtonClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoKeywordProfileWithKeyword:)]){
        [self.delegate gotoKeywordProfileWithKeyword:_quiz.keyword];
    }
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
    NSAttributedString *keywordString = [[NSAttributedString alloc] initWithString:_quiz.keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
    [_keywordButton setAttributedTitle:keywordString forState:UIControlStateNormal];
    [_keywordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    CGRect keywordFrame = _keywordButton.frame;
    keywordFrame.origin.x = self.contentView.frame.size.width/2.0f - keywordString.size.width/2.0f - 2*WORD_SEPARATION;
    keywordFrame.size.width = keywordString.size.width + 4*WORD_SEPARATION;
    _keywordButton.frame = keywordFrame;

    
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:quiz.time inWhole:NO] attributes:[Utility getGraySmallFontDictionary]];
    [_timeLabel setAttributedText:timeString];
    
    if(_quiz.guessed){
        [self displayAlreadyGuessed:_quiz.guessed];
    } else{
        [self setUnselectAll];
    }
    
//    if([_quiz.author isEqualToString:[KeyChainWrapper getSelfFBID]]){
//        if([_quiz.answer isEqualToString:_quiz.option0Name]){
//            [self chooseOption0];
//        } else{
//            [self chooseOption1];
//        }
//    }
}

-(void) displayAlreadyGuessed:(NSString *)personGuessed{
    [_option0PicView setAlpha:1];
    [_option1PicView setAlpha:1];
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
    [_option0PicView setAlpha:0.5];
    [_option1PicView setAlpha:0.5];
}

-(void) setupProfileViews{
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_quiz.author];
    [Utility setUpProfilePictureImageView:_option0PicView byFBID:_quiz.option0];
    [Utility setUpProfilePictureImageView:_option1PicView byFBID:_quiz.option1];
}

-(void)setupNameButtons{
    NSAttributedString *authorNameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_authorName] attributes:[Utility getPostsViewNameFontDictionary]];
    NSAttributedString *option0NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option0Name] attributes:[Utility getPostsViewNameFontDictionary]];
    NSAttributedString *option1NameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_option1Name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_authorNameButton setAttributedTitle:authorNameString forState:UIControlStateNormal];
    [_option0NameButton setAttributedTitle:option0NameString forState:UIControlStateNormal];
    [_option1NameButton setAttributedTitle:option1NameString forState:UIControlStateNormal];
    
    CGRect authorFrame = _authorNameButton.frame;
    authorFrame.size.width = authorNameString.size.width;
    _authorNameButton.frame = authorFrame;
    
    CGRect compareFrame = _compareTextLabel.frame;
    compareFrame.origin.x = NAME_LEFT_ALIGNMENT + authorNameString.size.width + WORD_SEPARATION;
    _compareTextLabel.frame = compareFrame;
    
    CGRect option0Frame = _option0NameButton.frame;
    option0Frame.size.width = option0NameString.size.width;
    _option0NameButton.frame = option0Frame;
    
    CGRect andFrame = _andTextLabel.frame;
    andFrame.origin.x = NAME_LEFT_ALIGNMENT + option0NameString.size.width + WORD_SEPARATION;
    _andTextLabel.frame = andFrame;
    
    CGRect option1Frame = _option1NameButton.frame;
    option1Frame.origin.x = NAME_LEFT_ALIGNMENT + option0NameString.size.width + andFrame.size.width + 2*WORD_SEPARATION;
    option1Frame.size.width = option1NameString.size.width;
    _option1NameButton.frame = option1Frame;
}



@end
