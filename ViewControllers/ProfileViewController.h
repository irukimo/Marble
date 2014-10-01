//
//  ProfileViewController.h
//  
//
//  Created by Iru on 10/1/14.
//
//

#import <UIKit/UIKit.h>
#import "CreateQuizViewController.h"

@interface ProfileViewController : UIViewController <CreateQuizViewControllerDelegate>
@property (strong,nonatomic) NSString *person;
@end
