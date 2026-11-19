//
//  DTAddEditViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/11/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
//#import "ClassTimeTableViewController.h"
#import "ClassScheduleViewController.h"
#import "InstructorImageGridViewController.h"
#import "CalendarView.h"

@protocol myDTAddEditViewControllerDelegate <NSObject>
@required
//-(void) dismissDTAddEditpopover;
-(void) dismissDTAddEditpopoverduetoconnectionerror;
//-(void) enrollDTStudent:(DTRecord *)AddEditDTObject;
-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord;
-(void) dismissDTAddEditpopoverwithdttype:(NSString *)type;
-(void) dismissDTAddEditpopoverwithrefresh:(BOOL)refresh;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface DTAddEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverPresentationControllerDelegate,UITextViewDelegate,myInstructorImageGridViewControllerDelegate,UIGestureRecognizerDelegate,myCalendarViewDelegate,UISearchBarDelegate>{
    //sqlite3 *isdb;
    
    UIStoryboard *mainStoryboard;

    UILabel *GeneralLabel;
    UILabel *StudentNameLabel;
    UISegmentedControl *scGender;
    UILabel *GradeLabel;
    UILabel *ClassLabel;
    UILabel *StartDateTimeLabel;
    UILabel *ClassDurationLabel;
    UILabel *InstructorLabel;
    UILabel *ClassroomLabel;
    UILabel *LevelLabel;
    UILabel *AttendanceLabel;
    
    UILabel *ParentNameLabel;
    UILabel *ParentContactLabel;
    UILabel *ParentEmailLabel;
    UILabel *PreferredLanguageLabel;
    
    UILabel *MediaLabel;
    UILabel *SourceLabel;
    
    UILabel *RemarksLabel;
    
    UITextField *SchoolText;
    UITextField *FirstNameText;
    UITextField *LastNameText;
    UITextField *OtherNameText;
    UISegmentedControl *scClassType;
    UISegmentedControl *scSubject;
    UITextField *ParentNameText;
    UITextField *ParentEmailText;
    UITextField *ParentContactText;

    UITextView *RemarksText;
    UIButton *DeleteRecordBtn;
    
    NSString *selectedItem;
    NSString *selectedValue;
    
    long presetRow;
    long datePresetRow;
    long minutePresetRow;
    long hourPresetRow;
    
    //BOOL showGradePicker;
    //BOOL showClassPicker;
    BOOL showDatePicker;
    //BOOL showClassDurationPicker;
    //BOOL showInstructorPicker;
    //BOOL showLevelPicker;
    //BOOL showPreferedLanguagePicker;
    //BOOL showClassroomPicker;
    //BOOL showMediaPicker;
    //BOOL showSourcePicker;
    
    AssessmentTrialRecord *workingATObject;
    
    /*NSString *tmpFirstName;
    NSString *tmpLastName;
    NSString *tmpOtherName;
    NSString *tmpGrade;
    NSString *tmpSchool;
    NSString *tmpGender;
    NSString *tmpClassType;
    NSString *tmpSubject;
    NSString *tmpStartDateTime;
    NSString *tmpClassDuration;
    NSString *tmpInstructor;
    NSString *tmpLevel;
    NSString *tmpClassroom;
    NSString *tmpAttendance;
    
    NSString *tmpParentName;
    NSString *tmpParentContact;
    NSString *tmpParentEmail;
    NSString *tmpPreferredLanguage;
    NSString *tmpMedia;
    NSString *tmpSource;
    
    NSString *tmpRemarks;*/
    NSString *tmpLevel;
    
    GlobalVariables *globalvariables;
    
    BOOL keyboardshow;
    float keyboardheight;
    
    BOOL dismisspopoverduetoconnectionerror;
    
    NSMutableArray *ClassroomArray;
    NSMutableArray *MediaArray;
    NSMutableArray *SourceArray;
    
    NSDateFormatter *df;
    
    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *makeupdtattendancebuttonarray;
    long lasttouchedsector;
    
    InstructorImageGridViewController *instructorimagepopover;
    
    UIView *SubjectTableMasterView;
    UITableView *SubjectTable;
    UIToolbar *SubjectTableToolBar;
    BOOL showSubjectTable;
    UILabel *STSubjectname;
    UILabel *STSubjectcode;
    UIImageView *STSubjectselected;
    UISearchBar *subjectsearchbar;
    
    UIView *InstructorTableMasterView;
    UITableView *InstructorTable;
    UIToolbar *InstructorTableToolBar;
    BOOL showInstructorTable;
    UILabel *ITInstructorname;
    UIImageView *ITInstructorselected;
    UISearchBar *instructorsearchbar;
    
    UIView *ClassroomTableMasterView;
    UITableView *ClassroomTable;
    UIToolbar *ClassroomTableToolBar;
    BOOL showClassroomTable;
    
    UIView *GradeTableMasterView;
    UITableView *GradeTable;
    UIToolbar *GradeTableToolBar;
    BOOL showGradeTable;
    
    UIView *LevelTableMasterView;
    UITableView *LevelTable;
    UIToolbar *LevelTableToolBar;
    BOOL showLevelTable;

    UIView *DurationTableMasterView;
    UITableView *DurationTable;
    UIToolbar *DurationTableToolBar;
    BOOL showDurationTable;
    
    UIView *LanguageTableMasterView;
    UITableView *LanguageTable;
    UIToolbar *LanguageTableToolBar;
    BOOL showLanguageTable;
    
    UIView *MediaTableMasterView;
    UITableView *MediaTable;
    UIToolbar *MediaTableToolBar;
    BOOL showMediaTable;
    
    UIView *SourceTableMasterView;
    UITableView *SourceTable;
    UIToolbar *SourceTableToolBar;
    BOOL showSourceTable;
    
    UIView *SchoolTableMasterView;
    UITableView *SchoolTable;
    UIToolbar *SchoolTableToolBar;
    BOOL showSchoolTable;
    UISearchBar *schoolsearchbar;
    
    
    NSMutableArray *filteredSubjectArray;
    NSMutableArray *filteredInstructorArray;
    NSMutableArray *levelArray;
    NSMutableArray *gradeArray;
    NSMutableArray *durationArray;
    NSMutableArray *languageArray;
    NSMutableArray *filteredSchoolArray;
    NSMutableArray *SchoolArray;
    
    ClassValidateStatus *classvalidatestatus;
    ClassValidateMessage *classvalidatemessage;
    __weak IBOutlet UIButton *enrollButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIButton *addanotherButton;
    __weak IBOutlet UIButton *addanotherdoneButton;
    __weak IBOutlet UIButton *editdoneButton;
    
}

