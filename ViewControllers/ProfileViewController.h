//
//  ProfileViewController.h
//  
//
//  Created by Iru on 10/1/14.
//
//

#import <UIKit/UIKit.h>
#import "CreateQuizViewController.h"
#import "PostsViewController.h"

@interface ProfileViewController : PostsViewController <UITextViewDelegate,  UIAlertViewDelegate>
@property (strong,nonatomic) User *user;
-(void)setByUserObject:(User *)user;
-(void) setName:(NSString *)name andID:(NSString *)fbid sentFromTabbar:(BOOL)isSentFromTabbar;
@end
