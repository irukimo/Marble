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
#import "Quiz+MBQuiz.h"

#define CORRECT_WRONG_ICON_TAG 768
#define WORD_SEPARATION 5
#define OPTION_SQUARE_WIDTH 142

#define OPTION_PIC_LEFT_ALIGNMENT 12
#define OPTION_PICS_DISTANCE 12
#define OPTION_PIC_Y 112
#define MARBLE_ON_PIC_WIDTH 20


@interface QuizTableViewCell()
@property(strong,nonatomic) NSString *option0Name;
@property(strong,nonatomic) NSString *option1Name;
@property(strong,nonatomic) NSString *authorName;
@property(strong,nonatomic) NSString *answerName;
@property(strong,nonatomic) NSString *keyword;
@property(strong,nonatomic) UIButton *option0NameButton;
@property(strong,nonatomic) UIButton *option1NameButton;
@property(strong,nonatomic) UIButton *authorNameButton;
@property(strong, nonatomic) UIImageView *option0CorrectIcon;
@property(strong, nonatomic) UIImageView *option0WrongIcon;
@property(strong, nonatomic) UIImageView *option1CorrectIcon;
@property(strong, nonatomic) UIImageView *option1WrongIcon;
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

@property(strong,nonatomic) UILabel *marbleNum0Label;
@property(strong,nonatomic) UILabel *marbleNum1Label;

@property(strong,nonatomic) CALayer *maskLayer;
@property(strong,nonatomic) CAGradientLayer *gradient1;
@property(strong,nonatomic) CAGradientLayer *gradient2;


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

-(void)prepareForReuse{
    [super prepareForReuse];
    for(UIView *view in self.contentView.subviews){
        if([view tag] == CORRECT_WRONG_ICON_TAG){
            [view removeFromSuperview];
        }
    }
    for(UIView *view in _option0PicView.subviews){
        if([view tag] == CORRECT_WRONG_ICON_TAG){
            [view removeFromSuperview];
        }
    }
    for(UIView *view in _option1PicView.subviews){
        if([view tag] == CORRECT_WRONG_ICON_TAG){
            [view removeFromSuperview];
        }
    }
    
    [_maskLayer removeFromSuperlayer];
    [_gradient1 removeFromSuperlayer];
    [_gradient2 removeFromSuperlayer];
    
    //probably caused crashes
    //    _option0PicView.layer.sublayers = nil;
    //    _option1PicView.layer.sublayers = nil;
}


-(void) initPicViews{
    _option0PicView = [[UIImageView alloc] initWithFrame:CGRectMake(OPTION_PIC_LEFT_ALIGNMENT, OPTION_PIC_Y, OPTION_SQUARE_WIDTH, OPTION_SQUARE_WIDTH)];
    _option1PicView = [[UIImageView alloc] initWithFrame:CGRectMake(OPTION_PIC_LEFT_ALIGNMENT + OPTION_SQUARE_WIDTH + OPTION_PICS_DISTANCE, OPTION_PIC_Y, OPTION_SQUARE_WIDTH, OPTION_SQUARE_WIDTH)];
    [_option0PicView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_option0PicView.layer setBorderWidth:1.0f];
    [_option1PicView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_option1PicView.layer setBorderWidth:1.0f];
    
    UIView *option0PicContainerView = [[UIView alloc] initWithFrame:_option0PicView.frame];
    UIView *option1PicContainerView = [[UIView alloc] initWithFrame:_option1PicView.frame];
    [option0PicContainerView setBackgroundColor:[UIColor whiteColor]];
    [option1PicContainerView setBackgroundColor:[UIColor whiteColor]];


    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];
    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.width/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOption0)];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOption1)];
    [_option0PicView setUserInteractionEnabled:YES];
    [_option1PicView setUserInteractionEnabled:YES];
    [_option0PicView addGestureRecognizer:singleTap0];
    [_option1PicView addGestureRecognizer:singleTap1];
    [self initCorrectWrongIcons];
    
    [self.contentView addSubview:option0PicContainerView];
    [self.contentView addSubview:option1PicContainerView];
    [self.contentView addSubview:_option0PicView];
    [self.contentView addSubview:_option1PicView];
    [self.contentView addSubview:_authorPicView];
    
}

