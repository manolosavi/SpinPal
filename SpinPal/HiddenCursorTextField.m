//
//  HiddenCursorTextField.m
//  SpinPal
//
//  Created by manolo on 4/9/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "HiddenCursorTextField.h"

@implementation HiddenCursorTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)caretRectForPosition:(UITextPosition *)position {
	return CGRectZero;
}

@end