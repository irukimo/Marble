//
//  KeywordListTableViewCell.m
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordListTableViewCell.h"
#import "User+MBUser.h"

#define KEYWORD_BUTTON_TAG 907
#define LIKE_BUTTON_TAG 876


static const NSString *fbidKey = @"fb_id";
static const NSString *nameKey = @"name";

@interface KeywordListTableViewCell () {
    bool hasLiked;
    NSInteger numLikes;
}

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

@property (strong, nonatomic) UIButton *heartButton;
@property (strong, nonatomic) UIButton *likeNumButton;
@property (strong,nonatomic) UIView *whiteView;
@property (strong,nonatomic) UIView *secondWhiteView;
@property (nonatomic) BOOL shouldExpand;
@property (strong,nonatomic) UIImageView *heartImage;
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
    int statsStartX = [KeyChainWrapper getScreenWidth] - 105;

    _timesPlayedLabel = [[UILabel alloc] initWithFrame:CGRectMake(statsStartX + 25, 25, 30, 15)];
    [self.contentView addSubview:_timesPlayedLabel];
    
    
    UIImageView *marbleImage = [[UIImageView alloc] initWithFrame:CGRectMake(statsStartX, 22, 20, 20)];
    [marbleImage setImage:[UIImage imageNamed:@"little_marble.png"]];
    [self.contentView addSubview:marbleImage];
    
    _heartImage = [[UIImageView alloc] initWithFrame:CGRectMake(statsStartX + 45, 22, 20, 20)];
    [self.contentView addSubview:_heartImage];
    _heartButton = [[UIButton alloc] initWithFrame:CGRectMake(statsStartX + 35, 12, 40, 40)];
    _likeNumButton = [[UIButton alloc] initWithFrame:CGRectMake(statsStartX + 70, 22, 40, 20)];
    [_likeNumButton setTag:LIKE_BUTTON_TAG];
    MBDebug(@"hasliked when showing pic %d", hasLiked);
    if (hasLiked == true) {
        [_heartImage setImage:[UIImage imageNamed:HEART_IMAGE_NAME]];
        [_heartButton addTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_heartImage setImage:[UIImage imageNamed:EMPTY_HEART_IMAGE_NAME]];
        [_heartButton addTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_heartButton];
    [self.contentView addSubview:_likeNumButton];


    NSAttributedString *placeString = [[NSAttributedString alloc] initWithString:@"place" attributes:[Utility getProfileGrayStaticFontDictionary]];
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, placeString.size.width, 15)];
    [_placeLabel setAttributedText:placeString];
    [self.contentView addSubview:_placeLabel];
    
    _selfRankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, placeString.size.width, 15)];
    [self.contentView addSubview:_selfRankingLabel];
    [_selfRankingLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, KEYWORD_LIST_CELL_UNEXPAND_HEIGHT - CELL_UNIVERSAL_PADDING, _whiteView.frame.size.width, 1)];
    [grayLine setBackgroundColor:[UIColor marbleBackGroundColor]];
    [_whiteView addSubview:grayLine];
    [self addThreeRanking];
}


