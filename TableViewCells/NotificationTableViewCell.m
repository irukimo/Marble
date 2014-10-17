//
//  NotificationTableViewCell.m
//  
//
//  Created by Wen-Hsiang Shaw on 10/16/14.
//
//

#import "NotificationTableViewCell.h"
#import "KeywordUpdate.h"
#import "Quiz.h"
#import "CommentNotification.h"


@interface NotificationTableViewCell()
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSString *fbID;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NotificationType type;
@property(strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) UILabel *timeLabel;
@end

@implementation NotificationTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStaticLabels];
        [self initPicView];
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.height/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [self.contentView addSubview:_authorPicView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) addStaticLabels{
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.contentView.frame.size.width - LEFT_ALIGNMENT - LEFT_ALIGNMENT - 30, self.contentView.frame.size.height)];
    _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descLabel.numberOfLines = 0;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, self.contentView.frame.size.width - LEFT_ALIGNMENT - LEFT_ALIGNMENT - 30, 30)];
    [self.contentView addSubview:_descLabel];
    [self.contentView addSubview:_timeLabel];
}

-(void)setCellPost:(id)post{
    _post = post;
    if([_post isKindOfClass:[KeywordUpdate class]]){
        _type = MBKeyword;
        [self setKeywordUpdate:(KeywordUpdate *)_post];
    } else if ([_post isKindOfClass:[Quiz class]]) {
        _type = MBQuiz;
        [self setQuiz:(Quiz *)_post];
    } else if ([_post isKindOfClass:[CommentNotification class]]) {
        _type = MBCommentNotification;
        [self setCommentNotif:(CommentNotification *)_post];
    } else {
        MBError(@"Error here");
    }
}

-(void) setKeywordUpdate:(KeywordUpdate *)update{
    [self setName:update.name];
    [self setAuthorFBID:update.fbID];
    NSAttributedString *stringToDisplay = [self generateAttributedStringForKeywordUpdate:update.keywords];
    [self setDesc:stringToDisplay];
    [self setTimeLabelWithDate:update.time];

}


-(void) setQuiz:(Quiz *)quiz{
    [self setAuthorFBID:quiz.author];
    NSAttributedString *stringToDisplay = [self generateAttributedStringForQuizWithAuthor:quiz.authorName andOption0:quiz.option0Name andOption1:quiz.option1Name andKeyword:quiz.keyword];
    [self setDesc:stringToDisplay];
    [self setTimeLabelWithDate:quiz.time];
}

-(void) setCommentNotif:(CommentNotification *)commentNotif{
    [self setName:commentNotif.commenterName];
    [self setAuthorFBID:commentNotif.commenterFBID];
}


-(NSAttributedString *)generateAttributedStringForKeywordUpdate:(NSArray *)keywordArray{
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] init];
    int i = 0;
    for(NSString *keyword in keywordArray){
        NSAttributedString *keywordstring = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", keyword] attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [finalString appendAttributedString:keywordstring];
        i++;
    }
    NSAttributedString *descString = [[NSAttributedString alloc] initWithString:@" was added to your profile" attributes:[Utility getNotifBlackNormalFontDictionary]];
    [finalString appendAttributedString:descString];
    return finalString;
}


-(void)setTimeLabelWithDate:(NSDate *)date{
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:date inWhole:NO] attributes:[Utility getGraySmallFontDictionary]];
    [_timeLabel setAttributedText:timeString];
}

-(NSAttributedString *)generateAttributedStringForQuizWithAuthor:(NSString *)authorName andOption0:(NSString *)option0Name andOption1:(NSString *)option1Name andKeyword:(NSString *)keyword{
    NSMutableAttributedString *authorString = [[NSMutableAttributedString alloc] initWithString:[Utility getNameToDisplay:authorName] attributes:[Utility getNotifBlackBoldFontDictionary]];
    NSAttributedString *desc1String = [[NSAttributedString alloc] initWithString:@" compared " attributes:[Utility getNotifBlackNormalFontDictionary]];
    NSAttributedString *option0String = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:option0Name] attributes:[Utility getNotifOrangeBoldFontDictionary]];
    NSAttributedString *andString = [[NSAttributedString alloc] initWithString:@" and " attributes:[Utility getNotifBlackNormalFontDictionary]];
    NSAttributedString *option1String = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:option1Name] attributes:[Utility getNotifOrangeBoldFontDictionary]];
    NSAttributedString *desc2String = [[NSAttributedString alloc] initWithString:@" with " attributes:[Utility getNotifBlackNormalFontDictionary]];
    NSAttributedString *keywordString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", keyword] attributes:[Utility getNotifOrangeNormalFontDictionary]];

    [authorString appendAttributedString:desc1String];
    [authorString appendAttributedString:option0String];
    [authorString appendAttributedString:andString];
    [authorString appendAttributedString:option1String];
    [authorString appendAttributedString:desc2String];
    [authorString appendAttributedString:keywordString];
    return authorString;
}


-(void) setAuthorFBID:(NSString *)fbid{
    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
}


-(void) setDesc:(NSAttributedString *)string{
    [_descLabel setAttributedText:string];
}

@end
