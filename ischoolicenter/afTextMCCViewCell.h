//
//  afTextMCCViewCell.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 31/5/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface afTextMCCViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *multiplechoiceimage;
@property (weak, nonatomic) IBOutlet UILabel *multiplechoicetitle;
@property (weak, nonatomic) IBOutlet UIButton *multiplechoicebutton;
@property (weak, nonatomic) IBOutlet UIStackView *textstack;
@property (weak, nonatomic) IBOutlet UIStackView *mcstack;
@property (weak, nonatomic) IBOutlet UILabel *texttitle;
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

NS_ASSUME_NONNULL_END
