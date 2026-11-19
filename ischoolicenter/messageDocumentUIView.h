//
//  messageDocumentUIView.h
//  iCenter
//
//  Created by Jasmond Luk on 22/3/2020.
//  Copyright © 2020 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface messageDocumentUIView : UIView
{
    __weak IBOutlet UIView *filenamebox;
    __weak IBOutlet UILabel *filenametitle;
    __weak IBOutlet UIView *box;
    __weak IBOutlet UIImageView *videoicon;
}

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIButton *viewbutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageheightconstraints;

-(id) initWithFrame:(CGRect)frame messagePhotoRecord:(MessagePhotoRecord *)messagephotorecord;


@end

NS_ASSUME_NONNULL_END
