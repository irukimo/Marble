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

@interface ProfileViewController : UIViewController <CreateQuizViewControllerDelegate, PostsViewControllerDelegate>
@property (strong,nonatomic) NSString *name;
@end
