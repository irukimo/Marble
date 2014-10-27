//
//  CreateQuizViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+MBUser.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "KeywordView.h"

@protocol CreateQuizViewControllerDelegate;

@interface CreateQuizViewController : UIViewController <UITextFieldDelegate,MDCSwipeToChooseDelegate>
@property (nonatomic, weak) id<CreateQuizViewControllerDelegate> delegate;
-(void) setUser:(User *)user;
-(void) setKeyword:(NSString *)keyword;
-(void) setOption0:(User *)option0;
-(void) resetAllOptions;
-(void) setOption0Option1;

@property (nonatomic, strong) NSString *currentKeyword;
@property (nonatomic, strong) KeywordView *frontCardView;
@property (nonatomic, strong) KeywordView *backCardView;
@end

@protocol CreateQuizViewControllerDelegate <NSObject>

- (void)shouldDisplayPeople:(CreateQuizViewController*)viewController withPeople:(NSArray *)people;
- (void)backToNormal:(CreateQuizViewController*)viewController;
- (void)shouldDisplayKeywords:(CreateQuizViewController*)viewController withKeywords:(NSArray *)keywords;
- (void)gotSearchUsersResult:(NSArray *)arrayOfUsers;
- (void)gotSearchKeywordsResult:(NSArray *)arrayOfKeywords;

@end
