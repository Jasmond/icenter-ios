//
//  TimeTableCollectionViewCell.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 2/6/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTimeTableCollectionViewCell : UICollectionViewCell
{
    UIView *cellview;
    UIView *rightline;
}

@property (nonatomic,retain) UIView *cellview;
@property (nonatomic,retain) UIView *rightline;

@end



