//
//  ClassPhotoPopoverViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 18/6/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"
#import "MyTableViewCell.h"
#import "CalendarView.h"
#import "WebKit/WebKit.h"
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol myClassPhotoPopoverVCDelegate <NSObject>

-(void) dismissClassPhotoPopoverVCWithReload:(BOOL)reload ScrollToTop:(BOOL)scrolltotop;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) donotrunviewdidappear;

@end


@interface ClassPhotoPopoverViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myCalendarViewDelegate,UIDocumentPickerDelegate,UIPopoverPresentationControllerDelegate,UISearchBarDelegate>
{
    GlobalVariables *globalvariables;
    
    __weak IBOutlet UITableView *editTable;
    __weak IBOutlet UIToolbar *ClassPhotoToolBar;
    __weak IBOutlet UIView *expirydateview;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *noneButton;
    __weak IBOutlet UILabel *expirydatetitle;
    
    ClassPhotoRecord *workingClassPhoto;
    
//    UIImage *orig_ClassImage;
//    UIImage *edit_ClassImage;
    BOOL keyboardshow;
    float keyboardheight;
    __weak IBOutlet NSLayoutConstraint *addclassphotoviewbottomconstraint;
    UIPopoverPresentationController *mypopovercontroller;
    UIImagePickerController *imagepicker;

    //UIBarButtonItem *retakeButton;
    BOOL showExpiryDate;
    
    CalendarView *expirydatecalendarview;
    
    UIScrollView *fullscreen_scrollview;
    UIButton * fullscreen_closebutton;
    UIImageView *fullscreen_messageimageview;
    UIView *MessagePhotoMasterView;
    UIToolbar *MessagePhotoToolBar;
    WKWebView *webView;
    UIView *videoView;
    AVPlayerViewController *avplayerviewcontroller;
    BOOL showMessagePhoto;
    
    PhotoCornerFileRecord *photocornerfileobject;
    
    UIButton *addphotobutton;
    
    __weak IBOutlet UIView *CenterMasterView;
    __weak IBOutlet UIToolbar *centertoolbar;
    __weak IBOutlet UIButton *centerNoneButton;
    __weak IBOutlet UIButton *centertAllButton;
    __weak IBOutlet UITableView *centertable;
    __weak IBOutlet NSLayoutConstraint *centertablebottomconstraint;
    UISearchBar *centersearchbar;
    BOOL showCenterTable;
    NSMutableArray *allcenterarray;
    NSMutableArray *filteredCenterArray;
    NSMutableArray *selectedCenters;
    __weak IBOutlet UIView *centertableseparator;
    
    NSInteger minMaxUploadFileSize;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *saveButton;
    
    UIButton *photocloseButton;
    UIButton *photorotateButton;
    
}
@property (nonatomic,weak)id<myClassPhotoPopoverVCDelegate>delegate;
@property (strong,nonatomic) ClassPhotoRecord *classphotoobject;
@property (strong,nonatomic) NSString *mode;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)nonebuttonpressed:(id)sender;
- (IBAction)centernonebuttonpressed:(id)sender;
- (IBAction)centerallbuttonpressed:(id)sender;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;



@end

