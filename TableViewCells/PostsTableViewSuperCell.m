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
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, 190 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, 190 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    } else if([_cellType isEqualToString:STATUS_UPDATE_CELL_TYPE]){
        if(commentCnt > 2){
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, 50 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, 50 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    } else{
        if(commentCnt > 2){
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, 50 + 3*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        } else{
            _commentField = [[UITextField alloc] initWithFrame:CGRectMake(COMMENT_START_X, 50 + commentCnt*CommentIncrementHeight, 150, TEXT_FIELD_HEIGHT)];
        }
        
    }
    [_commentField setTag:COMMENT_RELATED_TAG];
    [_commentField setDelegate:self];
    NSAttributedString *defaultText = [[NSAttributedString alloc] initWithString:COMMENT_DEFAULT_TEXT attributes:[Utility getWriteACommentFontDictionary]];
    [_commentField setAttributedText:defaultText];
    [_commentField setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_commentField];
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
        y = 180;
    } else if([_cellType isEqualToString:STATUS_UPDATE_CELL_TYPE]){
        y = 60;
    } else{
        y = 60;
    }
    int i = 0;
    for (NSDictionary *cmt in _comments) {
        if(i > 2){
            return;
        }
        [self addCommentAtY:(y+i*CommentIncrementHeight) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"]];
        i++;
    }
}


-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 100, 20)];
    [nameLabel setTag:COMMENT_RELATED_TAG];
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    CGSize nameSize = [nameString size];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25+3+nameSize.width, y, 150, 20)];
    [commentLabel setTag:COMMENT_RELATED_TAG];
    
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getPostsViewCommentFontDictionary]];
    [nameLabel setAttributedText:nameString];
    [commentLabel setAttributedText:commentString];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:commentLabel];
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
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setText:COMMENT_DEFAULT_TEXT];
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setFrame:CGRectMake(textField.frame.origin.x + TEXT_FIELD_DISPLACEMENT, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height)];
    [self removeCommentButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.contentView endEditing:YES];
    return YES;
}

@end
