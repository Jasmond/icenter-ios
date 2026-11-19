//
//  slideView.h
//  ischooliparent
//
//  Created by Jasmond Luk on 6/6/2019.
//  Copyright © 2019 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol mySlideViewDelegate <NSObject>

-(void) selectedSlideIndex:(NSInteger)slideindex;
-(void) deleteSlideWithIndex:(NSInteger)slideindex;
-(void) addSlideWithButton:(UIButton *)button;
@end

@interface slideView : UIView
{
    __weak IBOutlet UIImageView *imageview;
    __weak IBOutlet UILabel *titlelabel;
    __weak IBOutlet UIView *titleview;
    __weak IBOutlet UIButton *viewbutton;
    __weak IBOutlet UILabel *daylabel;
    __weak IBOutlet UIButton *deletebutton;
    __weak IBOutlet UIView *slidemasterview;
    __weak IBOutlet UIView *addview;
    __weak IBOutlet UIImageView *videoplayicon;
    
}

@property (weak,nonatomic)id<mySlideViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *view;
- (IBAction)viewbuttonpressed:(UIButton *)sender;
- (IBAction)deletebuttonpressed:(id)sender;
- (IBAction)addbuttonpressed:(id)sender;
-(id) initWithFrame:(CGRect)frame SlidePhotoRecord:(SlidePhotoRecord *)slidephotoobject SlideIndex:(NSInteger)slideindex;

@end

NS_ASSUME_NONNULL_END
