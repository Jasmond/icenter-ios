//
//  ProductPopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 7/12/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyTableViewCell.h"

@protocol myProductPopoverViewControllerDelegate <NSObject>

-(void) dismissProductPopover;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) donotrunviewdidappear;
@end

@interface ProductPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverPresentationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GlobalVariables *globalvariables;
    
    //sqlite3 *isdb;
    
    UILabel *GeneralLabel;

    UILabel *CategoryLabel;
    UILabel *EnglishnameLabel;
    UILabel *ChinesenameLabel;
    UILabel *CodeLabel;
    UILabel *PriceLabel;
    UILabel *StatusLabel;
    UILabel *RemarksLabel;
    
//    UITextField *CategoryText;
//    UITextField *EnglishnameText;
//    UITextField *ChinesenameText;
//    UITextField *CodeText;
//    UITextField *PriceText;
    
//    UITextView *RemarksText;
    
    UISegmentedControl *scStatus;
    UIButton *deleteButton;
    
    ProductRecord *workingProduct;

    BOOL showAutoRenew;
    UIView *AutoRenewTableMasterView;
    UITableView *AutoRenewTable;
    UIToolbar *AutoRenewTableToolBar;
    UIPickerView *myPickerView;
    
    int presetRow;
    
    
    BOOL keyboardshow;
    float keyboardheight;
    
    __weak IBOutlet UIToolbar *ProductToolBar;
    
    NSMutableArray *JSONArray;
    
    __weak IBOutlet UITableView *ProductPopoverTable;
    NSMutableArray *dayPickerViewMenu;
    NSMutableArray *autoRenewTypePickerViewMenu;
    NSMutableArray *autoRenewValuePickerViewMenu;
    
    BOOL productCanBeDeleted;
    BOOL photoimagechanged;
    PhotoCornerFileRecord *photocornerobject;
    
    BOOL showProductPhoto;
    NSMutableArray * recipientRowDataArray;
    UIButton *addphotobutton;
    UIPopoverPresentationController *mypopovercontroller;
    UIImagePickerController *imagepicker;
    UIScrollView *fullscreen_scrollview;
    UIButton * fullscreen_closebutton;
    UIImageView *fullscreen_messageimageview;
    UIView *MessagePhotoMasterView;
    UIToolbar *MessagePhotoToolBar;
    __weak IBOutlet NSLayoutConstraint *tablebottomconstraint;
    __weak IBOutlet UIButton *cloneButton;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
    
    UIButton *photocloseButton;
    UIButton *photorotateButton;
    UIButton *photoshareButton;
}

@property (nonatomic,strong) ProductRecord *ProductObject;
@property (nonatomic,strong) NSMutableArray *ProductCategoryArray;
@property (nonatomic,strong) NSMutableArray *ProductCodeArray;
@property (nonatomic,strong) NSString *ProductTableMode;
@property (nonatomic,weak)id<myProductPopoverViewControllerDelegate>delegate;

-(IBAction) editButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) cloneButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
