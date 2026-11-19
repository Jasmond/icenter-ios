//
//  MarketingPopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 7/6/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "GCPlaceholderTextView.h"
#import "CalendarView.h"
#import "MainViewController.h"

@protocol myMarketingPopoverViewControllerDelegate <NSObject>

-(void) dismissMarketingPopover;
-(void) gotostudentprofile:(NSString *)studentkey enrollmentkey:(NSString *)enrollmentkey;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface MarketingPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UISearchBarDelegate,myCalendarViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    MainViewController *mainviewcontroller;
    NSString *tmpDiscountType;
    MarketingRecord *workingMarketing;
    
    long presetRow;
    long datePresetRow;
    
//    BOOL showStartDatePicker;
//    BOOL showEndDatePicker;
    BOOL showQuotaInput;
    BOOL showCreditable;
    
    GlobalVariables *globalvariables;
    
    BOOL keyboardshow;
    float keyboardheight;
    
    NSMutableArray *JSONArray;
    
    NSMutableArray *pickerViewMenu;
    UIPickerView *myPickerView;
    
    __weak IBOutlet UIToolbar *MarketingToolbar;
    __weak IBOutlet UITableView *MarketingPopoverTable;
    __weak IBOutlet NSLayoutConstraint *marketingTableBottomConstraint;
    NSMutableArray *quotaarray;
    NSMutableArray *couponallowcreditarray;
    
    NSString *selectedItem;
    
    NSDateFormatter *df;
    
    NSMutableArray *userListArray;
    
    BOOL marketingPromotionCanBeChanged;
    
    UITableView *studentListTable;
    
    UIView *studentListTableMasterView;
    UIToolbar *studentListTableToolBar;
    BOOL showStudentListTable;
    UISearchBar *studentlistsearchbar;
    
    NSMutableArray *filteredStudentListArray;
    NSMutableArray *studentListArray;
    
    Student *studentobject;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
    CalendarView *datecalendarview;
    __weak IBOutlet UIView *DateMasterView;
    __weak IBOutlet UIToolbar *datetoolbar;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *noneButton;
    __weak IBOutlet UILabel *datetitle;
    BOOL showDateTable;
    
    __weak IBOutlet UIView *DayMasterView;
    __weak IBOutlet UIToolbar *daytoolbar;
    __weak IBOutlet UIButton *daynoneButton;
    __weak IBOutlet UILabel *daytitle;
    __weak IBOutlet UITableView *daytable;
    BOOL showDayTable;
    
    NSMutableArray *dayListArray;
    
    __weak IBOutlet UIView *SubjectMasterView;
    __weak IBOutlet UIToolbar *subjecttoolbar;
    __weak IBOutlet UIButton *subjectNoneButton;
    __weak IBOutlet UIButton *subjectAllButton;
    __weak IBOutlet UITableView *subjecttable;
    __weak IBOutlet NSLayoutConstraint *subjecttablebottomconstraint;
    UISearchBar *subjectsearchbar;
    BOOL showSubjectTable;
    NSMutableArray *subjectArray;
    NSMutableArray *filteredSubjectArray;
    
    __weak IBOutlet UIView *ProductMasterView;
    __weak IBOutlet UIToolbar *producttoolbar;
    __weak IBOutlet UIButton *productNoneButton;
    __weak IBOutlet UIButton *productAllButton;
    __weak IBOutlet UITableView *producttable;
    __weak IBOutlet NSLayoutConstraint *producttablebottomconstraint;
    UISearchBar *productsearchbar;
    BOOL showProductTable;
    NSMutableArray *ProductArray;
    NSMutableArray *filteredProductArray;
    
    __weak IBOutlet UIView *NumberMasterView;
    __weak IBOutlet UIToolbar *numbertoolbar;
    __weak IBOutlet UILabel *numbertitle;
    __weak IBOutlet UITableView *numbertable;
    BOOL showNumberTable;
    NSMutableArray *numberListArray;
    
    __weak IBOutlet UIButton *cloneButton;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;

}

@property (strong,nonatomic) NSString *MarketingTableMode;
@property (strong,nonatomic) MarketingRecord *MarketingRecordObject;
@property (strong,nonatomic) NSString *MarketingTableCategory;
@property (weak,nonatomic)id<myMarketingPopoverViewControllerDelegate>delegate;
- (IBAction)daynonebuttonpressed:(id)sender;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)datenonebuttonpressed:(id)sender;
- (IBAction)subjectallbuttonpressed:(id)sender;
- (IBAction)subjectnonebuttonpressed:(id)sender;
- (IBAction)productallbuttonpressed:(id)sender;
- (IBAction)productnonebuttonpressed:(id)sender;

-(IBAction) editButtonPressed:(id)sender;
-(IBAction) deleteButtonPressed:(id)sender;
-(IBAction) cloneButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