@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (weak, nonatomic) IBOutlet UIToolbar *DTAddEditToolbar;
@property (strong,nonatomic) NSString *DTAddEditViewAction;
@property (strong,nonatomic) NSString *DTAddEditViewDTkey;
@property (strong,nonatomic) NSMutableArray *JSONArray;
@property (weak,nonatomic) id<myDTAddEditViewControllerDelegate>delegate;

//@property (strong,nonatomic) DTRecord *ViewDTObject;
@property (strong,nonatomic) AssessmentTrialRecord *ViewATObject;
@property (strong,nonatomic) ClassTimeTableViewController *classtimetableviewcontroller;
@property (strong,nonatomic) ClassScheduleViewController *classscheduleviewcontroller;

@property (strong, nonatomic) UIScrollView *masterView;


@property (strong,nonatomic) UITableView *DTPopoverTable;
@property (strong,nonatomic) NSString *DTTableMode;
@property (strong,nonatomic) NSString *PopoverMode;


@property (strong, nonatomic) NSMutableArray *InstructorArray;
@property (nonatomic,retain) NSMutableArray *pickerViewmenu;
//@property (nonatomic,retain) NSMutableArray *datePickerViewMenu;
@property (nonatomic,retain) NSMutableArray *hourPickerViewMenu;
@property (nonatomic,retain) NSMutableArray *minutePickerViewMenu;
@property (nonatomic,retain) NSMutableArray *levelmainPickerViewMenu;
@property (nonatomic,retain) NSMutableArray *levelctmPickerViewMenu;
@property (nonatomic,strong) UIPickerView *myPickerView;
@property (nonatomic,strong) NSString *CallingSource;
@property (nonatomic,strong) NSString *CallingKey;

-(BOOL) retrieveDTRecordWithDTkey:(NSString *)dtkey;
-(void) validationPassed:(BOOL)pass;

-(IBAction)adddoneButtonPressed:(id)sender;
-(IBAction)enrollButtonPressed:(id)sender;
-(IBAction) addanotherButtonPressed:(id)sender;
-(IBAction) editButtonPressed:(id)sender;
-(IBAction)editdoneButtonPressed:(id)sender;
-(IBAction)addanotherdoneButtonPressed:(id)sender;

@end
