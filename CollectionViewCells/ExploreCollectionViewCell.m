//
//  ExploreCollectionViewCell.m
//  Marble
//
//  Created by Iru on 10/16/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "ExploreCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ExploreCollectionViewCell()
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *keywordLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) UILabel *receiveNumLabel;
@end

@implementation ExploreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initProfilePic];
        [self initStaticLabels];
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowRadius = 2.f;
        self.contentView.layer.shadowOpacity = 0.5f;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

-(void) prepareForReuse{
    [_keywordLabel setText:@""];
    [_nameLabel setFrame:[self getNameNormalFrame]];
}


-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:_authorPicView];
    
    CGRect picframe = _authorPicView.frame;
    picframe.origin.y = picframe.size.height/2;
    picframe.size.height = picframe.size.height/2;

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = picframe;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor], nil];
    
    [_authorPicView.layer addSublayer:gradient];
}

-(void) initStaticLabels{
    _nameLabel = [[UILabel alloc] initWithFrame:[self getNameNormalFrame]];
    _nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _nameLabel.layer.shadowRadius = 3.f;
    _nameLabel.layer.shadowOpacity = 1.f;
    _nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    MBDebug(@"selfheight %f", self.contentView.frame.size.height);
    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.contentView.frame.size.height - 22, self.contentView.frame.size.width, 20)];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_keywordLabel];
    
    UIImageView *marbleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 40, 5, 20, 20)];
    [marbleView setImage:[UIImage imageNamed:MARBLE_IMAGE_NAME]];
    [self.contentView addSubview:marbleView];
    
    _receiveNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 20, 5, 20, 20)];
    _receiveNumLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    _receiveNumLabel.layer.shadowRadius = 3.f;
    _receiveNumLabel.layer.shadowOpacity = 1.f;
    _receiveNumLabel.layer.shadowOffset = CGSizeMake(0, 0);
    [self.contentView addSubview:_receiveNumLabel];
}

-(CGRect)getNameNormalFrame{
    return CGRectMake(5, self.contentView.frame.size.height - 39, self.contentView.frame.size.width, 20);
}

-(void)setCellUser:(User *)user{
    _user = user;
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_user.name] attributes:[Utility getLightOrangeBoldFontDictionary]];
    [_nameLabel setAttributedText:nameString];
    if(_user.received){
        NSAttributedString *receivedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _user.received] attributes:[Utility getWhiteCommentFontDictionary]];
        [_receiveNumLabel setAttributedText:receivedString];
        [_receiveNumLabel setTextAlignment:NSTextAlignmentCenter];
    }
    /*
     (
     1,
     demanding,
     {
     after =             {
     "fb_id" = 100000111455904;
     name = "\U8607\U5c0f\U676d";
     rank = 7;
     };
     before =             {
     "fb_id" = 1413171627;
     name = "Rosanna WenYen Hsu";
     rank = 5;
     };
     self = 6;
     }
     )
     */
    if(_user.keywords){
        if([_user.keywords isKindOfClass:[NSString class]]){
            NSLog(@"it is string");
            NSString *string = (NSString *)_user.keywords;
            NSAttributedString *keywordString = [[NSAttributedString alloc] initWithString:string attributes:[Utility getWhiteCommentFontDictionary]];
            [_keywordLabel setAttributedText:keywordString];
        } else if([_user.keywords isKindOfClass:[NSArray class]]){
            NSLog(@"it is array user %@ array %@", user.name, _user.keywords);
            NSArray *keywordArray = (NSArray *)_user.keywords;
            if([keywordArray count] > 0){
                NSAttributedString *keywordString = [[NSAttributedString alloc] initWithString:keywordArray[0][1] attributes:[Utility getWhiteCommentFontDictionary]];
                [_keywordLabel setAttributedText:keywordString];
            }
        }
    }else{
        CGRect nameFrame = [self getNameNormalFrame];
        nameFrame.origin.y = nameFrame.origin.y + 12;
        [_nameLabel setFrame:nameFrame];
    }
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%lu&height=%lu", _user.fbID,(unsigned long)self.contentView.frame.size.width*2 , (unsigned long)self.contentView.frame.size.height*2 ];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_user.fbID];
}


-(void)setCellName:(NSString *)name andID:(NSString *)fbid{
    [_nameLabel setText:name];
//    [_keywordLabel setText:keyword];
}

@end
