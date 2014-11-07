//
// UIView+MDCBorderedLabel.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIView+MDCBorderedLabel.h"
#import "MDCGeometry.h"
#import <QuartzCore/QuartzCore.h>



@implementation UIView (MDCBorderedLabel)

- (void)constructBorderedLabelWithText:(NSString *)text
                                 color:(UIColor *)color
                                 angle:(CGFloat)angle {

    if(!text){
        return;
    }
    
    if([text isEqualToString:@"trash"]){
        UIImageView *trashIcon = [[UIImageView alloc] initWithFrame:self.bounds];
        [trashIcon setImage:[UIImage imageNamed:@"trash.png"]];
        [self addSubview:trashIcon];
        return;
    }
    int borderWidth = 5;
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"OpenSans-Semibold" size:23],NSFontAttributeName, color ,NSForegroundColorAttributeName, @(-0.5), NSKernAttributeName, nil];
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:text attributes:fontDic];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, nameString.size.width + 2 * borderWidth + 3, self.bounds.size.height)];
    [label setAttributedText:nameString];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.layer.borderColor = color.CGColor;
    label.layer.borderWidth = borderWidth;
    label.layer.cornerRadius = 10.f;
    [self addSubview:label];
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                             MDCDegreesToRadians(angle));
}



@end
