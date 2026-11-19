//
//  TimeTableCollectionVFL.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 2/6/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTimeTableCollectionVFL : UICollectionViewFlowLayout
{
    float masterViewheight;
    long expandedsection;
    CGSize contentsize;
    float timewidth;
}
@property (nonatomic) float masterViewheight;
@property (nonatomic) long expandedsection;
@property (nonatomic) CGSize contentsize;
@property (nonatomic) float timewidth;

@end
