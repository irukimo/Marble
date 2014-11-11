//
//  PostsTableViewSuperCell.m
//  Marble
//
//  Created by Iru on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "PostsTableViewSuperCell.h"
#define COMMENT_RELATED_TAG 456
#define COMMENT_BTN_TAG 789
#define TEXT_FIELD_DISPLACEMENT 40
#define TEXT_FIELD_HEIGHT 25
#define COMMENT_START_X 160



@interface PostsTableViewSuperCell()

@property(strong, nonatomic) UILabel *commentNumLabel;
@property (strong, nonatomic) NSArray *comments;
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@property(strong, nonatomic) UIButton *viewMoreCommentsBtn;
@property( nonatomic) BOOL isSinglePostSoExpandComments;
@property (strong, nonatomic) UIView *whiteView;
@property(strong, nonatomic) UILabel *timeLabel;
@end

@implementation PostsTableViewSuperCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWhiteBackground];
        [self initTimeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _isSinglePostSoExpandComments = ([reuseIdentifier isEqualToString:singlePostKeywordUpdateTableViewCellIdentifier] || [reuseIdentifier isEqualToString:singlePostQuizTableViewCellIdentifier] || [reuseIdentifier isEqualToString:singlePostStatusTableViewCellIdentifier])? TRUE: FALSE;
        // Initialization code
    }
    return self;
}

-(void) setBorder{
    [self setBackgroundColor:[UIColor marbleLightGray]];
//    [self.contentView.layer setBorderColor:[UIColor marbleLightGray].CGColor];
//    [self.contentView.layer setBorderWidth:CELL_UNIVERSAL_PADDING/2.0];
    if(_cellType == MBQuizCellType){
        [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
        [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    } else if(_cellType == MBStatusUpdateCellType){
        [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:StatusUpdateTableViewCellHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
        [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    } else if(_cellType == MBKeywordUpdateCellType){
       [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:KeywordUpdateTableViewCellHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
        [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    } else{
        MBDebug(@"should never happen");
    }
}

-(void)initTimeLabel{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(285,10, 70, 20)];
    [self.contentView addSubview:_timeLabel];

}

-(void)setTimeForTimeLabel:(NSDate *)time{
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:time inWhole:NO] attributes:[Utility getGraySmallFontDictionary]];
    [_timeLabel setAttributedText:timeString];
}


-(void)prepareForReuse{
//    [super prepareForReuse];
    [self removeAllCommentRelatedUIs];
}

-(void) removeAllCommentRelatedUIs{
    for(id view in self.contentView.subviews){
        if([view tag] == COMMENT_RELATED_TAG){
            [view removeFromSuperview];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.contentView endEditing:YES];
}


-(void) initializeAccordingToType{
    [self setBorder];
    int commentIconX = 250;
    int commentNumX = 280;
    int commentIconWidth = 30;
    UIButton *commentIconBtn;
    if(_cellType == MBQuizCellType){
        _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentNumX, QuizTableViewCellHeight - 45, 50, 20)];
        commentIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentIconX, QuizTableViewCellHeight - 45 - 5, commentIconWidth, commentIconWidth)];
    } else if(_cellType == MBStatusUpdateCellType){
        _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentNumX, StatusUpdateTableViewCellHeight - 48, 50, 20)];
        commentIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentIconX, StatusUpdateTableViewCellHeight - 48- 5, commentIconWidth, commentIconWidth)];
    } else if(_cellType == MBKeywordUpdateCellType){
        _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentNumX, KeywordUpdateTableViewCellHeight - 48, 50, 20)];
        commentIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(commentIconX, KeywordUpdateTableViewCellHeight - 48- 5, commentIconWidth, commentIconWidth)];
    } else{
        MBDebug(@"should never happen");
    }
    [_commentNumLabel setText:@"comment"];
    [commentIconBtn setImage:[UIImage imageNamed:COMMENT_ICON_IMAGE_NAME] forState:UIControlStateNormal];
    [commentIconBtn addTarget:self action:@selector(viewMoreCommentsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentNumLabel];
    [self.contentView addSubview:commentIconBtn];
    [self resizeWhiteBackground];
}

-(void)initWhiteBackground{
    _whiteView = [[UIView alloc] init];
    [self resizeWhiteBackground];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    _whiteView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    _whiteView.layer.shadowRadius = 2.f;
    _whiteView.layer.shadowOpacity = 1.f;
    _whiteView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.contentView addSubview:_whiteView];
}

-(void)resizeWhiteBackground{
    int myHeight = [Utility getCellHeightForPostWithType:_cellType withComments:_comments whetherSinglePost:_isSinglePostSoExpandComments];

    _whiteView.frame = CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.0f, self.bounds.size.width - 2*CELL_UNIVERSAL_PADDING, myHeight - CELL_UNIVERSAL_PADDING);
}

