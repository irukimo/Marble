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
#define TEXT_FIELD_HEIGHT 22
#define COMMENT_START_DIFF_TO_RIGHT 120
#define COMMENT_FIELD_WIDTH 90
#define COMMENT_DEFAULT_TEXT @"     Comment"



@interface PostsTableViewSuperCell()

//@property(strong, nonatomic) UILabel *commentNumLabel;
@property (strong, nonatomic) NSArray *comments;
@property(strong, nonatomic) UITextField *commentField;
@property(strong, nonatomic) UIButton *commentBtn;
@property( nonatomic) BOOL isSinglePostSoExpandComments;
@property (strong, nonatomic) UIView *whiteView;
@property(strong, nonatomic) UILabel *timeLabel;
@property(strong, nonatomic) UIImageView *commentIconView;
@property(strong,nonatomic) UIButton *allCommentsButton;
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
    [self setBackgroundColor:[UIColor marbleBackGroundColor]];
//    [self.contentView.layer setBorderColor:[UIColor marbleLightGray].CGColor];
//    [self.contentView.layer setBorderWidth:CELL_UNIVERSAL_PADDING/2.0];
    /*
    if(_cellType == MBQuizCellType){
        [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
        [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    } else if(_cellType == MBStatusUpdateCellType){
        [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:StatusUpdateTableViewCellHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
        [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    } else if(_cellType == MBKeywordUpdateCellType){
       [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:KeywordUpdateTableViewCellHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
        [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    } else{
        MBDebug(@"should never happen");
    }
     */
}

-(void)initTimeLabel{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth] - 35,10, 70, 20)];
    [self.contentView addSubview:_timeLabel];
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_timeLabel.frame.origin.x - 18, 10, 20, 20)];
    [timeIcon setImage:[UIImage imageNamed:@"clock.png"]];
    [self.contentView addSubview:timeIcon];
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
//    MBDebug(@"touchesbegan");
    [self.contentView endEditing:YES];
    if(_delegate && [_delegate respondsToSelector:@selector(tappedTableView)]){
        [_delegate tappedTableView];
    }
}


-(void) initializeAccordingToType{
    [self setBorder];
    int y;
    if(_cellType == MBQuizCellType){
        y = [KeyChainWrapper getQuizCellHeight] - 32;
    } else if(_cellType == MBStatusUpdateCellType){
        y = StatusUpdateTableViewCellHeight - 37;
    } else if(_cellType == MBKeywordUpdateCellType){
        y = KeywordUpdateTableViewCellHeight - 37;
    } else{
        MBDebug(@"should never happen");
    }
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(30, y, [KeyChainWrapper getScreenWidth] - 60, 0.5f)];
    [grayLine setBackgroundColor:[UIColor marbleCommentBorderGray]];
    [self.contentView addSubview:grayLine];
    
//    [_commentNumLabel setText:@"Comment"];
//    [self.contentView addSubview:_commentNumLabel];
    [self resizeWhiteBackground];
}

-(void)initWhiteBackground{
    _whiteView = [[UIView alloc] init];
    [self resizeWhiteBackground];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];
    _whiteView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
    _whiteView.layer.shadowRadius = 2.f;
    _whiteView.layer.shadowOpacity = 1.f;
    _whiteView.layer.shadowOffset = CGSizeMake(0, 0);
    [self.contentView addSubview:_whiteView];
}

-(void)resizeWhiteBackground{
    int myHeight = [Utility getCellHeightForPostWithType:_cellType withComments:_comments whetherSinglePost:_isSinglePostSoExpandComments];
    _whiteView.frame = CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.0f, [KeyChainWrapper getScreenWidth] - 2*CELL_UNIVERSAL_PADDING, myHeight - CELL_UNIVERSAL_PADDING);
}

