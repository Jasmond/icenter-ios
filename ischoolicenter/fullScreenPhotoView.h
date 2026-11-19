//
//  fullScreenPhotoView.h
//  ischooliparent
//
//  Created by Jasmond Luk on 13/6/2019.
//  Copyright © 2019 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "WebKit/WebKit.h"
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@protocol myfullScreenPhotoViewDelegate <NSObject>
-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index;
-(void) shareFileWithFullScreenFileRecord:(FullScreenFileRecord *)fullscreenfileobject button:(UIButton *)button;
-(void) returnRotatedImage:(UIImage *)image Index:(NSInteger)index;
-(void) deleteImageWithIndex:(NSInteger)index;
-(void) selectedSlideIndex:(NSInteger)slideindex Image:(UIImage *)slideimage;
@end

@interface fullScreenPhotoView : UIView<WKNavigationDelegate,WKUIDelegate>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UIImageView *imageview;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *rotateImageButton;
    __weak IBOutlet UIButton *rotateButton;
    __weak IBOutlet UIStackView *editStack;
    __weak IBOutlet UIStackView *shareStack;
    __weak IBOutlet UIView *webViewContainer;
    __weak IBOutlet UIView *videoContainer;
    __weak IBOutlet UIView *loadingIndicatorContainer;
    __weak IBOutlet UIActivityIndicatorView *loadingIndicator;
    __weak IBOutlet NSLayoutConstraint *scrollviewheightconstraint;
    __weak IBOutlet UIScrollView *labelScrollView;
    __weak IBOutlet UIStackView *rotatebuttonstack;
    WKWebView *webView;
    AVPlayerViewController *avplayerviewcontroller;
    FullScreenFileRecord *_fullscreenfileobject;
}

@property (weak,nonatomic)id<myfullScreenPhotoViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (nonatomic,strong) NSString *mode;
@property (nonatomic,strong) AVPlayer *player;

//-(id) initWithFrame:(CGRect)frame SlidePhotoRecord:(SlidePhotoRecord *)slidephotoobject SlideIndex:(NSInteger)slideindex Mode:(NSString *)mode ImageType:(NSString *)imagetype FileURL:(NSURL *)fileurl FullScreenViewcontroller:(UIViewController *)fullscreenviewcontroller;
//-(id) initWithFrame:(CGRect)frame Image:(UIImage *)image SlideIndex:(NSInteger)slideindex Mode:(NSString *)mode ImageType:(NSString *)imagetype FileURL:(NSURL *)fileurl Filename:(NSString *)filename FullScreenViewcontroller:(UIViewController *)fullscreenviewcontroller;
-(id) initWithFrame:(CGRect)frame FullScreenFileObject:(FullScreenFileRecord *)fullscreenfileobject SlideIndex:(NSInteger)slideindex Mode:(NSString *)mode FullScreenViewcontroller:(UIViewController *)fullscreenviewcontroller;

- (IBAction)sharebuttonpressed:(id)sender;
- (IBAction)closeviewbuttonpressed:(id)sender;
- (IBAction)deletebuttonpressed:(id)sender;
- (IBAction)rotatebuttonpressed:(id)sender;

@end


