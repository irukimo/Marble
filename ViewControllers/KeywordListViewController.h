//
//  KeywordListViewController.h
//  Marble
//
//  Created by Iru on 10/11/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeywordListTableViewCell.h"

@interface KeywordListViewController : UITableViewController <KeywordListTableViewCellDelegate>
-(void) setKeywords:(id)keywords;
@end