-(void) addCommentTextField{

    int commentIconWidth = 21;
    int commentIconXIncrement = 4;
    int y = [self getCommentAndCommentTextY];
    
    if(_comments && [_comments count] > 0){
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(30, y, [KeyChainWrapper getScreenWidth] - 60, 0.5f)];
        [grayLine setBackgroundColor:[UIColor marbleCommentBorderGray]];
        [self.contentView addSubview:grayLine];
        [grayLine setTag:COMMENT_RELATED_TAG];
        y = y + 8;
    }
    
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth]-COMMENT_START_DIFF_TO_RIGHT, y, COMMENT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    _commentIconView = [[UIImageView alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth]-COMMENT_START_DIFF_TO_RIGHT + commentIconXIncrement,y, commentIconWidth, commentIconWidth)];
    _allCommentsButton = [[UIButton alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth]-COMMENT_START_DIFF_TO_RIGHT - COMMENT_FIELD_WIDTH - 5, y, COMMENT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    [_allCommentsButton setBackgroundColor:[UIColor marbleCommentFieldBGGray]];
    [_allCommentsButton.layer setCornerRadius:_allCommentsButton.frame.size.height/2.0f];
    [_allCommentsButton.layer setMasksToBounds:YES];
    [_allCommentsButton.layer setBorderColor:[UIColor marbleCommentBorderGray].CGColor];
    [_allCommentsButton.layer setBorderWidth:0.5f];
    
    [_allCommentsButton addTarget:self action:@selector(viewMoreCommentsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_allCommentsButton setTag:COMMENT_RELATED_TAG];
    
    [_commentIconView setTag:COMMENT_RELATED_TAG];
    [_commentIconView setImage:[UIImage imageNamed:COMMENT_ICON_IMAGE_NAME]];
    [_commentField setTag:COMMENT_RELATED_TAG];
    [_commentField setDelegate:self];
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:COMMENT_DEFAULT_TEXT attributes:[Utility getWriteACommentFontDictionary]];
    [_commentField setAttributedText:defaultText];
    [_commentField setBackgroundColor:[UIColor marbleCommentFieldBGGray]];
    [_commentField.layer setCornerRadius:_commentField.frame.size.height/2.0f];
    [_commentField.layer setMasksToBounds:YES];
    [_commentField.layer setBorderColor:[UIColor marbleCommentBorderGray].CGColor];
    [_commentField.layer setBorderWidth:0.5f];
    [_commentField setTextAlignment:NSTextAlignmentCenter];
    _commentField.returnKeyType = UIReturnKeySend;
    [self.contentView addSubview:_allCommentsButton];
    [self.contentView addSubview:_commentField];
    [self.contentView addSubview:_commentIconView];
    

}

-(int)getCommentAndCommentTextY{
    NSUInteger commentCnt = [_comments count];
    if(_cellType == MBQuizCellType){
        if(!_comments || commentCnt == 0){
            return [KeyChainWrapper getQuizCellHeight] - 25;
        }
        if(!_isSinglePostSoExpandComments && commentCnt > 2){
            return [KeyChainWrapper getQuizCellHeight] - 25 + FirstCommentIncrementHeight + 2*CommentIncrementHeight;
        } else{
            return [KeyChainWrapper getQuizCellHeight] - 25 + + FirstCommentIncrementHeight + (int)(commentCnt-1)*CommentIncrementHeight;
        }
        
    } else if(_cellType == MBStatusUpdateCellType){
        if(!_comments || commentCnt == 0){
            return StatusUpdateTableViewCellHeight-30;
        }
        if(!_isSinglePostSoExpandComments && commentCnt > 2){
            return StatusUpdateTableViewCellHeight-30 + FirstCommentIncrementHeight + 2*CommentIncrementHeight;

        } else{
            return StatusUpdateTableViewCellHeight -30 + FirstCommentIncrementHeight + (int)(commentCnt-1)*CommentIncrementHeight;
        }
    } else if(_cellType == MBKeywordUpdateCellType){
        if(!_comments || commentCnt == 0){
            return KeywordUpdateTableViewCellHeight - 30;
        }
        if(!_isSinglePostSoExpandComments && commentCnt > 2){
            return KeywordUpdateTableViewCellHeight - 30 + FirstCommentIncrementHeight + 2*CommentIncrementHeight;
        } else{
            return KeywordUpdateTableViewCellHeight - 30 + FirstCommentIncrementHeight + (int)(commentCnt-1)*CommentIncrementHeight;
        }
    }else{
        return 0;
    }
}

-(void) viewMoreCommentsBtnClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(viewMoreComments:)]){
        [_delegate viewMoreComments:sender];
    }
}

