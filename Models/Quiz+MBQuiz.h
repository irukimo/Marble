//
//  Quiz+MBQuiz.h
//  Marble
//
//  Created by Wen-Hsiang Shaw on 10/8/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "Quiz.h"

@interface Quiz (MBQuiz)

- (void)incrementCompareNum:(NSString *)answer;
- (NSNumber *)compareNum;
- (void)commmentsNum;
- (void)initParentAttributes;

@end
