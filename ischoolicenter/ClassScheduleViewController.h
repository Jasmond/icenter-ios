//
//  ClassScheduleViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 3/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "MakeupPopoverViewController.h"
#import "ClassRemarksPopoverViewController.h"
#import "StudentDetailsViewController.h"
#import <MessageUI/MessageUI.h>
#import "SwitchCenterViewController.h"
#import "DocumentFolderPopoverViewController.h"
#import "CalendarView.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanAttendanceView.h"
#import "MessagePopoverViewController.h"
#import "PickerViewController.h"

@interface ClassScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,myMakeupPopoverViewControllerDelegate,myClassRemarksPopoverViewControllerDelegate,UIPrintInteractionControllerDelegate,myStudentViewController,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate,mySwitchCenterViewControllerDelegate,myDocumentFolderPopoverViewController,UITextFieldDelegate,myCalendarViewDelegate,myScanAttendanceViewDelegate,myMessagePopoverViewControllerDelegate,UIPopoverPresentationControllerDelegate,myPickerViewControllerDelegate>
{
    MainViewController *mainviewcontroller;
    UILabel *StudentNameLabel;
    UILabel *ParentContactLabel;
    
    UILabel *ClassDurationLabel;
    UILabel *ClassLabel;
    UILabel *ClassTypeLabel;
    UILabel *LevelLabel;
    UILabel *ClassDayLabel;
    UILabel *ClassTimeLabel;
    UILabel *InstructorLabel;
    UILabel *ClassroomLabel;
    UILabel *MakeupDateTimeLabel;
    UILabel *RemarksLabel;
    UIButton *MakeupDateTimeButton;
    UILabel *MakeupInstructorLabel;
    UILabel *ScheduledClassLeftLabel;
    UILabel *UnScheduledClassLeftLabel;
    UILabel *UnScheduledMakeupLeftLabel;
    UIImageView *ScheduledClassLeftBackground;
    UIImageView *UnScheduledClassLeftBackground;
    UIImageView *UnScheduledMakeupLeftBackground;
    UIImageView *OutstandingExtendTimeBackground;
    //UIImageView *OutstandingPaymentBackground;
    UIImageView *ExtensionTimeBackground;
    UILabel *OutstandingExtendTimeLabel;
    UILabel *ExtendedMinuteLabel;
    UIImageView *studentimage;
    UIButton *AttendanceButton;
    UIButton *WarningButton;
    UIView *LeftBlock;
    UIImageView *AutoRenewImage;
    UIView *separatorline;
    UILabel *ExtensionTimeLabel;
    
    Student *studentobject;
    Lead *leadobject;
    
    
    //UILabel *OutstandingPaymentLabel;
    UIButton *OutstandingPaymentButton;
    //sqlite3 *isdb;
    
    //UILabel *headerTitle;
    UILabel *headerLabel;
    UIButton *sharebutton;
    UIButton *reloadbutton;
    
    __weak IBOutlet UIView *masterView;
    __weak IBOutlet UITableView *ClassScheduleTable;
    __weak IBOutlet UITableView *LessonTable;
    
    __weak IBOutlet UIView *classheaderview;
    __weak IBOutlet UIView *lessonheaderview;
    
    //UIActivityIndicatorView *ailoadclass;
    UIActivityIndicatorView *ailoadpdf;
    
    
    BOOL rotated;
    
    GlobalVariables *globalvariables;
    
    NSMutableArray *printViewArray;
    NSMutableArray *cellcolorarray;
    
    //UITableView *absentmakeupconfirmationtable;

    UIButton *menubutton;
    
    //UILabel *centertitle;
    
    UIButton *ClassSelectionButton;
    UIButton *ClassTypeSelectionButton;
    UIButton *InstructorSelectionButton;
    UIButton *ClassroomSelectionButton;
    UIButton *ExpandButton;
    UIButton *SelectViewButton;
    UIButton *SortingButton;
    
    UITableView *ClassSelectionTable;
    UITableView *ClassTypeSelectionTable;
    UITableView *InstructorSelectionTable;
    UITableView *ClassroomSelectionTable;
    
    NSMutableArray *subjectArray;
    NSMutableArray *SubjectSelectionArray;
    NSMutableArray *ClassTypeArray;
    NSMutableArray *ClassroomArray;
    NSMutableArray *ClassroomSelectionArray;
    
    CAShapeLayer *subjectpointer;
    CAShapeLayer *classtypepointer;
    CAShapeLayer *instructorpointer;
    CAShapeLayer *classroompointer;
    
    UIDocumentInteractionController * documentInteractionController;
    
    NSMutableArray * InstructorSelectionArray;
    NSString *lastselecteddate;
    
    //NSInteger lastinstructorindex;
    
    NSDateFormatter *df;
    
    //UIImage *boyimage;
    //UIImage *girlimage;
    
    //NSCache *imageCache;
    //NSString *studentimagelastupdatetime;
    //NSString *leadimagelastupdatetime;
    
