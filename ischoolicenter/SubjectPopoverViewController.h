//
//  SubjectPopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 24/11/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "InstructorImageGridViewController.h"
#import "CalendarView.h"
#import "PickerViewController.h"

@protocol mySubjectPopoverViewControllerDelegate <NSObject>

-(void) dismissSubjectPopover;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) donotrunviewdidappear;

@end

@interface SubjectPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverPresentationControllerDelegate,UITextViewDelegate,myInstructorImageGridViewControllerDelegate,UISearchBarDelegate,myCalendarViewDelegate,myPickerViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    //sqlite3 *isdb;
    
    UILabel *GeneralLabel;
    
    UILabel *Subject_ShortnameLabel;
    UILabel *Subject_EnglishnameLabel;
    UILabel *Subject_ChinesenameLabel;
    UILabel *Subject_CategoryLabel;
    UILabel *StudentCapacityLabel;
    UILabel *StandandPeriodLabel;
    UILabel *ValidityLabel;
    UILabel *ClassDurationLabel;
    UILabel *ClassDurationAssessmentLabel;
    UILabel *ClassDurationTrialLabel;
    UILabel *Tuition_MethodLabel;
    UILabel *Tuition_ModeLabel;
    UILabel *StatusLabel;
    UILabel *WeeklyScheduleAutoRenewalLabel;
    UILabel *NoOfLevelLabel;
    UILabel *LevelLabel;
    UILabel *RemarksLabel;
    
    UITextField *Subject_ShortnameText;
    UITextField *Subject_EnglishnameText;
    UITextField *Subject_ChinesenameText;
    
    UITextField *Subject_MakeupQuotaValueText;
    
    UITextView *RemarksText;
    
    UISegmentedControl *scStatus;
    UIButton *deleteButton;
    
    NSString *selectedItem;
    NSString *selectedValue;
    
    
    SubjectRecord *workingSubject;

    NSMutableArray *tmpgradearray;
    UISwitch *swWeeklyScheduleAutoRenewal;
    UITextField *ScheduleNameText;
    ScheduleRecord *workingSchedule;
    
    
    NSInteger presetRow;
    NSInteger minutePresetRow;
    NSInteger hourPresetRow;
    NSInteger dayPresentRow;
    int enrollmentmodepresetrow;
    int standardnoofclassormonthpresetrow;
    
    BOOL showTuitionMethodPicker;
    BOOL showTuitionModePicker;
    BOOL showStudentCapacityPicker;
    BOOL showTrialCapacityPicker;
    BOOL showStandardPeriodPicker;
    BOOL showClassDurationPicker;
    BOOL showClassDurationAssessmentPicker;
    BOOL showClassDurationTrialPicker;
    BOOL showGradeTuition;
    BOOL showDeleteButton;
    BOOL showCourseSchedule;
    BOOL showLevelTuitionTable;
    BOOL showGradeTuitionTable;
    BOOL showSubjectCategoryTable;
    BOOL showValidity;
    BOOL showmakeup_quotaPicker;
    BOOL showMakeupTable;
    BOOL showColorCode;
    BOOL showPregenPeriodPicker;
    

    
    BOOL keyboardshow;
    float keyboardheight;
    
    IBOutlet UIToolbar *SubjectToolBar;
    UIToolbar *CourseScheduleToolBar;
    UIToolbar *LevelTuitionTableToolBar;
    UIToolbar *GradeTuitionTableToolBar;
    UIToolbar *SubjectCategoryTableToolBar;
    UIToolbar *ValidityTableToolBar;
    UIToolbar *MakeupTableToolBar;
    UIToolbar *ColorCodeTableToolBar;
    
    NSMutableArray *JSONArray;
    NSMutableArray *pickerViewmenu;
    UIPickerView *myPickerView;
    
    NSMutableArray *standardnoofclassormontharray;
    NSArray *enrollmentmodearray;
    
    
    UITableView *SubjectPopoverTable;
    UITableView *CourseScheduleTable;
    __weak IBOutlet UITableView *LevelTuitionTable;
    __weak IBOutlet UITableView *GradeTuitionTable;
    UITableView *SubjectCategoryTable;
    UITableView *ValidityTable;
    UITableView *MakeupTable;
    UITableView *ColorCodeTable;
    
    UIPopoverPresentationController *myPopoverController;
    
    TuitionRecord *tuitionobject;
    
    BOOL subjectCanBeDeleted;
    
    NSString *CourseTableMode;
    
    NSMutableArray *InstructorArray;
    NSMutableArray *ClassroomArray;
    
    NSMutableArray *hourPickerViewMenu;
    NSMutableArray *minutePickerViewMenu;
    NSMutableArray *dayPickerViewMenu;
    NSMutableArray *validityTypePickerViewMenu;
    NSMutableArray *validtyValuePickerViewMenu;
    NSMutableArray *filteredScheduleArray;
    
    UIButton *selecteddaytimebutton;
    //NSMutableArray *DetailsScheduleArray;
    UILabel *noschedulerecordlabel;
    UILabel *addschedulerecordlabel;
    UILabel *addleveltuitionrecordlabel;
    long cseditindex;
    NSMutableArray *tmptestcstimearray;
    NSArray *makeupQuotaUnitArray;
    
    UIView *CourseScheduleMasterView;
    __weak IBOutlet UIView *LevelTuitionMasterView;
    __weak IBOutlet UIView *GradeTuitionMasterView;
    UIView *SubjectCategoryMasterView;
    UIView *ValidityTableMasterView;
    UIView *MakeupTableMasterView;
    UIView *ColorCodeTableMasterView;
    __weak IBOutlet UIView *AutoLevelUpgradeMasterView;
    
