//
//  ExploreCollectionViewCell.m
//  Marble
//
//  Created by Iru on 10/16/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "ExploreCollectionViewCell.h"

@interface ExploreCollectionViewCell()
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *keywordLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@end

@implementation ExploreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initProfilePic];
        [self initStaticLabels];
    }
    return self;
}


-(void) initProfilePic{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:_authorPicView];
}

-(void) initStaticLabels{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 50, 30)];
    _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 65, 50, 30)];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_keywordLabel];
}

-(void)setCellUser:(User *)user{
    _user = user;
    [_nameLabel setText:_user.name];
    
    if(_user.keywords){
        if([_user.keywords isKindOfClass:[NSString class]]){
            NSString *string = (NSString *)_user.keywords;
            [_keywordLabel setText:string];
        } else if([_user.keywords isKindOfClass:[NSArray class]]){
            NSArray *keywordArray = (NSArray *)_user.keywords;
            if([keywordArray count] > 0){
                [_keywordLabel setText:keywordArray[0]];
            }
        }
    }
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%lu&height=%lu", _user.fbID,(unsigned long)width , (unsigned long)width];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_user.fbID];
}

-(void)setCellName:(NSString *)name andID:(NSString *)fbid{
    [_nameLabel setText:name];
//    [_keywordLabel setText:keyword];
}

@end
