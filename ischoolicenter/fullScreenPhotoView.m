//
//  fullScreenPhotoView.m
//  ischooliparent
//
//  Created by Jasmond Luk on 13/6/2019.
//  Copyright © 2019 Dreamware Limited. All rights reserved.
//

#import "fullScreenPhotoView.h"
#import "MyClass.h"

@implementation fullScreenPhotoView
@synthesize view,mode,player;

/*-(id) initWithFrame:(CGRect)frame SlidePhotoRecord:(SlidePhotoRecord *)slidephotoobject SlideIndex:(NSInteger)slideindex Mode:(NSString *)mode ImageType:(NSString *)imagetype FileURL:(NSURL *)fileurl FullScreenViewcontroller:(UIViewController *)fullscreenviewcontroller
{
    return [self initWithFrame:frame SlidePhotoRecord:slidephotoobject Image:nil SlideIndex:slideindex Mode:mode ImageType:imagetype FileURL:fileurl Filename:slidephotoobject.filename FullScreenViewController:fullscreenviewcontroller];
}

-(id) initWithFrame:(CGRect)frame Image:(UIImage *)image SlideIndex:(NSInteger)slideindex Mode:(NSString *)mode ImageType:(NSString *)imagetype FileURL:(NSURL *)fileurl Filename:(NSString *)filename FullScreenViewcontroller:(UIViewController *)fullscreenviewcontroller
{
    return [self initWithFrame:frame SlidePhotoRecord:nil Image:image SlideIndex:slideindex Mode:mode ImageType:imagetype FileURL:fileurl Filename:filename FullScreenViewController:fullscreenviewcontroller];
}*/


