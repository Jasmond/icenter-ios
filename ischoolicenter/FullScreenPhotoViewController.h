//
//  FullScreenPhotoViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 12/6/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"
#import "fullScreenPhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myFullScreenPhotoViewControllerDelegate <NSObject>

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index;
-(void) returnRotatedImage:(UIImage *)image Index:(NSInteger)index;
-(void) deleteImageWithIndex:(NSInteger)index;
@end

@interface FullScreenPhotoViewController : UIViewController<UIScrollViewDelegate,myfullScreenPhotoViewDelegate>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIScrollView *scrollview;
    SlidePhotoRecord *slidephotoobject;
    NSMutableArray *filearray;
}
@property (weak,nonatomic)id<myFullScreenPhotoViewControllerDelegate>delegate;
@property (nonatomic,strong) NSString *mode;
@property (nonatomic) NSInteger index;
@property (nonatomic,strong) NSMutableArray *fileArray;
@property (strong,nonatomic) UIWindow *displayWindow;

@end

NS_ASSUME_NONNULL_END