    //NSInteger lastdeviceorientation;
    //BOOL instructoronlyview;
    NSMutableArray *LessonClassRecordArray;
    NSMutableArray *LessonExpandRowArray;
    NSString *viewmode;
    
    NSMutableArray *sortingarray;
    NSMutableArray *tmpsortingarray;
    
    UIView *attendanceringview;
    
    //NSString *highlightedlessonkey;
    
    //NSMutableArray *validateclassmessagearray;
    //NSMutableArray *validateclassstatusarray;
    NSMutableDictionary *validateclassarray;
    
    //BOOL deletevalidatemessagerow;
    
    UILabel *warningmessagelabel;
    UILabel *warningtitlelabel;
    FreeScheduleClass *freescheduleclassobject;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *regularattendancebuttonarray;
    NSMutableArray *makeupdtattendancebuttonarray;
    
    long lasttouchedsector;
    UIRefreshControl *tablerefresh;
    
    LessonRecord *LessonObject;
    

    UITableView *datebartable;
    UILabel *datebardatelabel;
    UILabel *datebardaylabel;
    UILabel *datebartodaylabel;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    
    UserPrivilege *userprivilege;
    
    UITableView *sortingtable;
    UILabel *sortingnamelabel;
    UIButton *sortingorderbutton;
    SortingRecord *sortingobject;
    
    __weak IBOutlet UIView *supermasterview;
    UIButton *supermasterviewbutton;
    UIButton *calendarbutton;
    //UIButton *todaybutton;
    
    //UITableView *CalendarTable;
    //NSArray *dayofweekArray;
    
    //UILabel *dayofweeklabel;
    //UIButton *daybutton;
    
    UIButton *editattendancebutton;
    
    __weak IBOutlet UIView *editattendanceview;
    __weak IBOutlet UIButton *canceleditattendancebutton;
    __weak IBOutlet UILabel *attendancecountlabel;
    
    BOOL editattendanceviewopened;
    UIImageView *editattendancestatusimageview;
    NSMutableArray *selectededitattendanceclasskeyarray;
    UITableView *AttendanceTable;
    NSMutableArray *attendancearray;
    UILabel *attendancetablelabel;
    UIImageView *attendancetableimageview;
    
    UIView *attendanceiconview;
    
    DocumentFolderPopoverViewController *documentfolderpopover;
    UILongPressGestureRecognizer *clpgr;
    
    //NSMutableArray * defaultcheckedsalespaymentsaleskeys;
    //NSMutableArray * defaultcheckedclasspaymentenrollmentkeys;
    //NSMutableArray * defaultcheckedclassinvoiceenrollmentkeys;
    //NSMutableArray * defaultcheckedsalesinvoicesaleskeys;
    //NSMutableArray * defaultcheckedclassreceiptpaymentkeys;
    //NSMutableArray * defaultcheckedsalesreceiptpaymentkeys;
    
    UIButton *documentfolderbutton;
    UILabel *documentfoldercountlabel;
    UITextField *search_text;
    NSMutableArray *filteredClassScheduleRecordArray;
    UIButton *scantotakeattendancebutton;
    UIViewController *scantotakeattendanceviewcontroller;
    
    //UITextField *scan_studentkeytext;
    //UILabel *scan_studentnamelabel;
    //UILabel *scan_studentidlabel;
    //UILabel *scan_subjectlabel;
    //UILabel *scan_classtimelabel;
    //UILabel *scan_outstandinglabel;
    //UIImageView *scan_statusimage;
    //UIImageView *scan_loadingimage;
    
    BOOL scannerconnected;
    //UILabel *scan_actionlabel;
    //UIButton *scan_retrybutton;
    //UIButton *scan_cancelbutton;
    //UIButton *scan_closebutton;
    //UIImageView *scan_actionimage;
    //UILabel *scan_warninglabel;
    NSMutableArray *scanhistoryarray;
    UITableView *scanhistorytable;
    
    BOOL openforscan;
    
    BOOL firstopenscanwindow;
    BOOL showscanhistory;
    
    NSString *imagelastupdatetime;
    UIButton *scanhistorybutton;
    UILabel *scanhistorynorecordlabel;
    //NSMutableArray *classdayarray;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    CalendarView *calendarview;
    
    UIButton *warningbuttonselected;
    NSString *resetattendance;
    NSDate *laststudentimagelastupdatetimecheck;
    
    __weak IBOutlet UIView *title_Class_Select;
    __weak IBOutlet UILabel *title_Class_Time;
    __weak IBOutlet UILabel *title_Class_Duration;
    __weak IBOutlet UILabel *title_Class_Type;
    __weak IBOutlet UILabel *title_Class_Level;
    __weak IBOutlet UILabel *title_Class_Student;
    __weak IBOutlet UILabel *title_Class_Subject;
    __weak IBOutlet UILabel *title_Class_Instructor;
    __weak IBOutlet UILabel *title_Class_Room;
    __weak IBOutlet UILabel *title_Class_Contact;
    __weak IBOutlet UILabel *title_Class_Remarks;
    __weak IBOutlet UILabel *title_Class_Attendance;
    __weak IBOutlet UILabel *title_Class_OutstandingClass;
    __weak IBOutlet UILabel *title_Class_OutstandingAmount;
    
