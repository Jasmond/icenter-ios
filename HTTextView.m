//
//  GCPlaceholderTextView.m
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-16.
//  Copyright 2010 LittleKiwi. All rights reserved.
//

#import "HTTextView.h"

@interface SOTextView ()



@end


@implementation SOTextView
/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.selectedRange.length == 0 &&
        [_soDelegate respondsToSelector:@selector(soTextViewWasTapped:)])
        
        [_soDelegate soTextViewWasTapped:self];
}*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

@end