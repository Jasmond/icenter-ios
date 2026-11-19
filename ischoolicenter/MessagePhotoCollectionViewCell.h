//
//  MessagePhotoCollectionViewCell.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 22/12/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePhotoCollectionViewCell : UICollectionViewCell
{
    UIImageView *photoimageView;
    //UIImageView *actionimageView;
    UIButton *deleteimagebutton;
    UIButton *addimagebutton;
    UIImageView *videoplayicon;
}

@property (nonatomic,retain) UIImageView *photoimageView;
@property (nonatomic,retain) UIImageView *actionimageView;
@property (nonatomic,retain) UIButton *deleteimagebutton;
@property (nonatomic,retain) UIButton *addimagebutton;
@property (nonatomic,retain) UIImageView *videoplayicon;

@end
