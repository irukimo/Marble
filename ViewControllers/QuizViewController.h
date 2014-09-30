//
//  QuizViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuizViewControllerDelegate;

@interface QuizViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) id<QuizViewControllerDelegate> delegate;
@end

@protocol QuizViewControllerDelegate <NSObject>

- (void)shouldDisplayPeople:(QuizViewController*)viewController withPeople:(NSArray *)people;
- (void)backToNormal:(QuizViewController*)viewController;
- (void)shouldDisplayKeywords:(QuizViewController*)viewController withKeywords:(NSArray *)keywords;


@end
