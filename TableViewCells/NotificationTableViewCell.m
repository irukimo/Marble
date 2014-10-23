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
@property (strong, nonatomic) KeywordUpdate *keywordUpdate;
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
    _keywordUpdate = update;
    [self setName:update.name];
    [self setAuthorFBID:update.fbID];
    NSAttributedString *stringToDisplay = [self generateAttributedStringForKeywordUpdate];
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
    [self setAuthorFBID:commentNotif.commenterFBID];
    NSAttributedString *stringToDisplay = [self generateAttributedStringForCommentWithName:commentNotif.commenterName andComment:commentNotif.comment andType:commentNotif.type];
    [self setDesc:stringToDisplay];
    [self setTimeLabelWithDate:commentNotif.time];
    
}



-(NSAttributedString *)generateAttributedStringForCommentWithName:(NSString *)name andComment:(NSString *)comment andType:(NSString *)type{
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getNotifBlackBoldFontDictionary]];
    NSAttributedString *descString;
    if([type isEqualToString:@"quiz"]){
        descString = [[NSAttributedString alloc] initWithString:@" commented on your Marble: " attributes:[Utility getNotifBlackNormalFontDictionary]];
    } else{
        descString = [[NSAttributedString alloc] initWithString:@" commented on your profile quote: " attributes:[Utility getNotifBlackNormalFontDictionary]];
    }
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", comment] attributes:[Utility getNotifOrangeNormalFontDictionary]];
    [finalString appendAttributedString:nameString];
    [finalString appendAttributedString:descString];
    [finalString appendAttributedString:commentString];
    return finalString;
}


-(NSAttributedString *)generateAttributedStringForKeywordUpdate{
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] init];
    
    int i = 0;
    if(_keywordUpdate.keyword1){
        NSAttributedString *keywordstring = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", _keywordUpdate.keyword1] attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [finalString appendAttributedString:keywordstring];
        i++;
    }
    if(_keywordUpdate.keyword2){
        NSAttributedString *keywordstring = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", _keywordUpdate.keyword2] attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [finalString appendAttributedString:keywordstring];
        i++;
    }
    if(_keywordUpdate.keyword3){
        NSAttributedString *keywordstring = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", _keywordUpdate.keyword3] attributes:[Utility getNotifOrangeNormalFontDictionary]];
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
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:fbid];
}


-(void) setDesc:(NSAttributedString *)string{
    [_descLabel setAttributedText:string];
}

@end
