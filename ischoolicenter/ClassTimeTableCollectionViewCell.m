//
//  TimeTableCollectionViewCell.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 2/6/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import "ClassTimeTableCollectionViewCell.h"

@implementation ClassTimeTableCollectionViewCell
@synthesize cellview,rightline;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        cellview = [[UIView alloc] init];
        rightline= [[UIView alloc]init];
        rightline.backgroundColor=[UIColor darkGrayColor];
        [self addSubview:cellview];
        [self addSubview:rightline];
    }
    return self;
}

@end