-(void)unheartButtonClicked:(id)sender{
    [Utility sendThroughRKRoute:@"send_unlike" withParams:@{@"likee_fb_id": _subject.fbID, @"keyword": _keyword}
                   successBlock:^{

                       MBDebug(@"Successfully posted unlike");
                       [_heartImage setImage:[UIImage imageNamed:EMPTY_HEART_IMAGE_NAME]];
                       [_heartButton removeTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                       [_heartButton addTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                       [_likeNumButton removeTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                       [_likeNumButton addTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                       [_subject setHeartForKeywordAtRow:(NSUInteger)[[self index] integerValue] toBool:false];
                       [self setLikeNumButtonWithInt:[[[_subject.keywords objectAtIndex:[[self index] integerValue] ] objectAtIndex:4] integerValue]];

                   }
                   failureBlock:nil];

}

-(void)heartButtonClicked:(id)sender{
    [Utility sendThroughRKRoute:@"send_like" withParams:@{@"likee_fb_id": _subject.fbID, @"keyword": _keyword}
                   successBlock:^{

                       MBDebug(@"Successfully posted like");
                       [_heartImage setImage:[UIImage imageNamed:HEART_IMAGE_NAME]];
                       [_heartButton removeTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                       [_heartButton addTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                       [_likeNumButton removeTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                       [_likeNumButton addTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                       [_subject setHeartForKeywordAtRow:(NSUInteger)[[self index] integerValue] toBool:true];
                       [self setLikeNumButtonWithInt:[[[_subject.keywords objectAtIndex:[[self index] integerValue] ] objectAtIndex:4] integerValue]];
                   }
                   failureBlock:nil];
}

-(void)addThreeRanking{
    _expandView = [[UIView alloc] initWithFrame:CGRectMake(0, 78, self.contentView.frame.size.width, 70)];
    const int RANKING_Y_START = 0;
    const int IMAGE_LEFT_ALIGN = [KeyChainWrapper getScreenWidth]/2.f - 90;
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
    
    [_whiteView addSubview:_expandView];
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
    _secondWhiteView = [[UIView alloc] init];
    [UIView addBackgroundShadowOnView:_secondWhiteView];
    [_secondWhiteView setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackgroundColor:[UIColor marbleBackGroundColor]];
    _whiteView = [[UIView alloc] init];
    [self resizeWhiteBackground:KEYWORD_LIST_CELL_UNEXPAND_HEIGHT animated:NO];
    [_whiteView setBackgroundColor:[UIColor whiteColor]];

    [_whiteView setClipsToBounds:YES];
    [self.contentView addSubview:_secondWhiteView];
    [self.contentView addSubview:_whiteView];
//    [self.contentView.layer setBorderColor:[UIColor marbleBackGroundColor].CGColor];
//    [self.contentView.layer setBorderWidth:CELL_UNIVERSAL_PADDING/2.0];
//    [UIView addLeftBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
//    [UIView addRightBorderOn:self.contentView withColor:[UIColor marbleBackGroundColor] andWidth:CELL_UNIVERSAL_PADDING/2.0 andHeight:QuizTableViewCellDisplayHeight withOffset:CELL_UNIVERSAL_PADDING/2.0];
}

-(void)resizeWhiteBackground:(CGFloat)height animated:(BOOL)animate{
    if(animate){
        [UIView animateWithDuration:0.25
                              delay:0
                            options: (UIViewAnimationOptions)UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            [_whiteView setFrame:CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.f, [KeyChainWrapper getScreenWidth] - 2*CELL_UNIVERSAL_PADDING, height - CELL_UNIVERSAL_PADDING)];
                            [_secondWhiteView setFrame:CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.f, [KeyChainWrapper getScreenWidth] - 2*CELL_UNIVERSAL_PADDING, height - CELL_UNIVERSAL_PADDING)];
                                  }
         
                                  completion:^(BOOL finished){
                                  }];

    }else{
        [_whiteView setFrame:CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.f, [KeyChainWrapper getScreenWidth] - 2*CELL_UNIVERSAL_PADDING, height - CELL_UNIVERSAL_PADDING)];
        [_secondWhiteView setFrame:CGRectMake(CELL_UNIVERSAL_PADDING, CELL_UNIVERSAL_PADDING/2.f, [KeyChainWrapper getScreenWidth] - 2*CELL_UNIVERSAL_PADDING, height - CELL_UNIVERSAL_PADDING)];
    }
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
     *   },
     *   hasLiked (bool),
     *   num_likes
     * ]
     * NOTE: after/before might correspond to nil value.
     */
    MBDebug(@"%@", keywordArray);
    _keyword = [keywordArray objectAtIndex:1];
    _keywordButton = [Utility getKeywordButtonAtX:55 andY:20 andString:_keyword];
    [_keywordButton addTarget:self action:@selector(keywordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_keywordButton];
    
    NSString *timesPlayed = [NSString stringWithFormat:@"%@", [keywordArray objectAtIndex:0]];
    NSAttributedString *timesPlayedString = [[NSAttributedString alloc] initWithString:timesPlayed attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_timesPlayedLabel setAttributedText:timesPlayedString];
    
    NSDictionary *rankingDic = [keywordArray objectAtIndex:2];
    [self displayRanking:rankingDic];
    
    hasLiked = [[keywordArray objectAtIndex:3] boolValue] ? true : false;
    MBDebug(@"hasliked %d", hasLiked);
    if (hasLiked == true) {
        [_heartImage setImage:[UIImage imageNamed:HEART_IMAGE_NAME]];
        [_heartButton removeTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_heartButton addTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_heartImage setImage:[UIImage imageNamed:EMPTY_HEART_IMAGE_NAME]];
        [_heartButton removeTarget:self action:@selector(unheartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_heartButton addTarget:self action:@selector(heartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    numLikes = [[keywordArray objectAtIndex:4] integerValue];
    [self setLikeNumButtonWithInt:numLikes];
}

-(void)setLikeNumButtonWithInt:(NSInteger)intValue{
    for(UIView *view in self.contentView.subviews){
        if([view tag] == LIKE_BUTTON_TAG){
            [view removeFromSuperview];
        }
    }
    _likeNumButton = [[UIButton alloc] initWithFrame:CGRectMake([KeyChainWrapper getScreenWidth] - 105 + 70, 22, 40, 20)];
    [_likeNumButton setTag:LIKE_BUTTON_TAG];
    NSAttributedString *numLikesString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)intValue] attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_likeNumButton setAttributedTitle:numLikesString forState:UIControlStateNormal];
    [_likeNumButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.contentView addSubview:_likeNumButton];
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

-(void)setShouldExpand:(BOOL)shoudExpand{
    _shouldExpand = shoudExpand;
    if(_shouldExpand){
        [self resizeWhiteBackground:KEYWORD_LIST_CELL_EXPAND_HEIGHT animated:YES];
    }else{
        [self resizeWhiteBackground:KEYWORD_LIST_CELL_UNEXPAND_HEIGHT animated:YES];
    }
}


@end
