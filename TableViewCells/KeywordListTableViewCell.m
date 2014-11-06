//
//  KeywordListTableViewCell.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordListTableViewCell.h"
#define KEYWORD_BUTTON_TAG 907


static const NSString *fbidKey = @"fb_id";
static const NSString *nameKey = @"name";


@interface KeywordListTableViewCell()
@property(strong, nonatomic) UIButton *keywordButton;
@property(strong,nonatomic) NSString *keyword;
@property(strong,nonatomic) UILabel *timesPlayedLabel;
@property(strong,nonatomic) UILabel *placeLabel;
@property(strong, nonatomic) UILabel *selfRankingLabel;
@property(strong, nonatomic) NSDictionary *rankingDic;

@property (strong, nonatomic) UIImageView *rank1ImageView;
@property (strong, nonatomic) UIImageView *rank2ImageView;
@property (strong, nonatomic) UIImageView *rank3ImageView;

@property (strong, nonatomic) UIButton *rank1NameButton;
@property (strong, nonatomic) UIButton *rank2NameButton;
@property (strong, nonatomic) UIButton *rank3NameButton;

@property (strong, nonatomic) UIView *expandView;
@end


@implementation KeywordListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBorder];
        [self generateStaticUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        // Initialization code
    }
    return self;
}

-(void)generateStaticUI{
    _timesPlayedLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 50, 15)];
    [self.contentView addSubview:_timesPlayedLabel];
    
    
    UIImageView *marbleImage = [[UIImageView alloc] initWithFrame:CGRectMake(225, 22, 20, 20)];
    [marbleImage setImage:[UIImage imageNamed:MARBLE_IMAGE_NAME]];
    [self.contentView addSubview:marbleImage];


    NSAttributedString *placeString = [[NSAttributedString alloc] initWithString:@"place" attributes:[Utility getProfileGrayStaticFontDictionary]];
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, placeString.size.width, 15)];
    [_placeLabel setAttributedText:placeString];
    [self.contentView addSubview:_placeLabel];
    
    _selfRankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, placeString.size.width, 15)];
    [self.contentView addSubview:_selfRankingLabel];
    [_selfRankingLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, KEYWORD_LIST_CELL_UNEXPAND_HEIGHT - CELL_UNIVERSAL_PADDING/2.0, self.contentView.frame.size.width, 1)];
    [grayLine setBackgroundColor:[UIColor marbleLightGray]];
    [self.contentView addSubview:grayLine];
    [self addThreeRanking];
}

