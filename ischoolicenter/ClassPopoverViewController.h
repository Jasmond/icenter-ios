//
//  ClassPopoverViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/1/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
//#import "ClassPopoverViewTableViewController.h"
//#import "ClassPopoverEditTableViewController.h"
#import "ClassTimeTableViewController.h"
#import "sqlite3.h"
#import "InstructorImageGridViewController.h"
#import "CalendarView.h"

@protocol myClassPopoverVCDelegate <NSObject>

-(void) dismissClassPopoverVC;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(BOOL) isDifferentLevelWithLaterEnrollmentWithStartDate:(NSString *)startdate classkey:(NSString *)classkey subject:(NSString *)subject levelmain:(NSString *)levelmain levelctm:(NSString *)levelctm;

@end

@interface ClassPopoverViewController : UIViewController<UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,myClassTimeTableViewControllerDelegate,myInstructorImageGridViewControllerDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,myCalendarViewDelegate,AVAudioPlayerDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    //sqlite3 *isdb;
    
    UILabel *GeneralLabel;
    UILabel *ClassLabel;
    UILabel *LevelLabel;
    UILabel *StartDateTimeLabel;
    UILabel *ClassDayLabel;
    UILabel *InstructorLabel;
    UILabel *ClassroomLabel;
    UILabel *ClassRemarksLabel;
    UILabel *AllClassRemarksLabel;
    UILabel *ParentNoteLabel;
    UILabel *AbsentLabel;
    UILabel *MakeupLabel;
    UILabel *MakeupDateTimeLabel;
    UILabel *MakeupInstructorLabel;
    UILabel *MakeupClassroomLabel;
    UILabel *absentMakeupReasonLabel;
    
    UITextView *ClassRemarksText;
    UITextView *AllClassRemarksText;
    UITextView *absentMakeupReasonText;
    UITextView *ParentNoteText;
    //UISwitch *swabsent;
    //UISwitch *swMakeup;

    NSString *selectedItem;
    NSString *selectedValue;
    
    ClassRecord *workingClass;
    NSString *tmpLevel;
    long presetRow;
    long datePresetRow;
    long minutePresetRow;
    long hourPresetRow;
    
    BOOL showLevelPicker;
    BOOL showDatePicker;
    BOOL showMakeupSection;
    BOOL showMakeupDateTimePicker;
    BOOL showMakeupRemarks;
    float keyboardheight;
    
    NSMutableArray *subjectArray;
    NSMutableArray *AvailableClassroomArray;
    NSMutableArray *FilteredClassroomArray;
    
    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *regularattendancebuttonarray;
    NSMutableArray *makeupattendancebuttonarray;
    long lasttouchedsector;
    
    UIView *InstructorTableMasterView;
    UITableView *InstructorTable;
    UIToolbar *InstructorTableToolBar;
    BOOL showInstructorTable;
    UILabel *ITInstructorname;
    UIImageView *ITInstructorselected;
    UISearchBar *instructorsearchbar;
    
    NSMutableArray *AllInstructorArray;
    NSMutableArray *ActiveInstructorArray;
    NSMutableArray *filteredActiveInstructorArray;
    
    NSString *classhasextendedclass;
    
    InstructorImageGridViewController *instructorimagepopover;
    
    ClassValidateMessage *classvalidatemessage;
    ClassValidateStatus *classvalidatestatus;
    
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
    
    __weak IBOutlet UIView *LessonNumberTableMasterView;
    __weak IBOutlet UITableView *LessonNumberTable;
    __weak IBOutlet UIToolbar *LessonNumberTableToolBar;
    BOOL showLessonNumberTable;
    NSArray *lessonArray;
    
    
    
    FreeScheduleClass *FreeScheduleClassObject;
    
    __weak IBOutlet UITableView *ClassPopoverTable;
    __weak IBOutlet NSLayoutConstraint *classtablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *lessonnumbertablebottomconstraint;
    
    UIView *recordingStatusView;
    UILabel *recordingDuration;
    UIPanGestureRecognizer *audioPanGesture;
    UIImpactFeedbackGenerator *impactFeedbackGenerator;
    AVAudioPlayer *audioPlayer;
    NSTimer *sliderTimer;
    UISlider *selectedUIslide;
    
    AVAudioRecorder *audioRecorder;
    NSTimer *audioRecorderTimer;
    
    UIImageView *audioRecordingImage;
    UILabel *slideToCancelTitle;
    UIView *textinputbox;
    
    UILabel *instructortablelabel;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *editButton;
    
}

//@property (strong, nonatomic) UIScrollView *masterView;
@property (weak, nonatomic) IBOutlet UIToolbar *ClassToolBar;
@property (nonatomic,strong) ClassRecord *PopoverClass;
@property (nonatomic,strong) NSMutableArray *ClassRecordArray;
//@property (strong,nonatomic) UITableView *ClassPopoverTable;
@property (strong,nonatomic) NSString *ClassTableMode;


@property (strong, nonatomic) NSMutableArray *JSONArray;
//@property (strong, nonatomic) NSMutableArray *InstructorArray;
//@property (strong, nonatomic) NSMutableArray *InstructorNameArray;
@property (nonatomic,retain) NSMutableArray *pickerViewmenu;
//@property (nonatomic,retain) NSMutableArray *datePickerViewMenu;
@property (nonatomic,retain) NSMutableArray *hourPickerViewMenu;
@property (nonatomic,retain) NSMutableArray *minutePickerViewMenu;
@property (nonatomic,retain) NSMutableArray *levelmainPickerViewMenu;
@property (nonatomic,retain) NSMutableArray *levelctmPickerViewMenu;
@property (nonatomic,strong) UIPickerView *myPickerView;
@property (nonatomic, strong) UIPopoverPresentationController *myPopoverController;

@property (nonatomic, strong) NSMutableArray *FreeScheduleClassArray;
//@property (nonatomic, strong) FreeScheduleClass *FreeScheduleClassObject;

@property (nonatomic,weak)id<myClassPopoverVCDelegate>delegate;
-(void) validationPassed:(BOOL)pass;
-(void) createViewBarButton;
-(void) createEditBarButton;

-(IBAction) editButtonPressed:(id)sender;
-(IBAction) cancelButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
