//
//  StatusUpdateTableViewCell.h
//  Marble
//
//  Created by Iru on 10/9/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsTableViewSuperCell.h"
#import "StatusUpdate.h"

@interface StatusUpdateTableViewCell : PostsTableViewSuperCell
- (void) setStatusUpdate:(StatusUpdate *)statusUpdate;
@end

