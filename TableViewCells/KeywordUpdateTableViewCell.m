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
@end

@implementation KeywordUpdateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellType = MBKeywordUpdateCellType;
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
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 150, 20)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_nameButton];
}

-(void) initKeywordsView{
    _keywordsView = [[UIView alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 23, [KeyChainWrapper getKeywordUpdateKeywordsViewWidth], 50)];
//    [_keywordsView.layer setBorderWidth:2.f];
//    [_keywordsView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.contentView addSubview:_keywordsView];
}

-(void)nameClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_keywordUpdate.name andID:_keywordUpdate.fbID];
    }
}

- (void) setKeywordUpdate:(KeywordUpdate *)keywordUpdate{
    self.post = keywordUpdate;
    _keywordUpdate = keywordUpdate;
    
    MBDebug(@"123 %@ %@ %@",keywordUpdate.keyword1, keywordUpdate.keyword2,keywordUpdate.keyword3);
    
    NSAttributedString *nameString;
    if(_keywordUpdate.name){
        nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_keywordUpdate.name] attributes:[Utility getPostsViewNameFontDictionary]];
        [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
        [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }

    NSInteger numKeywords = 0;
    
    
    CGFloat x = 0.f;
    CGFloat y = 0.f;
    CGFloat lineIncrementY = 28.f;
    
    if (_keywordUpdate.keyword1 != nil){
        numKeywords++;
        UIButton *keywordButton = [Utility getKeywordButtonAtX:x andY:0 andString:_keywordUpdate.keyword1];
        if(x == 0.f && keywordButton.frame.size.width >= _keywordsView.frame.size.width){
            CGRect frame = keywordButton.frame;
            frame.size.width =  _keywordsView.frame.size.width - 5;
            [keywordButton setFrame:frame];
            [self addKeywordButton:keywordButton atIndex:0];
            y += lineIncrementY;
        }else{
            x = keywordButton.frame.size.width + 3;
            [self addKeywordButton:keywordButton atIndex:0];
            
        }
        MBDebug(@"keyword1 %@ at x %f and y %f", _keywordUpdate.keyword1, keywordButton.frame.origin.x, keywordButton.frame.origin.y);
    }
    
    if (_keywordUpdate.keyword2 != nil){
        numKeywords++;
        UIButton *keywordButton = [Utility getKeywordButtonAtX:x andY:y andString:_keywordUpdate.keyword2];
        if(x == 0.f && keywordButton.frame.size.width >= _keywordsView.frame.size.width){
            CGRect frame = keywordButton.frame;
            frame.size.width =  _keywordsView.frame.size.width - 5;
            [keywordButton setFrame:frame];
            [self addKeywordButton:keywordButton atIndex:1];
            y += lineIncrementY;
        }else if((x+keywordButton.frame.size.width) > _keywordsView.frame.size.width){
            y += lineIncrementY;
            CGRect frame = keywordButton.frame;
            frame.origin.x =  0.f;
            frame.origin.y =  y;
            [keywordButton setFrame:frame];
            [self addKeywordButton:keywordButton atIndex:1];
            x = keywordButton.frame.size.width + 3;
        }else{
            x += keywordButton.frame.size.width + 3;
            [self addKeywordButton:keywordButton atIndex:1];
            
        }
        MBDebug(@"keyword2 %@ at x %f and y %f", _keywordUpdate.keyword2, keywordButton.frame.origin.x, keywordButton.frame.origin.y);

    }
    
    if (_keywordUpdate.keyword3 != nil){
        numKeywords++;
        UIButton *keywordButton = [Utility getKeywordButtonAtX:x andY:y andString:_keywordUpdate.keyword3];
        MBDebug(@"x %f, width, %f, (x+keywordButton.frame.size.width) %f, %f", x, keywordButton.frame.size.width, (x+keywordButton.frame.size.width), _keywordsView.frame.size.width);
        if(x == 0.f && keywordButton.frame.size.width >= _keywordsView.frame.size.width){
            CGRect frame = keywordButton.frame;
            frame.size.width =  _keywordsView.frame.size.width - 5;
            [keywordButton setFrame:frame];
            [self addKeywordButton:keywordButton atIndex:2];
            y += lineIncrementY;
        }else if((x+keywordButton.frame.size.width) > _keywordsView.frame.size.width){
            y += lineIncrementY;
            CGRect frame = keywordButton.frame;
            frame.origin.x =  0.f;
            frame.origin.y =  y;
            [keywordButton setFrame:frame];
            [self addKeywordButton:keywordButton atIndex:2];
            x = keywordButton.frame.size.width + 3;
        }else{
            x += keywordButton.frame.size.width + 3;
            [self addKeywordButton:keywordButton atIndex:2];
            
        }
        MBDebug(@"keyword3 %@ at x %f and y %f", _keywordUpdate.keyword3, keywordButton.frame.origin.x, keywordButton.frame.origin.y);

    }
    CGRect keywordViewFrame = _keywordsView.frame;
    keywordViewFrame.size.height = y + lineIncrementY;
    [_keywordsView setFrame:keywordViewFrame];
    
    NSAttributedString *descString;
    if(numKeywords > 1){
        descString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"has %lu new marbles:",numKeywords] attributes:[Utility getNotifBlackNormalFontDictionary]];
    }else{
        descString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"has %lu new marble:",numKeywords] attributes:[Utility getNotifBlackNormalFontDictionary]];
    }
    [_descriptionLabel setAttributedText:descString];
    CGRect descFrame = _descriptionLabel.frame;
    descFrame.origin.x = NAME_LEFT_ALIGNMENT + nameString.size.width + 5;
    [_descriptionLabel setFrame:descFrame];

    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_keywordUpdate.fbID];
    
    [super setTimeForTimeLabel:_keywordUpdate.time];
}

-(void) addKeywordButton:(UIButton *)keywordBtn atIndex:(NSInteger)index{
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
