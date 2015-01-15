//
//  KeywordView.m
//  Marble
//
//  Created by Iru on 10/26/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordView.h"

@interface KeywordView()
@property(strong,nonatomic) UITextView *keywordTextView;

@end

@implementation KeywordView
- (instancetype)initWithFrame:(CGRect)frame
                      keyword:(NSString *)keyword
                      options:(MDCSwipeToChooseViewOptions *)options{
    self = [super initWithFrame:frame options:options];
    if (self) {
        _keyword = keyword;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self constructInformationView];
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardClicked:)]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(void)setDelegate:(id<KeywordViewDelegate,UITextViewDelegate>)delegate{
    _delegate = delegate;
    _keywordTextView.delegate = _delegate;
}

-(void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    NSAttributedString *keywordString = [[NSAttributedString alloc] initWithString:_keyword attributes:[Utility getCreateQuizSuperBigKeywordFontDictionary]];
    [_keywordTextView setAttributedText:keywordString];
    [_keywordTextView setTextAlignment:NSTextAlignmentCenter];
    [_keywordTextView setScrollEnabled:NO];
}


-(void)cardClicked:(id)sender{
    [_keywordTextView becomeFirstResponder];
}

- (void)constructInformationView {
    _keywordTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 20, self.frame.size.width, 50)];
    [_keywordTextView setEditable:NO];
    _keywordTextView.delegate = _delegate;
    [_keywordTextView setBackgroundColor:[UIColor clearColor]];

    [self setKeyword:_keyword];
//    [_keywordTextView addTarget:_delegate
//                              action:@selector(textFieldDidChange:)
//                    forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_keywordTextView];
}

-(void)textViewDidBeginEditing{
    _keywordTextView.text = @"";
}
@end