-(void)setCommentsForPostSuperCell:(NSArray *)comments{
    _comments = [comments copy];
    [self removeAllCommentRelatedUIs];
    [self showComments];
    [self addCommentTextField];
    [self resizeWhiteBackground];
    NSAttributedString *commentString;
    if([_comments count] > 1){
        commentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu Comments", (unsigned long)[_comments count]] attributes:[Utility getWriteACommentFontDictionary]];
    }else{
        commentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu Comment", (unsigned long)[_comments count]] attributes:[Utility getWriteACommentFontDictionary]];
    }
    [_allCommentsButton setAttributedTitle:commentString forState:UIControlStateNormal];
}

-(void) showComments{
    if(!_comments){
        return;
    }
    int y;
    if(_cellType == MBQuizCellType){
        y = [KeyChainWrapper getQuizCellHeight] - 25;
    } else if(_cellType == MBStatusUpdateCellType){
        y = StatusUpdateTableViewCellHeight - 30;
    } else if(_cellType == MBKeywordUpdateCellType){
        y = KeywordUpdateTableViewCellHeight - 30;
    } else{
        MBDebug(@"should never happen");
        y=0;
    }
    int i = 0;
    
    //only if coming from single post view
    if(_isSinglePostSoExpandComments){
        for (NSDictionary *cmt in _comments) {
            [self addCommentAtY:(y+i*CommentIncrementHeight) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"] atCommentIndex:[_comments indexOfObject:cmt]];
            i++;
        }
        return;
    }
    
    //rest of the case, only displaying 3 comments at most
    NSUInteger commentCnt = [_comments count];
    if(commentCnt < 4){
        for (NSDictionary *cmt in _comments) {
            if(i > 2){
                return;
            }
            [self addCommentAtY:(y+i*CommentIncrementHeight) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"] atCommentIndex:[_comments indexOfObject:cmt]];
            i++;
        }
    }else{
        for (int currentIndex = (int)commentCnt - 3; currentIndex < (int)commentCnt; currentIndex++) {
            NSDictionary *cmt = [_comments objectAtIndex:currentIndex];
            [self addCommentAtY:(y+i*CommentIncrementHeight) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"] atCommentIndex:[_comments indexOfObject:cmt]];
            i++;
        }
    }
}


-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment atCommentIndex:(NSUInteger)index{
    int commentNameStartX = LEFT_ALIGNMENT + 8;
    UIView *commentContainer = [[UIView alloc] initWithFrame:CGRectMake(commentNameStartX, y, self.contentView.frame.size.width, 20)];
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
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth]-COMMENT_START_DIFF_TO_RIGHT + 75 , y, 30, 30)];
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

-(CGRect)textFieldNormalFrame:(UITextField *)textField{
    return CGRectMake([KeyChainWrapper getScreenWidth]-COMMENT_START_DIFF_TO_RIGHT, textField.frame.origin.y, COMMENT_FIELD_WIDTH, TEXT_FIELD_HEIGHT);
}
-(CGRect)textFieldEditingFrame:(UITextField *)textField{
    return CGRectMake(15, textField.frame.origin.y, [KeyChainWrapper getScreenWidth] - 60, TEXT_FIELD_HEIGHT + 4);
}

-(void)setTextFieldApprearanceNormal:(UITextField *)textField{
    [textField setBackgroundColor:[UIColor marbleCommentFieldBGGray]];
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:COMMENT_DEFAULT_TEXT attributes:[Utility getWriteACommentFontDictionary]];
    [textField setAttributedText:defaultText];
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setFrame:[self textFieldNormalFrame:textField]];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField.layer setCornerRadius:TEXT_FIELD_HEIGHT/2.0f];
    [_commentIconView setHidden:NO];
}

-(void)setTextFieldApprearanceEditing:(UITextField *)textField{
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:@"y" attributes:[Utility getEditingCommentFontDictionary]];
    [textField setAttributedText:defaultText];
    [textField setText:@""];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setFrame:[self textFieldEditingFrame:textField]];
    [textField.layer setCornerRadius:4];
    [_commentIconView setHidden:YES];
}

#pragma mark -
#pragma mark UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setTextFieldApprearanceEditing:textField];
    [self addCommentBtnAtY:textField.frame.origin.y - 2];
    if(_delegate && [_delegate respondsToSelector:@selector(presentCellWithKeywordOn:)]){
        [_delegate presentCellWithKeywordOn:textField];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setTextFieldApprearanceNormal:textField];
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
