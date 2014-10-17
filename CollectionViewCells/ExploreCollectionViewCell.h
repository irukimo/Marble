//
//  ExploreCollectionViewCell.h
//  Marble
//
//  Created by Iru on 10/16/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ExploreCollectionViewCell : UICollectionViewCell
-(void)setCellUser:(User *)user;
-(void)setCellName:(NSString *)name andID:(NSString *)fbid;
@end
