//
//  TouchTextField.m
//  Marble
//
//  Created by Iru on 9/30/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "TouchTextField.h"


@interface TouchTextField()
@property(nonatomic)CGPoint startPoint;
@end



@implementation TouchTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:touch.window];
    NSLog(@"%f",_startPoint.x);
    NSLog(@"%f",_startPoint.y);
//    NSLog(@"touchesBegan");
//    NSLog(@"touches=%@,event=%@",touches,event);
}

@end
