//
//  UntoggleableSwitch.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 12/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "UntoggleableSwitch.h"

@interface ProxyControl : UIControl

@property (nonatomic, weak) UIControl *actualControl;

@end

@interface UntoggleableSwitch()

@property (nonatomic, strong) ProxyControl *proxyControl;

@end

@implementation UntoggleableSwitch

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        self.proxyControl = [[ProxyControl alloc] initWithFrame:self.frame];
        self.proxyControl.actualControl = self;
        [self addSubview:self.proxyControl];
    }
    
    return self;
}

#pragma mark - UIControl

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.proxyControl addTarget:target action:action forControlEvents:controlEvents];
}

@end

@implementation ProxyControl

#pragma mark - UIControl

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    UIControl *actualControl = self.actualControl;
    [actualControl sendAction:action to:target forEvent:event];
}

@end