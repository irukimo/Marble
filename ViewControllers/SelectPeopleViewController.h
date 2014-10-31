//
//  SelectPeopleViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol SelectPeopleViewControllerDelegate;

@interface SelectPeopleViewController : UITableViewController
@property (nonatomic, weak) id<SelectPeopleViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peopleArray;
-(void) displaySearchResult:(NSArray *)arrayOfUsers;
@end

@protocol SelectPeopleViewControllerDelegate <NSObject>

- (void)selectedPerson:(User *)person;


@end

