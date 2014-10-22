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
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fbid;
@property (strong,nonatomic) NSArray *comments;
@end

@implementation KeywordUpdateTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initStaticButtonsAndLabels];

        [self initProfilePic];
        self.cellType = KEYWORD_UPDATE_CELL_TYPE;
        [super initializeAccordingToType];
        // Initialization code
    }
    return self;
}


-(void)initStaticButtonsAndLabels{
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 150, 20)];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 100, 20)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_nameButton];
}

-(void)nameClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_name andID:_fbid];
    }
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andKeyword:(id)keywords{
    _name = [name copy];
    _fbid = [fbid copy];
    NSAttributedString *nameString;
    if(_name){
        nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_name] attributes:[Utility getPostsViewNameFontDictionary]];
        [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
        [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    
    NSString *keywordString;
    NSAttributedString *descString;
    if(keywords){
        if([keywords isKindOfClass:[NSString class]]){
            keywordString = (NSString *)keywords;
            descString = [[NSAttributedString alloc] initWithString:@"has 1 new marble:" attributes:[Utility getNotifBlackNormalFontDictionary]];
            NSAttributedString *keywordAttString = [[NSAttributedString alloc] initWithString:keywordString attributes:[Utility getNotifOrangeNormalFontDictionary]];
            UIButton *keywordButton = [Utility getKeywordButtonAtX:NAME_LEFT_ALIGNMENT andY:NAME_TOP_ALIGNMENT + 17 andString:keywordAttString];
            [self.contentView addSubview:keywordButton];
        } else if([keywords isKindOfClass:[NSArray class]]){
            NSArray *keywordArray = (NSArray *)keywords;
            if([keywordArray count] > 0){
                if([keywordArray count] > 1){
                    descString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"has %lu new marble:",[keywordArray count]] attributes:[Utility getNotifBlackNormalFontDictionary]];
                } else{
                    descString = [[NSAttributedString alloc] initWithString:@"has 1 new marble:" attributes:[Utility getNotifBlackNormalFontDictionary]];
                }
                [_descriptionLabel setAttributedText:descString];
                int x = NAME_LEFT_ALIGNMENT;
                int y = NAME_TOP_ALIGNMENT + 25;
                for(NSString *keyword in keywordArray){
                    NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
                    [self addKeywordLabelAtX:x andY:y withKeyword:keywordString atIndex:[keywordArray indexOfObject:keyword]];
                    x+= keywordString.size.width + 20;
                    if(x>250){
                        x=25;
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
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:fbid];
}

-(void) addKeywordLabelAtX:(int)x andY:(int)y withKeyword:(NSAttributedString *)string atIndex:(NSInteger)index{
    UIButton *keywordBtn = [Utility getKeywordButtonAtX:x andY:y andString:string];
    [keywordBtn setTag:index];
    [keywordBtn addTarget:self action:@selector(keywordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:keywordBtn];
}

-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];    _authorPicView.layer.cornerRadius = _authorPicView.frame.size.width/2.0f;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_authorPicView];
}

@end
