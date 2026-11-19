//
//  FSSegmentedControl.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 28/7/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "FSSegmentedControl.h"

@implementation FSSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    current = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (current == self.selectedSegmentIndex)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
