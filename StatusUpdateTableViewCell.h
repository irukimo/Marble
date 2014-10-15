//
//  StatusUpdateTableViewCell.h
//  Marble
//
//  Created by Iru on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsTableViewSuperCell.h"

@interface StatusUpdateTableViewCell : PostsTableViewSuperCell
- (void) setName:(NSString *)name andID:(NSString *)fbid andStatus:(NSString *)status;
@end

