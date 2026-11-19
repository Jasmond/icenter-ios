//
//  FullScreenPhotoViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 12/6/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import "FullScreenPhotoViewController.h"



@interface FullScreenPhotoViewController ()

@end

@implementation FullScreenPhotoViewController
@synthesize fileArray,index,mode;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void) convertFileArray
{
    filearray=[[NSMutableArray alloc]init];

    for (int i=0; i<fileArray.count; i++) {
        if ([[fileArray objectAtIndex:i] isKindOfClass:[PhotoCornerFileRecord class]]) {
            PhotoCornerFileRecord *photocornerfileobject=[fileArray objectAtIndex:i];
            UIImageView *newimage=[[UIImageView alloc]init];
            [newimage setImage:photocornerfileobject.imageview.image];
            
            FullScreenFileRecord *fullscreenobject=[[FullScreenFileRecord alloc]initFullScreenFileRecordWithCenterkey:photocornerfileobject.centerkey TypeKey:photocornerfileobject.photocornerfilekey FileURL:photocornerfileobject.fileurl ImageView:newimage Width:photocornerfileobject.width Height:photocornerfileobject.height FileType:photocornerfileobject.filetype InternalURL:photocornerfileobject.internalurl FileName:photocornerfileobject.filename ThumbnailURL:photocornerfileobject.thumbnailurl Action:photocornerfileobject.action DownloadFileType:@"class" Title:photocornerfileobject.title];
            
            [filearray addObject:fullscreenobject];
            
        }else if ([[fileArray objectAtIndex:i] isKindOfClass:[SlidePhotoRecord class]]){
            SlidePhotoRecord *slidephotoobject=[fileArray objectAtIndex:i];

            FullScreenFileRecord *fullscreenobject=[[FullScreenFileRecord alloc]initFullScreenFileRecordWithCenterkey:slidephotoobject.centerkey TypeKey:slidephotoobject.typekey FileURL:slidephotoobject.fileurl ImageView:nil Width:[slidephotoobject.width floatValue] Height:[slidephotoobject.height floatValue] FileType:slidephotoobject.filetype InternalURL:nil FileName:slidephotoobject.filename ThumbnailURL:slidephotoobject.thumbnailurl Action:@"" DownloadFileType:@"" Title:slidephotoobject.title];
            
            if ([slidephotoobject.type isEqualToString:@"student"]) {
                fullscreenobject.downloadfiletype=@"student";
                fullscreenobject.fileurl=slidephotoobject.typekey;
            }else if ([slidephotoobject.type isEqualToString:@"lead"]){
                fullscreenobject.downloadfiletype=@"lead";
                fullscreenobject.fileurl=slidephotoobject.typekey;
            }else if ([slidephotoobject.type isEqualToString:@"staff"]){
                fullscreenobject.downloadfiletype=@"staff";
            }else if ([slidephotoobject.type isEqualToString:@"whatsnew"]){
                fullscreenobject.downloadfiletype=@"whatsnew";
            }else if ([slidephotoobject.type isEqualToString:@"videomanual"]){
                fullscreenobject.downloadfiletype=@"videomanual";
            }else{
                fullscreenobject.downloadfiletype=slidephotoobject.type;
            }
            
            [filearray addObject:fullscreenobject];
            
        }else if ([[fileArray objectAtIndex:i] isKindOfClass:[MessagePhotoRecord class]]){
            MessagePhotoRecord *messagephotoobject=[fileArray objectAtIndex:i];
            UIImageView *newimage=[[UIImageView alloc]init];
            [newimage setImage:messagephotoobject.imageview.image];
            
            FullScreenFileRecord *fullscreenobject=[[FullScreenFileRecord alloc]initFullScreenFileRecordWithCenterkey:globalvariables.centerrecord.centerkey TypeKey:messagephotoobject.messagephotokey FileURL:messagephotoobject.messagephotourl ImageView:newimage Width:messagephotoobject.width Height:messagephotoobject.height FileType:messagephotoobject.filetype InternalURL:messagephotoobject.internalurl FileName:messagephotoobject.filename ThumbnailURL:messagephotoobject.thumbnailurl Action:[mode isEqualToString:@"View"]?@"":mode DownloadFileType:@"message" Title:@""];
            
            
            [filearray addObject:fullscreenobject];
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self convertFileArray];
    [[scrollview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    scrollview.contentSize=CGSizeMake(self.view.frame.size.width*filearray.count, self.view.frame.size.height);
    scrollview.contentOffset=CGPointMake(index*self.view.frame.size.width, 0);
    [self moveSlideWindowWithPageIndex:index];
    
}

-(void) moveSlideWindowWithPageIndex:(NSInteger)pageindex
{
    NSInteger windowsize=10;
    
    NSInteger righttodelete=pageindex+windowsize+1;
    if (righttodelete<filearray.count) {
        fullScreenPhotoView *fullscreenphotoview=[scrollview viewWithTag:righttodelete];
        if (fullscreenphotoview && [fullscreenphotoview isKindOfClass:[fullScreenPhotoView class]]) {
            [[fullscreenphotoview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [fullscreenphotoview removeFromSuperview];
        }
    }
    
    NSInteger lefttodelete=pageindex-windowsize-1;
    if (lefttodelete>=0) {
        fullScreenPhotoView *fullscreenphotoview=[scrollview viewWithTag:lefttodelete];
        if (fullscreenphotoview && [fullscreenphotoview isKindOfClass:[fullScreenPhotoView class]]) {
            [[fullscreenphotoview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [fullscreenphotoview removeFromSuperview];
        }
    }
    
    
    for (NSInteger i=pageindex-windowsize; i<=pageindex+windowsize; i++) {
        if (i>=0 && i<filearray.count) {
            fullScreenPhotoView *fullscreenphotoview=[scrollview viewWithTag:i];
            
            if (!fullscreenphotoview || ![fullscreenphotoview isKindOfClass:[fullScreenPhotoView class]]) {
                FullScreenFileRecord *obj=[filearray objectAtIndex:i];
                fullscreenphotoview=[[fullScreenPhotoView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height) FullScreenFileObject:obj SlideIndex:i Mode:mode FullScreenViewcontroller:self];
                
                fullscreenphotoview.delegate=self;
                [scrollview addSubview:fullscreenphotoview];
                
            }
        }
    }
    
    fullScreenPhotoView *fullscreenphotoview=[scrollview viewWithTag:pageindex];
    if(fullscreenphotoview.player){
        [fullscreenphotoview.player seekToTime:kCMTimeZero];
        [fullscreenphotoview.player play];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex=round(scrollView.contentOffset.x/self.view.frame.size.width);
    [self moveSlideWindowWithPageIndex:pageIndex];
    
    //NSInteger pageIndex=round(scrollView.contentOffset.x/self.view.frame.size.width);
    //reset zoom for adjacent photos
    fullScreenPhotoView *fullscreenphotoview=[scrollview viewWithTag:pageIndex+1];
    if (fullscreenphotoview) {
        UIScrollView *scroll_view=[fullscreenphotoview viewWithTag:24];
        scroll_view.zoomScale=1;
        [fullscreenphotoview.player pause];
    }
    fullscreenphotoview=[scrollview viewWithTag:pageIndex-1];
    if (fullscreenphotoview) {
        UIScrollView *scroll_view=[fullscreenphotoview viewWithTag:24];
        scroll_view.zoomScale=1;
        [fullscreenphotoview.player pause];
    }
    
}

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
    [self.delegate closeFullScreenPhotoViewWithIndex:index];
}

-(void) shareFileWithFullScreenFileRecord:(FullScreenFileRecord *)fullscreenfileobject button:(UIButton *)button
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![fullscreenfileobject.filetype isEqualToString:@"image"]) {
            NSURL *url = [MyClass returndownloadImageURLwithType:fullscreenfileobject.downloadfiletype typekey:fullscreenfileobject.fileurl];
            NSData *pdfdata=[[NSData alloc]initWithContentsOfURL:url];
            
            NSURL *fileUrl=[MyClass returnInternalURLforNSData:pdfdata Filename:fullscreenfileobject.filename];
            NSArray *activityItems = @[fileUrl];
            UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            
            activityVC.modalPresentationStyle=UIModalPresentationPopover;
            UIPopoverPresentationController * mypopovercontroller=activityVC.popoverPresentationController;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=button;
            mypopovercontroller.sourceRect=button.bounds;
            [self presentViewController:activityVC animated:TRUE completion:nil];
            
        }else{
            NSURL *url = [MyClass returndownloadImageURLwithType:fullscreenfileobject.downloadfiletype typekey:fullscreenfileobject.fileurl];
            NSData *imagedata=[[NSData alloc]initWithContentsOfURL:url];
            UIImage * image=[UIImage imageWithData:imagedata];
            
            NSArray *activityItems = @[image];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityVC.modalPresentationStyle=UIModalPresentationPopover;
            UIPopoverPresentationController * mypopovercontroller=activityVC.popoverPresentationController;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=button;
            mypopovercontroller.sourceRect=button.bounds;
            [self presentViewController:activityVC animated:TRUE completion:nil];
        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}


-(void)returnRotatedImage:(UIImage *)image Index:(NSInteger)index
{
    [self.delegate returnRotatedImage:image Index:index];
}

-(void)deleteImageWithIndex:(NSInteger)index
{
    [self.delegate deleteImageWithIndex:index];
}

- (void)selectedSlideIndex:(NSInteger)slideindex Image:(nonnull UIImage *)slideimage {
    
}


@end