-(void)addThreeRanking{
    _expandView = [[UIView alloc] initWithFrame:CGRectMake(0, 78, self.contentView.frame.size.width, 70)];
    const int RANKING_Y_START = 0;
    const int IMAGE_LEFT_ALIGN = 85;
    const int RANKING_X_INCREMENT = 50;
    const int IMAGE_SIZE = 40;
    const int BIG_IMAGE_SIZE = 50;
    const int PLACE_Y_INCREMENT = 45;
    _rank1NameButton = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN , RANKING_Y_START + PLACE_Y_INCREMENT , IMAGE_SIZE, 20)];
    [_rank1NameButton setTag:0];
    _rank2NameButton = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + RANKING_X_INCREMENT, RANKING_Y_START + PLACE_Y_INCREMENT, BIG_IMAGE_SIZE , 20)];
    [_rank2NameButton setTag:1];
    _rank3NameButton = [[UIButton alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + RANKING_X_INCREMENT*2 +BIG_IMAGE_SIZE - IMAGE_SIZE, RANKING_Y_START + PLACE_Y_INCREMENT , IMAGE_SIZE, 20)];
    [_rank3NameButton setTag:2];
    
    [_rank1NameButton addTarget:self action:@selector(rankNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rank2NameButton addTarget:self action:@selector(rankNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rank3NameButton addTarget:self action:@selector(rankNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _rank1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN, RANKING_Y_START, IMAGE_SIZE, IMAGE_SIZE)];
    _rank2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + RANKING_X_INCREMENT , RANKING_Y_START -BIG_IMAGE_SIZE + IMAGE_SIZE, BIG_IMAGE_SIZE   , BIG_IMAGE_SIZE)];
    _rank3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_LEFT_ALIGN + RANKING_X_INCREMENT*2 +BIG_IMAGE_SIZE - IMAGE_SIZE, RANKING_Y_START , IMAGE_SIZE, IMAGE_SIZE)];
    
    [_rank1ImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rank1NameButtonClicked)]];
    [_rank2ImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rank2NameButtonClicked)]];
    [_rank3ImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rank3NameButtonClicked)]];
    
    [_rank1ImageView setUserInteractionEnabled:YES];
    [_rank2ImageView setUserInteractionEnabled:YES];
    [_rank3ImageView setUserInteractionEnabled:YES];
    
    _rank1ImageView.layer.cornerRadius = IMAGE_SIZE/2.0f;
    _rank1ImageView.layer.masksToBounds = YES;
    _rank2ImageView.layer.cornerRadius = BIG_IMAGE_SIZE/2.0f;
    _rank2ImageView.layer.masksToBounds = YES;
    _rank3ImageView.layer.cornerRadius = IMAGE_SIZE/2.0f;
    _rank3ImageView.layer.masksToBounds = YES;
    
    [_expandView addSubview:_rank1ImageView];
    [_expandView addSubview:_rank2ImageView];
    [_expandView addSubview:_rank3ImageView];
    [_expandView addSubview:_rank1NameButton];
    [_expandView addSubview:_rank2NameButton];
    [_expandView addSubview:_rank3NameButton];
    
    [self.contentView addSubview:_expandView];
}

-(void)rank1NameButtonClicked{
    [self rankNameButtonClicked:_rank1NameButton];
}
-(void)rank2NameButtonClicked{
    [self rankNameButtonClicked:_rank2NameButton];
}
-(void)rank3NameButtonClicked{
    [self rankNameButtonClicked:_rank3NameButton];
}

-(void)rankNameButtonClicked:(id)sender{
    int rankNum = (int)[sender tag];
    NSArray *infoBundle;
    switch (rankNum) {
        case 0:{
            NSString *name = [[_rankingDic objectForKey:@"before"] objectForKey:nameKey];
            NSString *fbid = [[_rankingDic objectForKey:@"before"] objectForKey:fbidKey];
            infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
            break;
        }
        case 1:{
            infoBundle = [NSArray arrayWithObjects:_subject.name,_subject.fbID, nil];
            break;
        }
        case 2:{

            NSString *name = [[_rankingDic objectForKey:@"after"] objectForKey:nameKey];
            NSString *fbid = [[_rankingDic objectForKey:@"after"] objectForKey:fbidKey];
            infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
            break;
        }
        default:
            break;
    }
    if([infoBundle count]<2){
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfile:)]){
        [self.delegate gotoProfile:infoBundle];
    }
}


