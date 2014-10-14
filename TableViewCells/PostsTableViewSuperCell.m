//
//  PostsTableViewSuperCell.m
//  Marble
//
//  Created by Iru on 10/13/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "PostsTableViewSuperCell.h"
#define COMMENT_LABEL_TAG 456

@interface PostsTableViewSuperCell()
@property(strong, nonatomic) UILabel *commentNumLabel;
@property (strong, nonatomic) NSArray *comments;
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
    [self removeAllComments];
}

-(void) removeAllComments{
    for(id view in self.contentView.subviews){
        if([view tag] == COMMENT_LABEL_TAG){
            [view removeFromSuperview];
        }
    }
}

-(void) addStatsLabels{
    NSLog(@"add %@ stats labels", _cellType);
    NSLog(@"%@", _cellType);
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

-(void)setCommentsForPostSuperCell:(NSArray *)comments{
    NSLog(@"set %@ comment num %d", _cellType, [comments count]);
    _comments = [comments copy];
    [_commentNumLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[_comments count]]];
    [self showComments];
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
    int increment = 20;
    int i = 0;
    for (NSDictionary *cmt in _comments) {
        if(i > 2){
            return;
        }
        [self addCommentAtY:(y+i*increment) withName:[cmt valueForKey:@"name"] andID:[cmt valueForKey:@"fb_id"] andComment:[cmt valueForKey:@"comment"]];
        i++;
    }
}


-(void) addCommentAtY:(int)y withName:(NSString *)name andID:(NSString *)fbid andComment:(NSString *)comment{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 100, 20)];
    [nameLabel setTag:COMMENT_LABEL_TAG];
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    CGSize nameSize = [nameString size];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25+3+nameSize.width, y, 150, 20)];
    [commentLabel setTag:COMMENT_LABEL_TAG];
    
    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment attributes:[Utility getPostsViewCommentFontDictionary]];
    [nameLabel setAttributedText:nameString];
    [commentLabel setAttributedText:commentString];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:commentLabel];
}

@end
