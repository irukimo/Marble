//
//  KeywordListTableViewCell.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordListTableViewCell.h"

@interface KeywordListTableViewCell()
@property(strong, nonatomic) UIButton *keywordButton;
@property(strong,nonatomic) NSString *keyword;
@end


@implementation KeywordListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBorder];
        self.selectionStyle = UITableViewCellSelectionStyleNone; 
        // Initialization code
    }
    return self;
}
-(void) setBorder{
    [self.contentView.layer setBorderColor:[UIColor marbleLightGray].CGColor];
    [self.contentView.layer setBorderWidth:5.0f];
    [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:5 andHeight:QuizTableViewCellDisplayHeight withOffset:5];
    [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:5 andHeight:QuizTableViewCellDisplayHeight withOffset:5];
}


-(void) setKeyword:(NSString *)keyword{
    _keyword = keyword;
    NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
    _keywordButton = [Utility getKeywordButtonAtX:self.contentView.frame.size.width/2.0 - keywordString.size.width/2.0 andY:15 andString:keywordString];
    [self.contentView addSubview:_keywordButton];
    [_keywordButton addTarget:self action:@selector(keywordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)keywordButtonClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoKeywordProfileWithKeyword:)]){
        [self.delegate gotoKeywordProfileWithKeyword:_keyword];
    }
}

@end