//    UILabel *LT_levellabel;
//    UILabel *LT_leveltuitionlabel;
//    UITextField *LT_leveltext;
//    UITextField *LT_leveltuitiontext;

//    UILabel *GT_gradelabel;
//    UILabel *GT_gradetuitionlabel;
//    UITextField *GT_gradetuitiontext;
    
    UISearchBar *subjectcategorysearchbar;
    
    NSMutableArray *filteredSubjectCategoryArray;
    NSMutableArray *allSubjectCategoryArray;
    UILabel *SC_CategoryNameLabel;
    UIImageView *SC_CategorySelectedImageView;
    UIButton *SC_MoreButton;
    
    UIViewController *addsubjectcategoryviewcontroller;
    
    UITextField *subjectcategorychinesenametext;
    UITextField *subjectcategoryenglishnametext;
    
    SubjectCategoryRecord *subjectcategoryobject;
    
    InstructorImageGridViewController *instructorimagepopover;
    
    
    UIView *csInstructorTableMasterView;
    UITableView *csInstructorTable;
    UIToolbar *csInstructorTableToolBar;
    BOOL showcsInstructorTable;
    UISearchBar *csinstructortablesearchbar;
    UIButton *csSelectInstructorButton;
    NSMutableArray *filteredcsInstructorArray;
    
    UIView *csClassroomTableMasterView;
    UITableView *csClassroomTable;
    UIToolbar *csClassroomTableToolBar;
    BOOL showcsClassroomTable;
    UISearchBar *csclassroomtablesearchbar;
