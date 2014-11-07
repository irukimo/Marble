//
//  KeywordUpdateTableViewCell.m
//  Marble
//
//  Created by Iru on 10/10/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordUpdateTableViewCell.h"

@interface KeywordUpdateTableViewCell()
@property(strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong,nonatomic) NSArray *comments;
@property (strong, nonatomic) UIView *keywordsView;
@property (strong, nonatomic) KeywordUpdate *keywordUpdate;
@property(strong, nonatomic) UILabel *timeLabel;
@end

@implementation KeywordUpdateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellType = KEYWORD_UPDATE_CELL_TYPE;
        [super initializeAccordingToType];
        [self initStaticButtonsAndLabels];

        [self initProfilePic];
        [self initKeywordsView];

        // Initialization code
    }
    return self;
}

-(void)prepareForReuse{
    for(UIView *view in _keywordsView.subviews){
        [view removeFromSuperview];
    }
}


-(void)initStaticButtonsAndLabels{
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 1, 150, 20)];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 100, 20)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 44, 70, 20)];

    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_nameButton];
    [self.contentView addSubview:_timeLabel];
}

-(void) initKeywordsView{
    _keywordsView = [[UIView alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 20, self.contentView.frame.size.width, 50)];
    [self.contentView addSubview:_keywordsView];
}

-(void)nameClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_keywordUpdate.name andID:_keywordUpdate.fbID];
    }
}

- (void) setKeywordUpdate:(KeywordUpdate *)keywordUpdate{
    _keywordUpdate = keywordUpdate;
    
    NSAttributedString *nameString;
    if(_keywordUpdate.name){
        nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_keywordUpdate.name] attributes:[Utility getPostsViewNameFontDictionary]];
        [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
        [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }

    NSInteger numKeywords = 0;
    
    int x = 0;
    int y = 0;
    
    if (_keywordUpdate.keyword1 != nil){
        numKeywords++;
        NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:_keywordUpdate.keyword1 attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:0];
        x+= keywordString.size.width + 20;
        if(x>250){
            x=0;
            y+=33;
        }
    }
    
    if (_keywordUpdate.keyword2 != nil){
        numKeywords++;
        NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:_keywordUpdate.keyword1 attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:1];
        x+= keywordString.size.width + 20;
        if(x>250){
            x=0;
            y+=33;
        }
    }
    
    if (_keywordUpdate.keyword3 != nil){
        numKeywords++;
        NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:_keywordUpdate.keyword1 attributes:[Utility getNotifOrangeNormalFontDictionary]];
        [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:2];
        x+= keywordString.size.width + 20;
        if(x>250){
            x=0;
            y+=33;
        }
    }
    
    
    NSAttributedString *descString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"has %lu new marble:",numKeywords] attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_descriptionLabel setAttributedText:descString];
    CGRect descFrame = _descriptionLabel.frame;
    descFrame.origin.x = NAME_LEFT_ALIGNMENT + nameString.size.width + 5;
    [_descriptionLabel setFrame:descFrame];

    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_keywordUpdate.fbID];
    
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:_keywordUpdate.time inWhole:NO] attributes:[Utility getGraySmallFontDictionary]];
    [_timeLabel setAttributedText:timeString];
}

-(void) addKeywordLabelAtX:(int)x andY:(int)y withKeyword:(NSAttributedString *)string atIndex:(NSInteger)index{
    UIButton *keywordBtn = [Utility getKeywordButtonAtX:x andY:y andString:string];
    [keywordBtn setTag:index];
    [keywordBtn addTarget:self action:@selector(keywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_keywordsView addSubview:keywordBtn];
}

-(void) keywordBtnClicked:(id)sender{
    NSString *keyword;
    if([sender tag] == 0){
        keyword = _keywordUpdate.keyword1;
    } else if([sender tag] == 1){
        keyword = _keywordUpdate.keyword2;
    } else{
        keyword = _keywordUpdate.keyword3;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoKeywordProfileWithKeyword:)]){
        [self.delegate gotoKeywordProfileWithKeyword:keyword];
    }
}

-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.width/2.0f;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_authorPicView];
}

@end
