//
//  StatusUpdateTableViewCell.m
//  Marble
//
//  Created by Iru on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "StatusUpdateTableViewCell.h"




@interface StatusUpdateTableViewCell()
@property(strong, nonatomic) UIButton *nameButton;
@property(strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIImageView *authorPicView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fbid;
@property(strong,nonatomic) NSArray *comments;
@property(strong, nonatomic) UILabel *saidLabel;
@end

@implementation StatusUpdateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStaticLabels];
        [self initPicView];
        self.cellType = STATUS_UPDATE_CELL_TYPE;
        [super initializeAccordingToType];
        // Initialization code
    }
    return self;
}





-(void) addStaticLabels{
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 100, 20)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_nameButton];

    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 17, 150, 20)];
    [self.contentView addSubview:_statusLabel];
    
    _saidLabel= [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT + 30, NAME_TOP_ALIGNMENT, 100, 20)];
    NSAttributedString *saidTextString = [[NSAttributedString alloc] initWithString:@"said:" attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_saidLabel setAttributedText:saidTextString];
    [self.contentView addSubview:_saidLabel];
}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];_authorPicView.layer.cornerRadius = _authorPicView.frame.size.height/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_authorPicView];
}

- (void) setName:(NSString *)name andID:(NSString *)fbid andStatus:(NSString *)status
{
    _name = [name copy];
    _fbid = [fbid copy];
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    NSAttributedString *statusString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"", status] attributes:[Utility getNotifBlackBoldFontDictionary]];
    [_statusLabel setAttributedText:statusString];
//    NSString *authorPictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", fbid];
//    [_authorPicView setImageWithURL:[NSURL URLWithString:authorPictureUrl] placeholderImage:[UIImage imageNamed:@"login.png"]];
    [Utility setUpProfilePictureImageView:_authorPicView byFBID:fbid];
    
    CGRect saidFrame = _saidLabel.frame;
    saidFrame.origin.x = NAME_LEFT_ALIGNMENT + nameString.size.width + 5;
    [_saidLabel setFrame:saidFrame];
}

-(void)nameClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_name andID:_fbid];
    }
}


@end
