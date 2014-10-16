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
@property(strong, nonatomic) UILabel *nameLabel;
@end

@implementation NotificationTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStaticLabels];
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) addStaticLabels{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 30)];
    [self.contentView addSubview:_nameLabel];
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
    _fbID = update.fbID;
    NSArray *keywords = update.keywords;
    for (NSString *string in keywords) {
        UILabel *keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
        [keywordLabel setText:string];
        [self.contentView addSubview:keywordLabel];
    }
}

-(void) setQuiz:(Quiz *)quiz{
    [self setName:quiz.authorName];
    _fbID = quiz.author;
}

-(void) setCommentNotif:(CommentNotification *)commentNotif{
    [self setName:commentNotif.commenterName];
    _fbID = commentNotif.commenterFBID;
}


-(void) setName:(NSString *)name{
    _name = [name copy];
    [_nameLabel setText:_name];
}

@end
