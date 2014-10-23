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
@end

@implementation PostsTableViewSuperCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
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
    if([_cellType isEqualToString:QUIZ_CELL_TYPE]){
        _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 180, 50, 20)];
    } else if([_cellType isEqualToString:STATUS_UPDATE_CELL_TYPE]){
        _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 15, 50, 20)];
    } else{
        _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 15, 50, 20)];
    }
    [_commentNumLabel setText:@"comment"];
    [self.contentView addSubview:_commentNumLabel];
}

-(void) addCommentTextField{
    NSUInteger commentCnt = [_comments count];
    if([_cellType isEqualToString:QUIZ_CELL_TYPE]){
        if(commentCnt > 2){
            _viewMoreCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, QuizTableViewCellHeight - 45, 200, TEXT_FIELD_HEIGHT)];
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, QuizTableViewCellHeight - 25 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, QuizTableViewCellHeight - 25 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    } else if([_cellType isEqualToString:STATUS_UPDATE_CELL_TYPE]){
        if(commentCnt > 2){
            _viewMoreCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, StatusUpdateTableViewCellHeight - 45, 200, TEXT_FIELD_HEIGHT)];
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, StatusUpdateTableViewCellHeight-25 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, StatusUpdateTableViewCellHeight -25 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    } else{
        if(commentCnt > 2){
            _viewMoreCommentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, KeywordUpdateTableViewCellHeight - 45, 200, TEXT_FIELD_HEIGHT)];
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, KeywordUpdateTableViewCellHeight - 25 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, KeywordUpdateTableViewCellHeight - 25 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    }
    [_commentField setTag:COMMENT_RELATED_TAG];
    [_commentField setDelegate:self];
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:COMMENT_DEFAULT_TEXT attributes:[Utility getWriteACommentFontDictionary]];
    [_commentField setAttributedText:defaultText];
    [_commentField setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_commentField];
    if(commentCnt > 2){
        _viewMoreCommentsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_viewMoreCommentsBtn setTag:COMMENT_RELATED_TAG];
         NSAttributedString *defaultViewMoreCommentsText = [[NSAttributedString alloc] initWithString:@"view more comments" attributes:[Utility getWriteACommentFontDictionary]];
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
    [_commentNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_comments count]]];
    [self showComments];
    [self addCommentTextField];
}

-(void) showComments{
    if(!_comments){
        return;
    }
    int y;
    if([_cellType isEqualToString:QUIZ_CELL_TYPE]){
        y = QuizTableViewCellHeight - 25;
    } else if([_cellType isEqualToString:STATUS_UPDATE_CELL_TYPE]){
        y = StatusUpdateTableViewCellHeight - 25;
    } else{
        y = KeywordUpdateTableViewCellHeight - 25;
    }
    int i = 0;
    for (NSDictionary *cmt in _comments) {
        if(i > 2){
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
    if(_delegate && [_delegate respondsToSelector:@selector(commentPost:withComment:)]){
        [_delegate commentPost:sender withComment:_commentField.text];
    }
}

-(void) addCommentBtnAtY:(int)y{
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(COMMENT_START_X + 110 , y, 50, 30)];
    
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"send" forState:UIControlStateNormal];
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
    [self addCommentBtnAtY:textField.frame.origin.y];
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
    [self.contentView endEditing:YES];
    return YES;
}

@end
