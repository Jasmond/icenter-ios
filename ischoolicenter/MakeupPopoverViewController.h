//
//  MakeupPopoverViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "ClassTimeTableViewController.h"
#import "InstructorImageGridViewController.h"
#import "sqlite3.h"
#import "CalendarView.h"
#import "GCPlaceholderTextView.h"

@protocol myMakeupPopoverViewControllerDelegate <NSObject>

-(void) dismisspopover;
-(void) dismissmakeuppopoverduetoconnectionerror;
-(void) passfreeclassscheduleforlessonmove:(FreeScheduleClass *)freescheduleclass updatefollowinglessons:(BOOL)updatefollowinglessons updatefollowinglessonsfields:(NSMutableArray *)updatefollowinglessonsfields;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) deleteClassesFromMakeupWindowWithClassrecords:(NSMutableArray *)classrecords;
-(void) postponeClassesFromMakeupWindowWithClassrecords:(NSMutableArray *)classrecords;

@end

@interface MakeupPopoverViewController : UIViewController<myClassTimeTableViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,myInstructorImageGridViewControllerDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,myCalendarViewDelegate>{
    
    //sqlite3 *isdb;
    
    UILabel *GeneralLabel;
    UILabel *MakeupDateTimeLabel;
    UILabel *MakeupInstructorLabel;
    UILabel *MakeupSInstructorLabel;
    UILabel *MakeupClassroomLabel;
    GCPlaceholderTextView *absentMakeupReasonText;
    
    ClassScheduleRecord *workingClass;

    NSString *tmpDefaultMakeupDateTime;
    NSString *tmpDefaultMakeupInstructor;
    NSString *tmpDefaultMakeupSInstructor;
    NSString *tmpDefaultMakeupClassroom;
    
    BOOL showMakeupDatePicker;

    long presetRow;
    long datePresetRow;
    long minutePresetRow;
    long hourPresetRow;
    
    NSString *selectedItem;
    
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    NSString *overenrollmentmessage;
    NSString *sameinstructormulticlassmessage;
    NSString *alreadyenrolledmessage;

    NSMutableArray *allClassroomArray;
    NSMutableArray *filteredClassroomArray;
    
    NSDateFormatter *df;

    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *makeupdtattendancebuttonarray;
    long lasttouchedsector;

    
    UIView *InstructorTableMasterView;
    UITableView *InstructorTable;
    UIToolbar *InstructorTableToolBar;
    BOOL showInstructorTable;
    UILabel *ITInstructorname;
    UIImageView *ITInstructorselected;
    UISearchBar *instructorsearchbar;
    
    UIView *SInstructorTableMasterView;
    UITableView *SInstructorTable;
    UIToolbar *SInstructorTableToolBar;
    BOOL showSInstructorTable;
    UILabel *ITSInstructorname;
    UIImageView *ITSInstructorselected;
    UISearchBar *sinstructorsearchbar;
    
    NSMutableArray *AllInstructorArray;
    NSMutableArray *ActiveInstructorArray;
    NSMutableArray *filteredActiveInstructorArray;
    
    float keyboardheight;
    InstructorImageGridViewController *instructorimagepopover;
    
    ClassValidateStatus *classvalidatestatus;
    ClassValidateMessage *classvalidatemessage;
    
    UIView *ClassroomTableMasterView;
    UITableView *ClassroomTable;
    UIToolbar *ClassroomTableToolBar;
    BOOL showClassroomTable;
    UISearchBar *classroomsearchbar;

    UIView *NatureTableMasterView;
    UITableView *NatureTable;
    UIToolbar *NatureTableToolBar;
    BOOL showNatureTable;
    NSArray *leaveNatureArray;
    NSMutableDictionary *availablemakeuptimeslots;
    UISegmentedControl *scCalendarType;
    NSInteger selectedCalendarType;
    NSArray *makeuptimearray;
    UIView *ailoadview;
    UIActivityIndicatorView *ailoadindicator;
//    UIBarButtonItem *doneButton;
    
    LessonRecord *PopoverLessonRecord;
    
    __weak IBOutlet UIView *LessonNumberTableMasterView;
    __weak IBOutlet UITableView *LessonNumberTable;
    __weak IBOutlet UIToolbar *LessonNumberTableToolBar;
    BOOL showLessonNumberTable;
    NSArray *lessonArray;
    __weak IBOutlet NSLayoutConstraint *lessonnumbertablebottomconstraint;
    __weak IBOutlet UITableView *MakeupTable;
    
    __weak IBOutlet UIView *UpdateFollowingLessonsFieldsTableMasterView;
    __weak IBOutlet UITableView *UpdateFollowingLessonsFieldsTable;
    __weak IBOutlet UIToolbar *UpdateFollowingLessonsFieldsTableToolBar;
    __weak IBOutlet UILabel *optionsLabel;
    BOOL showUpdateFollowingLessonsFieldsTable;
    BOOL updatefollowinglessons;
    NSMutableArray *updatefollowinglessonsfieldsarray;
    NSMutableArray *updatefollowinglessonsfieldsoptions;
    __weak IBOutlet UIButton *resetButton;
    __weak IBOutlet UIButton *postponeButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *deleteButton;
}

@property (weak, nonatomic) IBOutlet UIToolbar *MakeupToolBar;
@property (nonatomic,strong) ClassScheduleRecord *PopoverClassRecord;
@property (nonatomic,strong) ClassRecord *PopoverDetailsClassRecord;
@property (strong,nonatomic) NSString  *PopoverOption;
@property (nonatomic,weak)id<myMakeupPopoverViewControllerDelegate>delegate;

@property (nonatomic,strong) UIView *MasterView;
//@property (nonatomic,strong) UIScrollView *ScrollView;
//@property (nonatomic,strong) UITableView *MakeupTable;

@property (strong, nonatomic) NSMutableArray *JSONArray;
//@property (strong, nonatomic) NSMutableArray *AllInstructorArray;
@property (nonatomic,retain) NSMutableArray *pickerViewmenu;
//@property (nonatomic,retain) NSMutableArray *datePickerViewMenu;
@property (nonatomic,retain) NSMutableArray *hourPickerViewMenu;
@property (nonatomic,retain) NSMutableArray *minutePickerViewMenu;
@property (nonatomic,strong) UIPickerView *myPickerView;

@property (nonatomic,strong) NSMutableArray *FreeScheduleClassArray;
@property (nonatomic,strong) FreeScheduleClass *FreeScheduleClassObject;
//@property (nonatomic,strong) NSString *Mode;
//@property (nonatomic,strong) LessonRecord *PopoverLessonRecord;
@property (nonatomic,strong) LessonAndClassRecord *PopoverLessonAndClassRecord;
-(void) validationPassed:(BOOL)pass;

-(IBAction)resetButtonPressed:(id)sender;
-(IBAction)postponeButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;

@end
