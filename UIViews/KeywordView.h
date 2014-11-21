//
//  KeywordView.h
//  Marble
//
//  Created by Iru on 10/26/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "MDCSwipeToChooseView.h"

@protocol KeywordViewDelegate <NSObject>
-(void)textFieldDidChange :(UITextField *)textField;
@end

@interface KeywordView : MDCSwipeToChooseView
@property (strong, nonatomic) NSString *keyword;
@property(weak, nonatomic) id<KeywordViewDelegate, UITextViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame
                      keyword:(NSString *)keyword
                      options:(MDCSwipeToChooseViewOptions *)options;
-(void)textViewDidBeginEditing;
@end