    __weak IBOutlet UILabel *title_Lesson;
    
    NSString *selectedAttendanceStatus;
    
    ClassValidateMessage *classvalidatemessage;
    ClassValidateStatus *classvalidatestatus;
    
    __weak IBOutlet NSLayoutConstraint *masterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *masterviewtrailingconstraint;
    
    __weak IBOutlet NSLayoutConstraint *classViewLeadingConstraint;
    NSString *selectedLessonKey;
    
    //AVAudioPlayer *passedBeep;
    //AVAudioPlayer *failedBeep;
    AVAudioPlayer *beepPlayer;
    
    __weak IBOutlet UIButton *attendanceUnknownButton;
    __weak IBOutlet UIButton *attendancePresentButton;
    __weak IBOutlet UIButton *attendanceAbsentButton;
    __weak IBOutlet UIButton *attendanceMakeupButton;
    __weak IBOutlet UIButton *attendanceExtendButton;
    __weak IBOutlet UIImageView *selectallicon;
    __weak IBOutlet UIButton *selectallbutton;
    __weak IBOutlet UIImageView *deselectallicon;
    __weak IBOutlet UIButton *deselectallbutton;
    
    UIView *scanmasterview;
    ScanAttendanceView *scantotakeattendanceview;
    
    //UIButton *lessonactionsbutton;
    
    //UITableView *lessonactionsmenutable;
    NSMutableArray *allstudentarray;
    NSMutableArray *allleadarray;
    NSMutableArray *allstaffarray;
    __weak IBOutlet UIButton *sendParentNoteButton;
    __weak IBOutlet UIButton *sendMessageButton;
    __weak IBOutlet UIButton *actionsButton;
    
    //DocumentFolder *quickPayDocumentfolder;
    //NSMutableArray *documentfolderclassinvoicearray;
    NSMutableArray *documentfolderclassreceiptarray;
    //NSMutableArray *documentfoldersalesinvoicearray;
    NSMutableArray *documentfoldersalesreceiptarray;
    //NSMutableArray *documentfolderclasspaymentarray;
    //NSMutableArray *documentfoldersalespaymentarray;
    BOOL groupsubjectcategory;
    __weak IBOutlet UISwitch *swgroupsubjectcategory;
    __weak IBOutlet UILabel *title_groupsubjectcategory;
    
//    BOOL dailyscheduleshowclassroomcolor;
    BOOL dailyscheduleshowsubjectcolor;
    BOOL dailyscheduleshowinstructorcolor;
    
    FreeScheduleClass* return_freescheduleclass;
    BOOL return_updatefollowinglessons;
    NSMutableArray *return_updatefollowinglessonsfields;
}

@property (nonatomic, strong) NSString *subjectselected;
@property (nonatomic, strong) NSString *classtypeselected;
@property (nonatomic, strong) NSString *instructorselected;
@property (nonatomic, strong) NSString *classroomselected;
@property (nonatomic, strong) NSMutableArray * JSONArray;
@property (nonatomic, strong) ClassScheduleRecord *ClassScheduleObject;
@property (nonatomic, strong) NSMutableArray * ClassScheduleRecordArray;
@property (nonatomic, strong) NSMutableArray * InstructorArray;
@property (nonatomic, strong) Instructor *InstructorObject;
//@property (strong, nonatomic) UITableView *ClassScheduleTable;
//@property (strong, nonatomic) UIScrollView *datescrollbar;
//@property (strong,nonatomic) NSMutableArray *schoolDateArray;
@property (strong,nonatomic) UIPopoverPresentationController *mypopovercontroller;
//@property (strong,nonatomic) UIPopoverPresentationController *myStudentPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myDTPopoverController;
@property (strong,nonatomic) NSString *selecteddate;
@property (strong,nonatomic) UIPopoverPresentationController *myClassSelectionPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myClassTypeSelectionPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myInstructorSelectionPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myClassroomSelectionPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myWarningMessagePopoverController;
@property (strong, nonatomic) IBOutlet UIView *portraitview;

- (IBAction)attendanceUnknownButtonPressed:(id)sender;
- (IBAction)attendancePresentButtonPressed:(id)sender;
- (IBAction)attendanceMakeupButtonPressed:(id)sender;
- (IBAction)attendanceAbsentButtonPressed:(id)sender;
- (IBAction)attendanceExtendButtonPressed:(id)sender;
- (IBAction)sendParentNoteButtonPressed:(id)sender;
- (IBAction)sendMessageButtonPressed:(id)sender;
- (IBAction)selectallbuttonpressed:(id)sender;
- (IBAction)deselectallbuttonpressed:(id)sender;
- (IBAction)actionsButtonPressed:(id)sender;


-(BOOL) retrieveClassScheduleWithclassdate:(NSString *)classdate;
-(void) closesidewindow;
-(void) validationPassed:(BOOL)pass;
- (IBAction)updategroupsubjectcategory:(id)sender;




@end