-(void) addCommentTextField{
    NSUInteger commentCnt = [_comments count];
    if(_cellType == MBQuizCellType){
        if(!_isSinglePostSoExpandComments && commentCnt > 2){
            _viewMoreCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, QuizTableViewCellHeight - 45, 50, TEXT_FIELD_HEIGHT)];
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, QuizTableViewCellHeight - 25 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, QuizTableViewCellHeight - 25 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    } else if(_cellType == MBStatusUpdateCellType){
        if(!_isSinglePostSoExpandComments && commentCnt > 2){
            _viewMoreCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, StatusUpdateTableViewCellHeight - 50, 50, TEXT_FIELD_HEIGHT)];
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, StatusUpdateTableViewCellHeight-30 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, StatusUpdateTableViewCellHeight -30 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    } else if(_cellType == MBKeywordUpdateCellType){
        if(!_isSinglePostSoExpandComments && commentCnt > 2){
            _viewMoreCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, KeywordUpdateTableViewCellHeight - 50, 50, TEXT_FIELD_HEIGHT)];
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, KeywordUpdateTableViewCellHeight - 30 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, KeywordUpdateTableViewCellHeight - 30 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    }else{
        MBDebug(@"should never happen");
    }
    [_commentField setTag:COMMENT_RELATED_TAG];
    [_commentField setDelegate:self];
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:COMMENT_DEFAULT_TEXT attributes:[Utility getWriteACommentFontDictionary]];
    [_commentField setAttributedText:defaultText];
    [_commentField setTextAlignment:NSTextAlignmentLeft];
    _commentField.returnKeyType = UIReturnKeySend;
    [self.contentView addSubview:_commentField];
    if(commentCnt > 2){
        _viewMoreCommentsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_viewMoreCommentsBtn setTag:COMMENT_RELATED_TAG];
         NSAttributedString *defaultViewMoreCommentsText = [[NSAttributedString alloc] initWithString:@"[...]" attributes:[Utility getWriteACommentFontDictionary]];
        [_viewMoreCommentsBtn setAttributedTitle:defaultViewMoreCommentsText forState:UIControlStateNormal];
        [_viewMoreCommentsBtn addTarget:self action:@selector(viewMoreCommentsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_viewMoreCommentsBtn];
    }
}

-(void) viewMoreCommentsBtnClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(viewMoreComments:)]){
        [_delegate viewMoreComments:sender];
    }
}

-(void)setCommentsForPostSuperCell:(NSArray *)comments{
    [self removeAllCommentRelatedUIs];
    _comments = [comments copy];
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)[_comments count]] attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_commentNumLabel setAttributedText:commentString];
    [self showComments];
    [self addCommentTextField];
    [self resizeWhiteBackground];
}

-(void) showComments{
    if(!_comments){
        return;
    }
    int y;
    if(_cellType == MBQuizCellType){
        y = QuizTableViewCellHeight - 25;
    } else if(_cellType == MBStatusUpdateCellType){
        y = StatusUpdateTableViewCellHeight - 30;
    } else if(_cellType == MBKeywordUpdateCellType){
        y = KeywordUpdateTableViewCellHeight - 30;
    } else{
        MBDebug(@"should never happen");
    }
    int i = 0;
    for (NSDictionary *cmt in _comments) {
        if(!_isSinglePostSoExpandComments && i > 2){
            return;
        }
        [self addCommentAtY:(y+i*CommentIncrementHeight) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"] atCommentIndex:[_comments indexOfObject:cmt]];
        i++;
    }
}


-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment atCommentIndex:(NSUInteger)index{
    UIView *commentContainer = [[UIView alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, y, self.contentView.frame.size.width, 20)];
    [commentContainer setTag:COMMENT_RELATED_TAG];
    
    UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [nameButton setTag:index];
    [nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [nameButton addTarget:self action:@selector(commentNameClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    CGSize nameSize = [nameString size];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(3+nameSize.width, 0, 150, 20)];
    
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getPostsViewCommentFontDictionary]];
    [nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    [commentLabel setAttributedText:commentString];
    
    [commentContainer addSubview:nameButton];
    [commentContainer addSubview:commentLabel];
    [self.contentView addSubview:commentContainer];
}

-(void)commentNameClicked:(id)sender{
    if(!_comments || ([_comments count] - 1) < [sender tag]){
        return;
    }
    NSDictionary *comment = [_comments objectAtIndex:[sender tag]];
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:[comment valueForKey:@"name"] andID:[comment valueForKey:@"fb_id"]];
    }
}

-(void) commentPostClicked:(id)sender{
    MBDebug(@"comment quiz clicked!");
    if([_commentField.text isEqualToString:@""]){
        return;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(commentPost:withComment:)]){
        [_delegate commentPost:sender withComment:_commentField.text];
    }
}

-(void) addCommentBtnAtY:(int)y{
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(COMMENT_START_X + 110 , y, 30, 30)];
    [_commentBtn setImage:[UIImage imageNamed:@"send-border.png"] forState:UIControlStateNormal];
//    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentPostClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn setTag:COMMENT_BTN_TAG];
    [self.contentView addSubview:_commentBtn];
}

-(void) removeCommentButton{
    for(id view in self.contentView.subviews){
        if([view tag] == COMMENT_BTN_TAG){
            [view removeFromSuperview];
        }
    }
}

#pragma mark -
#pragma mark UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setText:@""];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self addCommentBtnAtY:textField.frame.origin.y - 2];
    [textField setFrame:CGRectMake(textField.frame.origin.x - TEXT_FIELD_DISPLACEMENT, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
    if(_delegate && [_delegate respondsToSelector:@selector(presentCellWithKeywordOn:)]){
        [_delegate presentCellWithKeywordOn:textField];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setText:COMMENT_DEFAULT_TEXT];
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setFrame:CGRectMake(textField.frame.origin.x + TEXT_FIELD_DISPLACEMENT, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
    [self removeCommentButton];
    if(_delegate && [_delegate respondsToSelector:@selector(endPresentingCellWithKeywordOn)]){
        [_delegate endPresentingCellWithKeywordOn];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self commentPostClicked:textField];
    [self.contentView endEditing:YES];
    return YES;
}

@end
