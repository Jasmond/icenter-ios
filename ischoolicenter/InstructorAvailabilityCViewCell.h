//
//  InstructorAvailabilityCViewCell.h
//  iStaff
//
//  Created by Jasmond Luk on 12/10/2018.
//  Copyright © 2018 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstructorAvailabilityCViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *daylabel;
@property (strong, nonatomic) IBOutlet UIView *todaybackground;
@property (strong, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todaybackgroundheightcontstraint;
@property (weak, nonatomic) IBOutlet UIImageView *availabilityimage;
@property (weak, nonatomic) IBOutlet UIView *checkedview;

@end

NS_ASSUME_NONNULL_END