//    UIButton *csSelectClassroomButton;
    NSMutableArray *filteredcsClassroomArray;
    
    UIView *csClassDateTableMasterView;
    UITableView *csClassDateTable;
    UIToolbar *csClassDateTableToolBar;
    BOOL showcsClassDateTable;
    UILabel *csClassDateHeaderLabel;

    UIView *csDayDateTimeTableMasterView;
    UITableView *csDayDateTimeTable;
    UIToolbar *csDayDateTimeTableToolBar;
    BOOL showcsDayDateTimeTable;
    UILabel *csDayDateTimeHeaderLabel;
    
    __weak IBOutlet UIView *ScheduleLevelMasterView;
    __weak IBOutlet UITableView *ScheduleLevelTable;
    BOOL showScheduleLevelTable;
    NSMutableArray *scheduleLevelArray;
    NSMutableArray *filteredScheduleLevelArray;
    UISearchBar *schedulelevelsearchbar;
    __weak IBOutlet UIView *scheduleLevelHeaderView;
    __weak IBOutlet UIButton *schedulelevelallbutton;
    __weak IBOutlet UIButton *schedulelevelnonebutton;
    
    
    
    __weak IBOutlet UIView *lessonNumberTableMasterView;
    __weak IBOutlet UITableView *lessonNumberTable;
    __weak IBOutlet UIToolbar *lessonNumberTableToolBar;
    __weak IBOutlet NSLayoutConstraint *lessonNumberTableBottomConstraint;
    BOOL showLessonNumberTable;
    NSString *lessonnumbertype;
    
    ScheduleDetailsRecord *workingScheduleDetails;
    UISearchBar *coursescheduletablesearchbar;
    
    SubjectCategoryRecord *workingCategory;
    UILabel *colorcodelabel;
    
    __weak IBOutlet UIView *chatBotSettingsMasterView;
    __weak IBOutlet UITableView *chatBotSettingsTable;
    __weak IBOutlet UIToolbar *chatBotSettingsTableToolBar;
    __weak IBOutlet NSLayoutConstraint *chatBotSettingsTableBottomConstraint;
    BOOL showChatBotSettingsTable;
    __weak IBOutlet NSLayoutConstraint *schedulelevelmasterviewbottomconstraint;
    
    __weak IBOutlet UITableView *autoLevelUpgradeOptionTable;
    __weak IBOutlet UITableView *autoLevelUpgradeValuesTable;
    __weak IBOutlet UIToolbar *autoLevelViewToolBar;
    BOOL showAutoLevelUpgradeOption;
    BOOL showAutoLevelUpgradeValues;
    UISwitch *bundleforapppaymentbutton;
    
    UIButton *addphotobutton;
    UIPopoverPresentationController *mypopovercontroller;
    UIImagePickerController *imagepicker;
    UIScrollView *fullscreen_scrollview;
    UIButton * fullscreen_closebutton;
    UIImageView *fullscreen_messageimageview;
    UIView *MessagePhotoMasterView;
    UIToolbar *MessagePhotoToolBar;
    
    BOOL showSubjectPhoto;
    BOOL showChatBotCategoryTable;
    

    BOOL photoimagechanged;
    PhotoCornerFileRecord *photocornerobject;
    
    __weak IBOutlet UITableView *levelEffectiveDateTable;
    TuitionRecord *selectedtuitionobject;
    LevelRecord *selectedlevelobject;
    BOOL showLevelEffectiveTable;
    __weak IBOutlet NSLayoutConstraint *leveltuitionmasterviewbottomcontrainst;
    
    __weak IBOutlet UITableView *gradeEffectiveDateTable;
    BOOL showGradeEffectiveTable;
    __weak IBOutlet NSLayoutConstraint *gradetuitionmasterviewbottomcontrainst;
    
    __weak IBOutlet NSLayoutConstraint *leveltablewidthconstraint;
    
    __weak IBOutlet UIButton *cloneButton;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
    
    UIButton *photocloseButton;
    UIButton *photorotateButton;
    UIButton *photoshareButton;
    
    
}

@property (nonatomic,strong) SubjectRecord *subjectobject;
@property (nonatomic,strong) NSString *SubjectTableMode;
@property (nonatomic,strong) NSMutableArray *SubjectRecordArray;
@property (nonatomic,weak)id<mySubjectPopoverViewControllerDelegate>delegate;
- (IBAction)closeeffectivedatebuttonpressed:(id)sender;
- (IBAction)schedulelevelallbuttonpressed:(id)sender;
- (IBAction)schedulelevelnonebuttonpressed:(id)sender;

-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) cloneButtonPressed:(id)sender;
-(IBAction) editButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
