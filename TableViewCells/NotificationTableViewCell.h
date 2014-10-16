//
//  NotificationTableViewCell.h
//  
//
//  Created by Wen-Hsiang Shaw on 10/16/14.
//
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *fbID;
@property (strong, nonatomic) NSString *fbName;
@property (assign, nonatomic) NotificationType type;

@end
