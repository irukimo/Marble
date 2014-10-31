//
//  KeywordView.m
//  Marble
//
//  Created by Iru on 10/26/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordView.h"

@interface KeywordView()
@property(strong,nonatomic) UITextField *keywordTextField;

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
    }
    return self;
}

-(void)setDelegate:(id<KeywordViewDelegate,UITextFieldDelegate>)delegate{
    _delegate = delegate;
    _keywordTextField.delegate = _delegate;
}

-(void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    [_keywordTextField setText:_keyword];
}


- (void)constructInformationView {
    _keywordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    _keywordTextField.delegate = _delegate;
    [_keywordTextField setText:_keyword];
    [_keywordTextField addTarget:_delegate
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_keywordTextField];
}
@end
