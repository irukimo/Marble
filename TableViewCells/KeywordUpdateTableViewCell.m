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
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 300, 30)];
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
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
    if(_name){
        NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_name] attributes:[Utility getPostsViewNameFontDictionary]];        
        [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    }
    
    NSString *keywordString;
    if(keywords){
        if([keywords isKindOfClass:[NSString class]]){
            keywordString = (NSString *)keywords;
        } else if([keywords isKindOfClass:[NSArray class]]){
            NSArray *keywordArray = (NSArray *)keywords;
            if([keywordArray count] > 0){
                keywordString = keywords[0];
            }
        }
    }
    if(keywordString){
        NSAttributedString *descString = [[NSAttributedString alloc] initWithString:keywordString attributes:[Utility getNotifBlackBoldFontDictionary]];
        [_descriptionLabel setAttributedText:descString];
    }
    
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:fbid];
}

-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    _authorPicView.layer.cornerRadius = 22;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_authorPicView];
}

@end
