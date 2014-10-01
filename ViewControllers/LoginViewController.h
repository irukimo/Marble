//
//  LoginViewController.h
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ClientManager.h"

@interface LoginViewController : UIViewController <FBViewControllerDelegate, FBLoginViewDelegate,
UINavigationControllerDelegate, ClientLoginDelegate>


@end