-(void)prepareForReuse{
    [_keywordButton removeFromSuperview];
}
-(void) setBorder{
    [self.contentView.layer setBorderColor:[UIColor marbleLightGray].CGColor];
    [self.contentView.layer setBorderWidth:CELL_UNIVERSAL_PADDING/2.0];
    [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
    [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleLightGray] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
}


-(void) setKeyword:(NSArray *)keywordArray{
    /* each keyword:
     * [
     *   times played,
     *   keyword,
     *   {
     *     after: {fb_id: xxxx, name: xxxx, rank: (number)},
     *     self: (number),
     *     before: {fb_id: xxxx, name: xxxx, rank: (number)}
     *   }
     * ]
     * NOTE: after/before might correspond to nil value.
     */
    _keyword = [keywordArray objectAtIndex:1];
    NSAttributedString *keywordString =[[NSAttributedString alloc] initWithString:_keyword attributes:[Utility getNotifOrangeNormalFontDictionary]];
    _keywordButton = [Utility getKeywordButtonAtX:55 andY:20 andString:keywordString];
    [_keywordButton addTarget:self action:@selector(keywordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_keywordButton];
    
    NSString *timesPlayed = [NSString stringWithFormat:@"%@", [keywordArray objectAtIndex:0]];
    NSAttributedString *timesPlayedString = [[NSAttributedString alloc] initWithString:timesPlayed attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_timesPlayedLabel setAttributedText:timesPlayedString];
    
    NSDictionary *rankingDic = [keywordArray objectAtIndex:2];
    [self displayRanking:rankingDic];
}

-(void)displayRanking:(NSDictionary *)rankingDic{
    _rankingDic = rankingDic;
    NSNumber *selfRanking = [rankingDic objectForKey:@"self"];
    NSAttributedString *selfRankingString;
    if(![_rankingDic objectForKey:@"after"] && [_rankingDic objectForKey:@"before"]){
        selfRankingString = [[NSAttributedString alloc] initWithString:@"Last" attributes:[Utility getNotifBlackNormalFontDictionary]];
    }else{
        if(selfRanking){
            selfRankingString = [[NSAttributedString alloc] initWithString:[Utility getRankingFullString:selfRanking] attributes:[Utility getNotifBlackNormalFontDictionary]];
        }else{
            selfRankingString = [[NSAttributedString alloc] initWithString:[Utility getRankingFullString:[NSNumber numberWithInt:1]] attributes:[Utility getNotifBlackNormalFontDictionary]];
        }
    }
    [_selfRankingLabel setAttributedText:selfRankingString];
    [_selfRankingLabel setTextAlignment:NSTextAlignmentCenter];
    [self updateRankingImageViewsAndPlaces];
}

-(void)updateRankingImageViewsAndPlaces{
    NSString *rank1fbID = [[_rankingDic objectForKey:@"before"] objectForKey:fbidKey];
    if(rank1fbID){
        [Utility setUpProfilePictureImageView:_rank1ImageView byFBID:rank1fbID];
    }
    NSString *rank2fbID = _subject.fbID;
    if(rank2fbID){
        [Utility setUpProfilePictureImageView:_rank2ImageView byFBID:rank2fbID];
    }
    NSString *rank3fbID = [[_rankingDic objectForKey:@"after"] objectForKey:fbidKey];
    if(rank3fbID){
        [Utility setUpProfilePictureImageView:_rank3ImageView byFBID:rank3fbID];
    }
    
    
    NSNumber *rank1Number = [[_rankingDic objectForKey:@"before"] objectForKey:@"rank"];
    if(rank1Number){
        NSAttributedString *rank1NameString = [[NSAttributedString alloc] initWithString:[Utility getRankingFullString:rank1Number] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank1NameButton setAttributedTitle:rank1NameString forState:UIControlStateNormal];
    }
    NSNumber *rank2Number = [_rankingDic objectForKey:@"self"];
    if(rank2Number){
        NSAttributedString *rank2NameString = [[NSAttributedString alloc] initWithString:[Utility getRankingFullString:rank2Number] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank2NameButton setAttributedTitle:rank2NameString forState:UIControlStateNormal];
    } else{
        NSAttributedString *rank2NameString = [[NSAttributedString alloc] initWithString:[Utility getRankingFullString:[NSNumber numberWithInt:1]] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank2NameButton setAttributedTitle:rank2NameString forState:UIControlStateNormal];
    }
    NSNumber *rank3Number = [[_rankingDic objectForKey:@"after"] objectForKey:@"rank"];    if(rank3Number){
        NSAttributedString *rank3NameString = [[NSAttributedString alloc] initWithString:[Utility getRankingFullString:rank3Number] attributes:[Utility getPostsViewNameFontDictionary]];
        [_rank3NameButton setAttributedTitle:rank3NameString forState:UIControlStateNormal];
    }
    
}


-(void)keywordButtonClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoKeywordProfileWithKeyword:)]){
        [self.delegate gotoKeywordProfileWithKeyword:_keyword];
    }
}


@end
