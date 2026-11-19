//
//  CalendarCollectionViewCell.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 23/4/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCollectionViewCell : UICollectionViewCell
{
    UILabel *daylabel;
    UIView *hasclassviewdot;
    UIView *todaybackground;
}

@property (nonatomic,retain) UILabel *daylabel;
@property (nonatomic,retain) UIView *hasclassviewdot;
@property (nonatomic,retain) UIView *todaybackground;

@end
