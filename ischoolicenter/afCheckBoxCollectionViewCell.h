//
//  afCheckBoxCollectionViewCell.h
//  iCenter
//
//  Created by Jasmond Luk on 23/5/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface afCheckBoxCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkboximage;
@property (weak, nonatomic) IBOutlet UILabel *checkboxtitle;
@property (weak, nonatomic) IBOutlet UIButton *checkboxbutton;


@end

NS_ASSUME_NONNULL_END
