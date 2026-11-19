//
//  StaffPopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 11/11/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "CalendarView.h"


@protocol myStaffPopoverViewControllerDelegate <NSObject>

- (void) dismissStaffPopoverWithLogoutOption:(BOOL)option;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface StaffPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,myCalendarViewDelegate>
{
    
    GlobalVariables *globalvariables;
    
    //sqlite3 *isdb;
    
    UILabel *GeneralLabel;
    
    UILabel *FirstNameLabel;
    UILabel *LastNameLabel;
    UILabel *StatusLabel;
    UILabel *UsernameLabel;
    UILabel *PhoneLabel;
    UIImageView *RoleLabel;
    UILabel *GroupLabel;
    UILabel *PrivilegeLabel;
    UIImageView *iCenterappLabel;
    UIImageView *iStaffappLabel;
    UIImageView *BIappLabel;
    UIImageView *MonLabel;
    UIImageView *TueLabel;
    UIImageView *WedLabel;
    UIImageView *ThuLabel;
    UIImageView *FriLabel;
    UIImageView *SatLabel;
    UIImageView *SunLabel;
    UILabel *SalaryRateLabel;
    
    UITextField *FirstNameText;
    UITextField *LastNameText;
    UISegmentedControl *scStatus;
    UITextField *UsernameText;
    UITextField *PhoneText;
    UITextField *SalaryrateText;
    
//    UISwitch *swTeaching;
//    UISwitch *swiCenterapp;
//    UISwitch *swiStaffapp;
//    UISwitch *swBIapp;
    
    UIButton *deleteButton;
    
    NSString *selectedItem;
    NSString *selectedValue;
    
    Staff *workingStaff;
    UITextView *RemarksText;
    
    int presetRow;
    int datePresetRow;
    int minutePresetRow;
    int hourPresetRow;
    
    BOOL showDeleteButton;
    
    BOOL keyboardshow;
    float keyboardheight;
    
    IBOutlet UIToolbar *StaffToolBar;
    
    NSMutableArray *JSONArray;
    NSMutableArray *pickerViewmenu;
    UIPickerView *myPickerView;
    
    NSMutableArray *RoleArray;
    NSMutableArray *PrivilegeArray;
    //NSMutableArray *GroupArray;
    //NSMutableArray *tmpGroup;
    
//    UITableView *StaffPopoverTable;
    __weak IBOutlet UITableView *StaffPopoverTable;
    __weak IBOutlet NSLayoutConstraint *stafftablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *competencytablebottomconstraint;
    //UITableView *GroupSelectionTable;
    
    UIPopoverPresentationController *myPopoverController;
    
    BOOL staffCanBeDeleted;
    
    UIView *PrivilegeTableMasterView;
    UITableView *PrivilegeTable;
    UIToolbar *PrivilegeTableToolBar;
    BOOL showPrivilegeTable;
    
    __weak IBOutlet UIView *CompetenceTableMasterView;
    __weak IBOutlet UITableView *CompetencyTable;
    __weak IBOutlet UIToolbar *CompetencyTableToolBar;
    BOOL showCompetencyTable;

    __weak IBOutlet UIView *GroupTableMasterView;
//    UIView *GroupTableMasterView;
//    UITableView *GroupTable;
//    UIToolbar *GroupTableToolBar;
    __weak IBOutlet UIToolbar *GroupTableToolBar;
    __weak IBOutlet UITableView *GroupTable;
    BOOL showGroupTable;

    UIView *ColorCodeTableMasterView;
    UITableView *ColorCodeTable;
    UIToolbar *ColorCodeTableToolBar;
    BOOL showColorCodeTable;
    
    NSInteger repeatinterval;
    NSString *endrepeatdate;
    NSMutableArray *availabilityRowDataArray;
    
    __weak IBOutlet UIView *StaffScheduleMasterView;
    //__weak IBOutlet UIToolbar *StaffScheduleToolBar;
    __weak IBOutlet UILabel *StaffScheduleTitleLabel;
    __weak IBOutlet UIView *calendarMasterView;
    __weak IBOutlet UIView *instructoravailabilityview;
    __weak IBOutlet UITableView *availabilityTable;
    __weak IBOutlet UILabel *menuTitle;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *backArrow;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIButton *selectButton;
    __weak IBOutlet UIButton *doneButton;
    BOOL showStaffSchedule;
    __weak IBOutlet UIView *endrepeatview;
    __weak IBOutlet UIView *pickerview;
    __weak IBOutlet UITableView *pickerTable;
    NSArray *repeatArray;
    
    CalendarView *calendarview;
    CalendarView *endrepeatcalendarview;
    NSMutableDictionary *instructoravailabilitydict;
    NSMutableDictionary *classrecordsdict;
    
    int timestep;
    NSMutableArray *selectedDates;
    NSMutableArray *workingAvRecords;
    NSMutableArray *classRecords;
    
    NSMutableArray *ScheduledClassRecordArray;
    
    CalendarView *datecalendarview;
    __weak IBOutlet UIView *DateMasterView;
    __weak IBOutlet UIToolbar *datetoolbar;
    __weak IBOutlet UIButton *dateBackButton;
    __weak IBOutlet UIButton *noneButton;
    __weak IBOutlet UILabel *datetitle;
    BOOL showDateTable;
    
    __weak IBOutlet UIButton *main_editButton;
    __weak IBOutlet UIButton *main_cancelButton;
    __weak IBOutlet UIButton *main_doneButton;
    
}
@property (nonatomic,strong) Staff *StaffObject;
@property (nonatomic,strong) NSString *StaffTableMode;
@property (nonatomic,weak)id<myStaffPopoverViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *RoleArray;
@property (nonatomic,strong) NSMutableArray *PrivilegeArray;
@property (nonatomic,strong) NSMutableArray *GroupArray;
@property (nonatomic) BOOL readonly;

- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)selectbuttonpressed:(id)sender;
- (IBAction)cancelbuttonpressed:(id)sender;
- (IBAction)donebuttonpressed:(id)sender;
- (IBAction)editbuttonpressed:(id)sender;
- (IBAction)datenonebuttonpressed:(id)sender;

-(IBAction) editButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
