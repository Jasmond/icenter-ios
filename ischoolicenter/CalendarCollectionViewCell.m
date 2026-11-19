//
//  CalendarCollectionViewCell.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 23/4/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import "CalendarCollectionViewCell.h"

@implementation CalendarCollectionViewCell
@synthesize daylabel,hasclassviewdot,todaybackground;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        daylabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        daylabel.textAlignment=NSTextAlignmentCenter;
        daylabel.font=[UIFont systemFontOfSize:14];
        
        todaybackground=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        //todaybackground.layer.cornerRadius=todaybackground.frame.size.width/2;
        todaybackground.layer.masksToBounds=YES;
        //todaybackground.center=daylabel.center;
        todaybackground.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.4];
        
        hasclassviewdot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 4)];
        hasclassviewdot.backgroundColor=[UIColor darkGrayColor];
        hasclassviewdot.layer.cornerRadius=2;
        hasclassviewdot.layer.masksToBounds=YES;
        
        [self addSubview:todaybackground];
        [self addSubview:daylabel];
        [self addSubview:hasclassviewdot];
        
    }
    return self;
}

@end
