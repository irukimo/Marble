//
//  CreateQuizViewController.h
//  Marble
//
//  Created by Iru on 9/29/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//
#import "SelectKeywordViewController.h"
#import "SelectPeopleViewController.h"
#import <UIKit/UIKit.h>
#import "User+MBUser.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "KeywordView.h"

@protocol CreateQuizViewControllerDelegate;



@interface CreateQuizViewController : UIViewController <UITextFieldDelegate,MDCSwipeToChooseDelegate,SelectKeywordViewControllerDelegate,SelectPeopleViewControllerDelegate, KeywordViewDelegate, UITextViewDelegate>
-(void) setUser:(User *)user;
-(void) setKeyword:(NSString *)keyword;
-(void) setOption0:(User *)option0;
-(void) resetAllOptions;
-(void) setOption0Option1;
@property (nonatomic, weak) id<CreateQuizViewControllerDelegate> delegate;
@property (strong,nonatomic) id lookingAtEitherUserOrKeyword;

@property (nonatomic, strong) NSString *currentKeyword;
@property (nonatomic, strong) KeywordView *frontCardView;
@property (nonatomic, strong) KeywordView *backCardView;
@end

@protocol CreateQuizViewControllerDelegate <NSObject>
@end

