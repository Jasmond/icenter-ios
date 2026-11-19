//
//  PhotoCornerViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 31/3/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "GCPlaceholderTextView.h"
#import "SwitchCenterViewController.h"
#import "FullScreenPhotoViewController.h"
#import "ClassPhotoPopoverViewController.h"
#import "PickerViewController.h"
#import "MainViewController.h"


@interface ClassPhotoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,mySwitchCenterViewControllerDelegate,myFullScreenPhotoViewControllerDelegate,myClassPhotoPopoverVCDelegate,myPickerViewControllerDelegate,UIPopoverPresentationControllerDelegate,UIDocumentPickerDelegate>{
    GlobalVariables *globalvariables;
    //sqlite3 *isdb;
    
    __weak IBOutlet UITableView *ClassPhotoTable;
    //UITableView *ClassPhotoTable;
    NSDateFormatter *df;
    //UILabel *norecordtitle;
    __weak IBOutlet UILabel *norecordtitle;
    NSMutableArray *ClassPhotoRecordArray;
    NSMutableArray *ClassPhotoRecordArraySearchResult;
    
    MainViewController *mainviewcontroller;
    
    NSMutableArray *jsonArray;
    
    ClassPhotoRecord *classphotoobject;
    
    UIRefreshControl *tablerefresh;
    
    UIButton *menubutton;
    UIButton *addclassphotobutton;
    UIButton *searchphotobutton;
    
    ClassPhotoRecord *workingClassPhoto;

    
    //UIImage *ClassImage;

    
    //float photoheight;
    
    BOOL keyboardshow;

    float keyboardheight;

    
    //UIImage *edit_ClassImage;
    
    
    BOOL imagefromcamera;
    
    UIView *searchbarview;
    UITextField *search_text;
    UIButton *search_favouritebutton;

    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    
    BOOL runviewdidappear;
    FullScreenPhotoViewController *fullscreenphotoviewcontroller;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
}

@property (nonatomic,strong) UIImagePickerController *imagepicker;
@property (nonatomic,strong) UIPopoverPresentationController *mypopovercontroller;
@property (strong,nonatomic) UIWindow *displayWindow;

@end
