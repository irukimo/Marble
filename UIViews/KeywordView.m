//
//  KeywordView.m
//  Marble
//
//  Created by Iru on 10/26/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "KeywordView.h"

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


- (void)constructInformationView {
    UILabel *keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [keywordLabel setText:_keyword];
    [self addSubview:keywordLabel];
}
@end
