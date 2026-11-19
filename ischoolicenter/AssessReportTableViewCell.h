//
//  AssessReportTableViewCell.h
//  iCenter
//
//  Created by Jasmond Luk on 10/8/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssessReportTableViewCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview1;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *gctextview1;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewheightconstraint;

@end

NS_ASSUME_NONNULL_END
