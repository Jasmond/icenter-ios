//
//  afMultipleChoiceCollectionViewCell.h
//  iCenter
//
//  Created by Jasmond Luk on 26/8/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface afMultipleChoiceCViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *multiplechoiceimage;
@property (weak, nonatomic) IBOutlet UILabel *multiplechoicetitle;
@property (weak, nonatomic) IBOutlet UIButton *multiplechoicebutton;

@end

NS_ASSUME_NONNULL_END
