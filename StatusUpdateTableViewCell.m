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
@property(strong, nonatomic) UITextView *statusTextView;
@property (strong, nonatomic) UIImageView *authorPicView;
@property(strong,nonatomic) NSArray *comments;
@property(strong, nonatomic) UILabel *saidLabel;
@property (strong, nonatomic) StatusUpdate *statusUpdate;
@end

@implementation StatusUpdateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellType = MBStatusUpdateCellType;
        [super initializeAccordingToType];
        [self addStaticLabels];
        [self initPicView];
        // Initialization code
    }
    return self;
}


-(void) prepareForReuse{
//    _statusTextView.frame = CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 17, self.contentView.frame.size.width - NAME_LEFT_ALIGNMENT - 20, 40);
}





-(void) addStaticLabels{
    
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT, 150, 20)];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton addTarget:self action:@selector(nameClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _statusTextView = [[UITextView alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT, NAME_TOP_ALIGNMENT + 15, self.contentView.frame.size.width - NAME_LEFT_ALIGNMENT - 20, 40)];
    [_statusTextView setUserInteractionEnabled:NO];
    [_statusTextView setEditable:NO];
//    [_statusTextView sizeToFit];
    
    _saidLabel= [[UILabel alloc] initWithFrame:CGRectMake(NAME_LEFT_ALIGNMENT + 30, NAME_TOP_ALIGNMENT, 100, 20)];
    NSAttributedString *saidTextString = [[NSAttributedString alloc] initWithString:@"said:" attributes:[Utility getNotifBlackNormalFontDictionary]];
    [_saidLabel setAttributedText:saidTextString];
    
    [self.contentView addSubview:_saidLabel];
    [self.contentView addSubview:_statusTextView];
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
    self.post = statusUpdate;
    _statusUpdate = statusUpdate;
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[Utility getNameToDisplay:_statusUpdate.name] attributes:[Utility getPostsViewNameFontDictionary]];
    [_nameButton setAttributedTitle:nameString forState:UIControlStateNormal];
    [_nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    NSAttributedString *statusString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\"%@\"",_statusUpdate.status] attributes:[Utility getProfileStatusFontDictionary]];
    [_statusTextView setAttributedText:statusString];
//    _statusTextView.lineBreakMode = NSLineBreakByWordWrapping;
//    _statusTextView.numberOfLines = 0;
//    [_statusTextView sizeToFit];

    [Utility setUpProfilePictureImageView:_authorPicView byFBID:_statusUpdate.fbID];
    
    CGRect saidFrame = _saidLabel.frame;
    saidFrame.origin.x = NAME_LEFT_ALIGNMENT + nameString.size.width + 5;
    [_saidLabel setFrame:saidFrame];
    
    [super setTimeForTimeLabel:_statusUpdate.time];
}

-(void)nameClicked:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gotoProfileWithName:andID:)]){
        [self.delegate gotoProfileWithName:_statusUpdate.name andID:_statusUpdate.fbID];
    }
}


@end
