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

#define COMMENT_LABEL_TAG 456

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

@property(strong, nonatomic) UILabel *compareNumLabel;
@property(strong, nonatomic) UILabel *commentNumLabel;
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
        [self addChoiceButtons];
        [self addResultLabel];
        [self initPicViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

-(void) initPicViews{
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
    [self.contentView addSubview:_chooseOption0Button];
    [self.contentView addSubview:_chooseOption1Button];
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


-(void)addStaticLabels{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(285, 5, 70, 20)];

    _compareNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 130, 50, 20)];
    _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 130, 50, 20)];
    
    _authorNameButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 120, 20)];
    _option0NameButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 120, 20)];
    _option1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 30, 120, 20)];
    
    [_authorNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option0NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_option1NameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 15, 100, 20)];
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, 150, 30)];
    [_commentField setBorderStyle:UITextBorderStyleLine];
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, 120, 50, 30)];

    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentQuizClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_compareNumLabel];
    [self.contentView addSubview:_authorNameButton];
    [self.contentView addSubview:_option0NameButton];
    [self.contentView addSubview:_option1NameButton];
    [self.contentView addSubview:_keywordLabel];
    [self.contentView addSubview:_commentField];
    [self.contentView addSubview:_commentBtn];
    [self.contentView addSubview:_commentNumLabel];
    [self.contentView addSubview:_timeLabel];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setQuiz:(Quiz *)quiz{
    [self removeAllComments];
    _quiz = quiz;
    _authorName = [quiz.authorName copy];
    _option0Name = [quiz.option0Name copy];
    _option1Name = [quiz.option1Name copy];
    _answerName = [quiz.answer copy];
    _keyword = [quiz.keyword copy];
    [_compareNumLabel setText:[NSString stringWithFormat:@"%@", quiz.compareNum]];
    [self getCommentsNumForQuiz:quiz];
    
    
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", quiz.author];
    NSString *option0PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100", quiz.option0];
    NSString *option1PictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100", quiz.option1];
    
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [_option0PicView setImageWithURL:[NSURL URLWithString:option0PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [_option1PicView setImageWithURL:[NSURL URLWithString:option1PictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    

    [_authorNameButton setTitle:[Utility getNameToDisplay:_authorName] forState:UIControlStateNormal];
    [_option0NameButton setTitle:[Utility getNameToDisplay:_option0Name] forState:UIControlStateNormal];
    [_option1NameButton setTitle:[Utility getNameToDisplay:_option1Name] forState:UIControlStateNormal];
    [_keywordLabel setText:_keyword];
    [_timeLabel setText:[Utility getDateToShow:quiz.time inWhole:NO]];
}

-(void) commentQuizClicked:(id)sender{
    MBDebug(@"comment quiz clicked!");
    if(_delegate && [_delegate respondsToSelector:@selector(commentPost:withComment:)]){
        [_delegate commentPost:sender withComment:_commentField.text];
    }
}

-(void) showComments{;
    int y = 150;
    int increment = 20;
    int i = 0;
    for (NSDictionary *cmt in _quiz.comments) {
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

- (void)getCommentsNumForQuiz:(Quiz *)quiz
{
    NSString *sessionToken = [KeyChainWrapper getSessionTokenForUser];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[quiz.uuid, sessionToken] forKeys:@[@"post_uuid", @"auth_token"]];
    
    [[RKObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"get_comments" object:quiz parameters:params
                                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                               MBDebug(@"Returned comments");
                                                               MBDebug(@"Quiz author: %@", quiz.author);
                                                               MBDebug(@"Quiz keyword: %@", quiz.keyword);
                                                               [_commentNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[quiz.comments count]]];
                                                               [self showComments];
                                                           }
                                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                               [Utility generateAlertWithMessage:@"Network problem"];
                                                               MBError(@"Cannot get comments!");
                                                           }];
}

@end