-(id) initWithFrame:(CGRect)frame FullScreenFileObject:(FullScreenFileRecord *)fullscreenfileobject SlideIndex:(NSInteger)slideindex Mode:(NSString *)mode FullScreenViewcontroller:(UIViewController *)fullscreenviewcontroller
{
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            
            globalvariables=[GlobalVariables singleObj];
            
            _fullscreenfileobject=fullscreenfileobject;
            
            deleteButton.tag=slideindex;
            rotateButton.tag=slideindex;
            self.tag=slideindex;
            player=nil;
            
            [imageview setBackgroundColor:[UIColor blackColor]];
            if ([fullscreenfileobject.filetype isEqualToString:@"image"]) {
                
                if ([fullscreenfileobject.title isEqualToString:@""]) {
                    titleLabel.hidden=YES;
                }else{
                    titleLabel.hidden=NO;
                    titleLabel.text=fullscreenfileobject.title;
                    [self adjustScrollView:titleLabel];
                }
                
                rotatebuttonstack.hidden= [mode isEqualToString:@"View"] || [mode isEqualToString:@"Viewonly"];
                webViewContainer.hidden=YES;
                videoContainer.hidden=YES;
                scrollview.hidden=NO;
                loadingIndicatorContainer.hidden=YES;
                
                if (fullscreenfileobject.imageview.image) {
                    [imageview setImage:fullscreenfileobject.imageview.image];
                }else{
                    [MyClass downloadImageWithImageview:imageview gender:nil type:fullscreenfileobject.downloadfiletype typekey:fullscreenfileobject.fileurl image:@"Yes" async:YES];
                }
            }else if ([fullscreenfileobject.filetype isEqualToString:@"pdf"]){
                titleLabel.hidden=NO;
                titleLabel.text=fullscreenfileobject.filename;
                [self adjustScrollView:titleLabel];
                
                rotatebuttonstack.hidden=YES;
                webViewContainer.hidden=NO;
                videoContainer.hidden=YES;
                scrollview.hidden=YES;
                loadingIndicatorContainer.hidden=NO;
                
                UIImageView *activityImageView=[[UIImageView alloc]init];
                activityImageView.alpha=1.0;
                activityImageView.animationDuration=2;
                activityImageView.frame=CGRectMake(-10,-10,60,60);
                activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
                [activityImageView startAnimating];
                
                loadingIndicator.alpha = 1.0;
                loadingIndicator.color=[UIColor clearColor];
                loadingIndicator.transform=CGAffineTransformMakeScale(1, 1);
                //ailoadindicator.center = CGPointMake(centerview.frame.size.width/2,centerview.frame.size.height/2);
                //loadingIndicator.hidesWhenStopped = YES;
                [loadingIndicator addSubview:activityImageView];
                [loadingIndicator startAnimating];
                
                
                WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
                webView = [[WKWebView alloc] initWithFrame:webViewContainer.bounds configuration:theConfiguration];
                webView.backgroundColor=[UIColor whiteColor];
                webView.navigationDelegate = self;
                webView.UIDelegate=self;
                [webViewContainer addSubview:webView];


                webView.translatesAutoresizingMaskIntoConstraints = NO;

                //Trailing
                NSLayoutConstraint *trailing =[NSLayoutConstraint
                                                constraintWithItem:webView
                                                attribute:NSLayoutAttributeTrailing
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:webViewContainer
                                                attribute:NSLayoutAttributeTrailing
                                                multiplier:1.0f
                                                constant:0.f];

                //Leading

                NSLayoutConstraint *leading = [NSLayoutConstraint
                                                   constraintWithItem:webView
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:webViewContainer
                                                   attribute:NSLayoutAttributeLeading
                                                   multiplier:1.0f
                                                   constant:0.f];

                //Bottom
                NSLayoutConstraint *bottom =[NSLayoutConstraint
                                                 constraintWithItem:webView
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:webViewContainer
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0f
                                                 constant:0.f];

                //Top
                NSLayoutConstraint *top =[NSLayoutConstraint
                                                 constraintWithItem:webView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:webViewContainer
                                                 attribute:NSLayoutAttributeTop
                                                 multiplier:1.0f
                                                 constant:0.f];

                //Add constraints to the Parent
                [webViewContainer addConstraint:trailing];
                [webViewContainer addConstraint:bottom];
                [webViewContainer addConstraint:leading];
                [webViewContainer addConstraint:top];
                
                NSURL *pdfURL;
                if (![fullscreenfileobject.action isEqualToString:@""]) {
                    pdfURL=fullscreenfileobject.internalurl;
                }else{
                    pdfURL=[MyClass returndownloadImageURLwithType:fullscreenfileobject.downloadfiletype typekey:fullscreenfileobject.fileurl];
                }
                
                [webView loadRequest:[NSURLRequest requestWithURL:pdfURL]];
            }else if([fullscreenfileobject.filetype isEqualToString:@"video"]){
                
                if ([fullscreenfileobject.title isEqualToString:@""]) {
                    titleLabel.hidden=YES;
                }else{
                    titleLabel.hidden=NO;
                    titleLabel.text=fullscreenfileobject.title;
                    [self adjustScrollView:titleLabel];
                }
                
                rotatebuttonstack.hidden=YES;
                webViewContainer.hidden=YES;
                videoContainer.hidden=NO;
                scrollview.hidden=YES;
                
                NSURL *videoURL;
                if (![fullscreenfileobject.action isEqualToString:@""]) {
                    videoURL=fullscreenfileobject.internalurl;
                }else{
                    videoURL=[MyClass returndownloadImageURLwithType:fullscreenfileobject.downloadfiletype typekey:fullscreenfileobject.fileurl];
                }

                player=[AVPlayer playerWithURL:videoURL];
                avplayerviewcontroller=[[AVPlayerViewController alloc]init];
                avplayerviewcontroller.player=player;
                avplayerviewcontroller.view.frame=videoContainer.bounds;
                [videoContainer addSubview:avplayerviewcontroller.view];
                [fullscreenviewcontroller addChildViewController:avplayerviewcontroller];
                [avplayerviewcontroller didMoveToParentViewController:fullscreenviewcontroller];

                
//                [player play];
                loadingIndicatorContainer.hidden=YES;
            }
            
            if ([mode isEqualToString:@"View"]) {
                editStack.hidden=YES;
                shareStack.hidden=NO;
            }else if ([mode isEqualToString:@"Viewonly"]) {
                editStack.hidden=YES;
                shareStack.hidden=YES;
            }else{
                editStack.hidden=NO;
                shareStack.hidden=YES;
            }
            
            self.view.frame=self.bounds;
            [self addSubview:self.view];
            
        }
    }
    return self;
}

-(void) adjustScrollView:(UILabel *)label
{
    [label sizeToFit];
    if (label.frame.size.height>150) {
        scrollviewheightconstraint.constant=150;
        labelScrollView.scrollEnabled=YES;
    }else{
        scrollviewheightconstraint.constant=label.frame.size.height;
        labelScrollView.scrollEnabled=NO;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageview;
}

-(void) closeviewbuttonpressed:(id)sender
{
    if ([_fullscreenfileobject.filetype isEqualToString:@"video"]) {
        [player pause];
        [player replaceCurrentItemWithPlayerItem:nil]; // Detaches the current item to completely stop buffering/audio
        player = nil;
    }
    [self.delegate closeFullScreenPhotoViewWithIndex:self.tag];
}

-(void)sharebuttonpressed:(id)sender
{
    [self.delegate shareFileWithFullScreenFileRecord:_fullscreenfileobject button:sender];
}

- (IBAction)rotatebuttonpressed:(UIButton *)sender {
    [imageview setImage:[MyClass imageRotatedOnDegrees:90 Image:imageview.image]];
    [self.delegate returnRotatedImage:imageview.image Index:self.tag];
}

- (IBAction)deletebuttonpressed:(UIButton *)sender {
    [self.delegate deleteImageWithIndex:self.tag];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [loadingIndicator stopAnimating];
    loadingIndicatorContainer.hidden=YES;
}

@end
