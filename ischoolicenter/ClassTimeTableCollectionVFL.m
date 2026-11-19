//
//  TimeTableCollectionVFL.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 2/6/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import "ClassTimeTableCollectionVFL.h"

@implementation ClassTimeTableCollectionVFL
@synthesize masterViewheight,expandedsection,contentsize,timewidth;


-(CGSize)collectionViewContentSize
{
    return contentsize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:path];
    int xValue = attributes.size.width/2 + path.row * (attributes.size.width)+timewidth;
    int yValue = attributes.size.height/2 + path.section * (attributes.size.height);

    if (masterViewheight>0 && path.section>expandedsection) {
        yValue+=masterViewheight;
    }
    
    attributes.center = CGPointMake(xValue, yValue);
    return attributes;
    
    
    /*
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(itemWidth,itemHeight);
    int xValue = itemWidth/2 + path.row * (itemWidth + space);
    int yValue = itemHeight + path.section * (itemHeight + space);
    attributes.center = CGPointMake(xValue, yValue);
    return attributes;*/
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    //NSInteger minRow = 0; // need to check because bounce gives negative values  for x.
    //NSInteger maxRow = rect.size.width/(itemWidth + space) + minRow;
    NSMutableArray* attributes = [NSMutableArray array];
    for(NSInteger i=0 ; i < self.collectionView.numberOfSections; i++) {
        for (NSInteger j=0 ; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
    
}

@end
