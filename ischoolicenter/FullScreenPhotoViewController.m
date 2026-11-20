//
//  FullScreenPhotoViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 12/6/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import "FullScreenPhotoViewController.h"



@interface FullScreenPhotoViewController ()
{
    CGSize laidOutPageSize;
}

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
    laidOutPageSize = CGSizeZero;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!filearray) {
        return;
    }
    CGSize size = scrollview.bounds.size;
    if (size.width < 1 || size.height < 1) {
        return;
    }
    if (fabs(size.width - laidOutPageSize.width) < 0.5 && fabs(size.height - laidOutPageSize.height) < 0.5) {
        return;
    }
    NSInteger pageIndex = index;
    if (laidOutPageSize.width > 1) {
        pageIndex = (NSInteger)llround(scrollview.contentOffset.x / laidOutPageSize.width);
    }
    if (pageIndex < 0) {
        pageIndex = 0;
    }
    if (filearray.count > 0 && pageIndex >= (NSInteger)filearray.count) {
        pageIndex = (NSInteger)filearray.count - 1;
    }
    laidOutPageSize = size;
    [[scrollview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    scrollview.contentSize = CGSizeMake(size.width * filearray.count, size.height);
    scrollview.contentOffset = CGPointMake(pageIndex * size.width, 0);
    [self moveSlideWindowWithPageIndex:pageIndex];
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
                CGSize pageSize = scrollview.bounds.size;
                fullscreenphotoview=[[fullScreenPhotoView alloc]initWithFrame:CGRectMake(pageSize.width*i, 0, pageSize.width, pageSize.height) FullScreenFileObject:obj SlideIndex:i Mode:mode FullScreenViewcontroller:self];
                
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
    CGFloat pageWidth = scrollview.bounds.size.width;
    if (pageWidth <= 0) {
        return;
    }
    NSInteger pageIndex=(NSInteger)llround(scrollView.contentOffset.x/pageWidth);
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