-(void)addGradientAndMarbleNum{
    CGRect gradientFrame = CGRectMake(0, OPTION_SQUARE_WIDTH*2.0/3.0, OPTION_SQUARE_WIDTH, OPTION_SQUARE_WIDTH/3.0);
    _gradient1 = [CAGradientLayer layer];
    _gradient1.frame = gradientFrame;
    _gradient1.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor], nil];
    _gradient2 = [CAGradientLayer layer];
    _gradient2.frame = gradientFrame;
    _gradient2.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor], nil];
    
    [_option0PicView.layer addSublayer:_gradient1];
    [_option1PicView.layer addSublayer:_gradient2];
    
    CGRect marbleNumFrame = CGRectMake(OPTION_SQUARE_WIDTH - 20, OPTION_SQUARE_WIDTH - 30, 30, 30);
    _marbleNum0Label = [[UILabel alloc] initWithFrame:marbleNumFrame];
    _marbleNum1Label = [[UILabel alloc] initWithFrame:marbleNumFrame];
    
    CGRect marbleFrame = CGRectMake(OPTION_SQUARE_WIDTH-45, OPTION_SQUARE_WIDTH-25, MARBLE_ON_PIC_WIDTH, MARBLE_ON_PIC_WIDTH);
    UIImageView *marbleImage1 = [[UIImageView alloc] initWithFrame:marbleFrame];
    UIImageView *marbleImage2 = [[UIImageView alloc] initWithFrame:marbleFrame];
    [marbleImage1 setImage:[UIImage imageNamed:MARBLE_IMAGE_NAME]];
    [marbleImage2 setImage:[UIImage imageNamed:MARBLE_IMAGE_NAME]];

    [marbleImage1 setTag:CORRECT_WRONG_ICON_TAG];
    [marbleImage2 setTag:CORRECT_WRONG_ICON_TAG];
    [_marbleNum0Label setTag:CORRECT_WRONG_ICON_TAG];
    [_marbleNum1Label setTag:CORRECT_WRONG_ICON_TAG];
    [_option0PicView addSubview:marbleImage1];
    [_option1PicView addSubview:marbleImage2];
    [_option0PicView addSubview:_marbleNum0Label];
    [_option1PicView addSubview:_marbleNum1Label];
    
}
-(void) initCorrectWrongIcons{
    int iconWidth = 50;
    int iconY = OPTION_PIC_Y + 95;
    _option0CorrectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(OPTION_PIC_LEFT_ALIGNMENT - 2, iconY, iconWidth, iconWidth)];
    _option0WrongIcon =[[UIImageView alloc] initWithFrame:CGRectMake(OPTION_PIC_LEFT_ALIGNMENT - 2, iconY, iconWidth, iconWidth)];
    _option1CorrectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(OPTION_PIC_LEFT_ALIGNMENT - 2 + OPTION_SQUARE_WIDTH + OPTION_PICS_DISTANCE, iconY, iconWidth, iconWidth)];
    _option1WrongIcon =[[UIImageView alloc] initWithFrame:CGRectMake(OPTION_PIC_LEFT_ALIGNMENT - 2 + OPTION_SQUARE_WIDTH + OPTION_PICS_DISTANCE, iconY, iconWidth, iconWidth)];

    [_option0CorrectIcon setImage:[UIImage imageNamed:@"correct.png"]];
    [_option0WrongIcon setImage:[UIImage imageNamed:@"wrong.png"]];
    [_option1CorrectIcon setImage:[UIImage imageNamed:@"correct.png"]];
    [_option1WrongIcon setImage:[UIImage imageNamed:@"wrong.png"]];
    
    [_option0CorrectIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option1CorrectIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option0WrongIcon setTag:CORRECT_WRONG_ICON_TAG];
    [_option1WrongIcon setTag:CORRECT_WRONG_ICON_TAG];
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
    
    CGRect compareNumFrame = CGRectMake(230, QuizTableViewCellHeight - 45, 50, 20);
    _compareNumLabel = [[UILabel alloc] initWithFrame:compareNumFrame];
    
    compareNumFrame.origin.x = compareNumFrame.origin.x - 30;
    compareNumFrame.size.height = 20;
    compareNumFrame.size.width = 20;
    
    UIImageView *marbleImage = [[UIImageView alloc] initWithFrame:compareNumFrame];
    [marbleImage setImage:[UIImage imageNamed:MARBLE_IMAGE_NAME]];

    
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
    [self.contentView addSubview:marbleImage];
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

