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
        [self initStaticButtonsAndLabels];

        [self initProfilePic];
        [self initKeywordsView];
        self.cellType = KEYWORD_UPDATE_CELL_TYPE;
        [super initializeAccordingToType];
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
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 150, 20)];
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
    
    NSString *keywordString;
    NSAttributedString *descString;
    NSInteger numKeywords = 0;
    if (_keywordUpdate.keyword1 != nil) numKeywords++;
    if (_keywordUpdate.keyword2 != nil) numKeywords++;
    if (_keywordUpdate.keyword3 != nil) numKeywords++;
    
    if(_keywordUpdate.keywords){
        
        
        if([_keywordUpdate.keywords isKindOfClass:[NSString class]]){
            keywordString = (NSString *)_keywordUpdate.keywords;
            descString = [[NSAttributedString alloc] initWithString:@"has 1 new marble:" attributes:[Utility getNotifBlackNormalFontDictionary]];
            NSAttributedString *keywordAttString = [[NSAttributedString alloc] initWithString:keywordString attributes:[Utility getNotifOrangeNormalFontDictionary]];
            UIButton *keywordButton = [Utility getKeywordButtonAtX:0 andY:0 andString:keywordAttString];
            [keywordButton setTag:-1];
            [_keywordsView addSubview:keywordButton];
            
        } else if([_keywordUpdate.keywords isKindOfClass:[NSArray class]]){
            NSArray *keywordArray = (NSArray *)_keywordUpdate.keywords;
            if([keywordArray count] > 0){
                if([keywordArray count] > 1){
                    descString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"has %lu new marble:",[keywordArray count]] attributes:[Utility getNotifBlackNormalFontDictionary]];
                } else{
                    descString = [[NSAttributedString alloc] initWithString:@"has 1 new marble:" attributes:[Utility getNotifBlackNormalFontDictionary]];
                }
//                [_descriptionLabel setAttributedText:descString];
                int x = 0;
                int y = 0;
                for(NSString *keyword in keywordArray){
                    NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
                    [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:[keywordArray indexOfObject:keyword]];
                    x+= keywordString.size.width + 20;
                    if(x>250){
                        x=0;
                        y+=33;
                    }
                }
            }
        }
    }
    if(keywordString){
        [_descriptionLabel setAttributedText:descString];
    }
    CGRect descFrame = _descriptionLabel.frame;
    descFrame.origin.x = NAME_LEFT_ALIGNMENT + nameString.size.width + 5;
    [_descriptionLabel setFrame:descFrame];
    
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
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
    if([sender tag] == -1){
        keyword = (NSString *)_keywordUpdate.keywords;
    } else{
        keyword = [(NSArray *)_keywordUpdate.keywords objectAtIndex:[sender tag]];
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
