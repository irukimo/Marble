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
@property(strong,nonatomic) NSArray *comments;
@property(strong, nonatomic) UILabel *saidLabel;
@property(strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) StatusUpdate *statusUpdate;
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
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 34, 70, 20)];
    
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 100, 20)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 20, self.contentView.frame.size.width - NAME_LEFT_ALIGNMENT - 20, 40)];
    _statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _statusLabel.numberOfLines = 0;
//    [_statusLabel sizeToFit];
    
    _saidLabel= [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT + 30, NAME_TOP_ALIGNMENT, 100, 20)];
    NSAttributedString *saidTextString = [[NSAttributedString alloc] initWithString:@"said:" attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_saidLabel setAttributedText:saidTextString];
    
    [self.contentView addSubview:_saidLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addSubview:_nameButton];

}

-(void) initPicView{
    _authorPicView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];_authorPicView.layer.cornerRadius = _authorPicView.frame.size.height/2.0;
    _authorPicView.layer.masksToBounds = YES;
    [_authorPicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked:)]];
    [_authorPicView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_authorPicView];
}

- (void) setStatusUpdate:(StatusUpdate *)statusUpdate {
    _statusUpdate = statusUpdate;
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_statusUpdate.name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    NSAttributedString *statusString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"",_statusUpdate.status] attributes:[Utility getProfileStatusFontDictionary]];
    [_statusLabel setAttributedText:statusString];
//    _statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _statusLabel.numberOfLines = 0;
    [_statusLabel sizeToFit];

    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_statusUpdate.fbID];
    
    CGRect saidFrame = _saidLabel.frame;
    saidFrame.origin.x = NAME_LEFT_ALIGNMENT + nameString.size.width + 5;
    [_saidLabel setFrame:saidFrame];
    
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[Utility getDateToShow:_statusUpdate.time inWhole:NO] attributes:[Utility getGraySmallFontDictionary]];
    [_timeLabel setAttributedText:timeString];
    
    CGRect timeFrame = _timeLabel.frame;
    timeFrame.origin.y = _statusLabel.frame.origin.y + _statusLabel.frame.size.height - 2;
    [_timeLabel setFrame:timeFrame];
}

-(void)nameClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_statusUpdate.name andID:_statusUpdate.fbID];
    }
}


@end