- (void) setCompareNum:(NSNumber *)compareNum option0Num:(NSNumber *)option0Num option1Num:(NSNumber *)option1Num
{
    NSAttributedString *compareString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", compareNum] attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_compareNumLabel setAttributedText:compareString];

    NSAttributedString *num1String = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", option0Num] attributes:[Utility getWhiteCommentFontDictionary]];
    [_marbleNum0Label setAttributedText:num1String];
    
    NSAttributedString *num2String = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", option1Num] attributes:[Utility getWhiteCommentFontDictionary]];
    [_marbleNum1Label setAttributedText:num2String];
}

-(void) setQuiz:(Quiz *)quiz{
    _quiz = quiz;
    _authorName = [quiz.authorName copy];
    _option0Name = [quiz.option0Name copy];
    _option1Name = [quiz.option1Name copy];
    _answerName = [quiz.answer copy];
    _keyword = [quiz.keyword copy];
    NSAttributedString *compareString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [quiz compareNum]] attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_compareNumLabel setAttributedText:compareString];

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
    
    //To prevent self guessing, and show the answer you guessed.
    if([_quiz.author isEqualToString:[KeyChainWrapper getSelfFBID]]){
        [self displayAlreadyGuessed:_quiz.answer];
        return;
    }
    
    if(_quiz.guessed){
        [self displayAlreadyGuessed:_quiz.guessed];
    } else{
        [self setUnselectAll];
    }
    

}

-(void) displayAlreadyGuessed:(NSString *)personGuessed{
    [_option0PicView setAlpha:1];
    [_option1PicView setAlpha:1];
    [_option0PicView setUserInteractionEnabled:NO];
    [_option1PicView setUserInteractionEnabled:NO];
    
    _maskLayer = [CAGradientLayer layer];
    _maskLayer.frame = CGRectMake(0, 0, OPTION_SQUARE_WIDTH, OPTION_SQUARE_WIDTH);
    [_maskLayer setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7].CGColor];
    if([_quiz.answer isEqualToString:_quiz.option0Name]){
        [_option1PicView.layer addSublayer:_maskLayer];
        [_option0PicView setAlpha:0.9];
    }else{
        [_option0PicView.layer addSublayer:_maskLayer];
        [_option1PicView setAlpha:0.9];
    }
    if(![_quiz.author isEqualToString:[KeyChainWrapper getSelfFBID]]){
        if([personGuessed isEqualToString:_quiz.option0Name]){
            if([personGuessed isEqualToString:_quiz.answer]){
                [self.contentView addSubview:_option0CorrectIcon];
            }else{
                [self.contentView addSubview:_option0WrongIcon];
            }
        } else{
            if([personGuessed isEqualToString:_quiz.answer]){
                [self.contentView addSubview:_option1CorrectIcon];
            }else{
                [self.contentView addSubview:_option1WrongIcon];
            }
        }
    }
    [self addGradientAndMarbleNum];
    NSAttributedString *num1String = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_quiz.option0Num] attributes:[Utility getWhiteCommentFontDictionary]];
    [_marbleNum0Label setAttributedText:num1String];
    NSAttributedString *num2String = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_quiz.option1Num] attributes:[Utility getWhiteCommentFontDictionary]];
    [_marbleNum1Label setAttributedText:num2String];
    
}


-(void)setUnselectAll{
    [_option0PicView setAlpha:0.5];
    [_option1PicView setAlpha:0.5];
    [_option0PicView setUserInteractionEnabled:YES];
    [_option1PicView setUserInteractionEnabled:YES];
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
