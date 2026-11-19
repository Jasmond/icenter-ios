//
//  CalendarCViewCell.h
//  iStaff
//
//  Created by Jasmond Luk on 11/10/2018.
//  Copyright © 2018 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarCViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *daylabel;
@property (strong, nonatomic) IBOutlet UIView *hasclassviewdot;
@property (strong, nonatomic) IBOutlet UIView *todaybackground;
@property (strong, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todaybackgroundheightcontstraint;

@end



NS_ASSUME_NONNULL_END
