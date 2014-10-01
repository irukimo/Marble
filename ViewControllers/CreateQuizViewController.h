//
//  CreateQuizViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateQuizViewControllerDelegate;

@interface CreateQuizViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) id<CreateQuizViewControllerDelegate> delegate;
-(void) setPerson:(NSString *)person;
@end

@protocol CreateQuizViewControllerDelegate <NSObject>

- (void)shouldDisplayPeople:(CreateQuizViewController*)viewController withPeople:(NSArray *)people;
- (void)backToNormal:(CreateQuizViewController*)viewController;
- (void)shouldDisplayKeywords:(CreateQuizViewController*)viewController withKeywords:(NSArray *)keywords;


@end
