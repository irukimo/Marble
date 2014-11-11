//
//  SelectPeopleViewCell.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPeopleViewCell : UITableViewCell

@property(strong,nonatomic) NSString *personName;
-(void) setPersonName:(NSString *)personName andfbID:(NSString *)fbID;
@end
