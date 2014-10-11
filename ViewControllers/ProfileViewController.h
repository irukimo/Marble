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

@interface ProfileViewController : PostsViewController <CreateQuizViewControllerDelegate, UITextFieldDelegate, PostsViewControllerDelegate>


-(void) setName:(NSString *)name andID:(NSString *)fbid;
@end
