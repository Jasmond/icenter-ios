//
//  ClassTimeTableViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/9/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "FSSegmentedControl.h"
#import "InstructorImageGridViewController.h"
#import "SwitchCenterViewController.h"
#import "CalendarView.h"
#import "ClassTimeTableCollectionVFL.h"
//#import "StudentDetailsViewController.h"
#import "TimeTableTabViewController.h"
#import "detailsLessonItem.h"
#import "ClassTimeTableDetailsPopoverViewController.h"
#import "TimeTableFilterViewController.h"
#import "MainViewController.h"

@protocol myClassTimeTableViewControllerDelegate <NSObject>
@required
-(void) cancelselection;
-(void) passTimeTableInformationwithstartdate:(NSString *)startdate classtime:(NSString *)classtime instructor:(NSString *)instructor classroom:(NSString *)classroom;
-(void) passFreeSscheduleInformationwithArray:(NSMutableArray *)freescheduleclassarray;
-(void) addStudentAndSubject:(ClassScheduleRecord *)classschedulerecord;

@end

@interface ClassTimeTableViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,UIDocumentInteractionControllerDelegate,myInstructorImageGridViewControllerDelegate,mySwitchCenterViewControllerDelegate,myCalendarViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,myTimeTableTabViewControllerDelegate,UIPickerViewDelegate,myDetailsLessonItemDelegate,UIPickerViewDataSource,myClassTimeTableDetailsPopoverViewController,myTimeTableFilterViewControllerDelegate,myPickerViewControllerDelegate>{
    //sqlite3 *isdb;
    MainViewController *mainviewcontroller;
    UILabel *instructorLabel;
    UILabel *classroomLabel;
    UILabel *cellLabel;
    UIButton *cellButton;
    
    
    UILabel *ClassTypeLabel;
    UILabel *StartTimeLabel;
    UILabel *StudentNameLabel;
    UILabel *LevelLabel;
    UILabel *AgeLabel;
    UILabel *InstructorLabel;
    UILabel *ClassroomLabel;
    
    UILabel *NextClassAllDayTimeLabel;
//    UILabel *NextClassThisDayTimeLabel;
    UILabel *LastScheduledClassAllDayTimeLabel;
//    UILabel *LastScheduledClassThisDayTimeLabel;
    UILabel *ClassDurationLabel;
    UIImageView *ClassAttendanceImage;
    
    UILabel *RemainingScheduledClassLabel;
    UILabel *RemainingTBDClassLabel;
    UILabel *RemainingTBDMakeupLabel;
    UILabel *OutstandingPaymentLabel;
    
    UILabel *FreeScheduleDateLabel;
    UILabel *FreeScheduleDayLabel;
    UILabel *FreeScheduleClassTimeLabel;
    UILabel *FreeScheduleInstructorLabel;
    UIButton *FreeScheduleInstructorImageButton;
    
    
    UITextField *CaptionText;
    UITextView *RemarksText;
    UISwitch *swBlock;
    UITextField *specialremarks;
    
    float mCurrentScale;
    float mLastScale;
    float userOffset;
    
    NSString *selectedstartdate;
    NSString *selectedclasstime;
    NSString *selectedclassday;
    NSString *selectedinstructor;
    NSString *selectedclassroom;
    NSString *selectedsubject;
    
    NSString *selecteddateinreadformat;
    
    UIButton *selectedbutton;
    int currentscscheduleindex;
    
    UIBarButtonItem *freescheduledonebutton;
    UIBarButtonItem *freescheduleclearallbutton;
    
    int selectedfreeclassrow;
    
    int presetRow;
    
    CAShapeLayer *shapeLayer;
    NSString *lastexpandcellposition;
    
    GlobalVariables *globalvariables;
    
    CGFloat targetIndex;
    
    //UIActivityIndicatorView *aiclasstimetable;
    
    IBOutlet UILabel *HeaderBar;
    
    float cellwidth;
    float cellheight;
    long totalSubjectColumn;
    float cellduration;
    float mincellwidthfordetailview;
    NSInteger zoommode;
    
    NSMutableArray *headerArray;
    //NSMutableArray *classroomArray;
    
    
    UIView *superview;
    UILabel *emptytabmessagelabel;
    
    UITableView *ClassSelectionTable;
    
    
    UIButton *TabViewButton;
    UIButton *TabAddButton;
    UIButton *TabSubjectSelectionButton;
    UIButton *TabDeleteButton;
    UILabel *TabTitle;
    
    __weak IBOutlet UIButton *ClassTypeSelectionButton;
    //UIButton *ClassTypeSelectionButton;
    UITableView *ClassTypeSelectionTable;
    
    
    NSMutableArray *selectedHeaderArray;
    NSMutableArray *filteredHeaderArray;
    
    //NSMutableArray *TabIDArray;
    NSMutableArray *TabArray;
    
    NSMutableArray *ClassTypeArray;
    CAShapeLayer *classtypepointer;
    
    UIButton *selectedtabbutton;
    
    //UIButton *zoombutton;
    //UIButton *filterbutton;
    //UIButton *viewoptionbutton;
    __weak IBOutlet UIButton *filterbutton;
    __weak IBOutlet UIButton *viewoptionbutton;
    __weak IBOutlet UISearchBar *searchbar;
    
    CAShapeLayer *addicon;
    CAShapeLayer *deleteicon;
    
    UIView *TimeTableView;
    
    UILabel *datelabel;
    UILabel *daylabel;


    NSMutableArray *classtimetableobjectArray;
    NSMutableArray *filteredclasstimetableobjectArray;

    
    float NoOfTimeSlot;
    
    UIView * masterView;
    
    NSMutableArray *lasttabsubjectarray;
    
    UIButton *reloadbutton;
    
    UILabel *systemmessagelabel;
    
    BOOL nointernet;
    
    UIButton *lastselecttabbutton;
    
    //NSString *dailyweeklyviewselected;
    UILabel *todaylabel;
    
    UIBarButtonItem *selectallsubjectbutton;
    UIBarButtonItem *deselectallsubjectbutton;
    //UISegmentedControl *scdailyweeklyview;
    
    NSString *filtermode;
    NSString *contentmode;
    
    UIDocumentInteractionController * documentInteractionController;
    
    NSMutableArray *ClassroomNameArray;
    
    NSString *instructorselected;
    
    //BOOL initializecolorcode;
    
    int datescrollerwindow;
    long datescrollerwindowstartindex;
    NSMutableArray *datescrollerwindowarray;
    
    //NSArray *TitleClassTypeArray;

    IBOutlet UIButton *title_Cancel;
    UIButton *menubutton;

    BOOL preferredinstructorset;
    
    UIButton *selectinstructorbutton;
    
    float lastexpandcelltableheight;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    

    
    UIView *tabpanelview;
    UITableView *datebartable;
    UILabel *datebardatelabel;
    UILabel *datebardaylabel;
    UILabel *datebartodaylabel;
    
    NSString *lastselectdate;
    
    BOOL popovermode;
    
    InstructorImageGridViewController *instructorimagepopover;
    
    Student *studentobject;
    Lead *leadobject;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIView *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
    //UIView *instructorlegendview;
    
    __weak IBOutlet UIView *supermasterview;
    __weak IBOutlet NSLayoutConstraint *supermasterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *supermasterviewwidthconstraint;
    //__weak IBOutlet UIView *instructorlegendview;
    __weak IBOutlet UIButton *calendarbutton;
    __weak IBOutlet UIScrollView *legendscrollview;
    //UIView *supermasterview;
    UIButton *supermasterviewbutton;
    //UIButton *calendarbutton;
    CalendarView *calendarview;
    UIButton *CancelButton;
    UIButton *ShareButton;
    
    NSMutableDictionary *CTR_positiondict;
    NSMutableDictionary *CTR_positiongroupdict;
    //NSMutableArray *classTimeHeight;
    NSMutableArray *headerWidthArray;
    NSMutableArray *headerPositionArray;
    
    BOOL detailViewMode;
    BOOL weeklyMode;
    NSString *dailydateselected;
    
    UIScrollView *classTimeView;
    NSMutableDictionary *ClassTimeTableRecordDictionary;
    NSMutableArray *ClassTimeTableRecordArray;
    
    NSMutableDictionary *ClassTimeDetailsdictionary;
    TimeTableDetails *TimeTableDetailsObject;
    
    NSArray *allClassDay;
    
    NSString *headertype;
    
    long maxNoOfItemInACell;
    UICollectionView *timetablecollectionview;
    ClassTimeTableCollectionVFL *vfl;
    
    UILabel *TimeLabel;
    //UIView *InitialDateBarView;
    UILabel *datebartablebackground;
    
    NSMutableArray *SubjectNameArray;
    NSMutableArray *AvailableSubjectNameArray;
    //NSMutableDictionary *colorcodedictionary;
    
    NSArray *headertypearray;
    NSArray *contentmodearray;
    NSArray *viewmodearray;
    NSArray *zoommodearray;
    NSArray *outstandingpaymentmodearray;
    UISegmentedControl *scviewmode;
    UISegmentedControl *sczoommode;
    UISegmentedControl *scoutstandingpaymentmode;
    
    UISegmentedControl *scheadertype;
    UISegmentedControl *sccontentmode;
    
    float cellwidthfordetailview;
    ClassTimeTableRecord3 *selecteddetaillesson;
    
    CGPoint previouscontentoffset;
    
    float classtimewidth;
    float timetablewidth;
    float totalcellheight;
    float legendviewwidth;
    
    UILabel *title_masterview_start;
    UILabel *title_masterview_duration;
    UILabel *title_masterview_subject;
    UILabel *title_masterview_type;
    UILabel *title_masterview_student;
    UILabel *title_masterview_age;
    UILabel *title_masterview_level;
    UILabel *title_masterview_instructor;
    UILabel *title_masterview_classroom;
    UILabel *title_masterview_outstandingclass;
    UILabel *title_masterview_outstandingamount;
    
//    UISwitch *swcombine3rddimension;
    BOOL combine3rddimension;
//    UILabel *combine3rddimensionlabel;
    UITableView *EmptySlotPopupTable;
    
    UISwitch *swgroupsubjectcategory;
    UILabel *groupsubjectcategorylabel;
    BOOL groupsubjectcategory;
    
    UISwitch *swhideemptycolumns;
    UILabel *hideemptycolumnslabel;
//    BOOL groupsubjectcategory;
    
    UISwitch *swshowallstudentcount;
    UILabel *showallstudentcountlabel;
    
    UISwitch *swshowattendingcount;
    UILabel *showattendingcountlabel;
    
    UISwitch *swshowoutstandingpaymentstudentcount;
    UILabel *showoutstandingpaymentstudentcountlabel;
    
    UISwitch *swshowlessonnumber;
    UILabel *showlessonnumberlabel;
    
    NSInteger minclassduration;
    
    NSMutableDictionary *timetablestudentdict;
    NSInteger totalattendedcount;
    
    NSMutableArray *selectedClassroomArray;
    NSMutableArray *selectedInstructorArray;
    NSMutableArray *selectedSubjectArray;
    
    NSMutableDictionary *visibleItems;
    NSMutableArray *reusableItems;
    CGRect visibleRect;
//    NSView *contentView;
    
    ClassTimeTableSubRecord *timetablesubrecord;
    UIButton *contentViewBackgroundButton;
    NSMutableDictionary *newcoursedict;
}

@property (nonatomic,strong) NSString *classtypeselected;
@property (nonatomic) BOOL ClassScheduleTableShown;
@property (strong,nonatomic) NSMutableArray *JSONArray;
//@property (strong,nonatomic) NSMutableArray *ClassTimeTableRecordArray;
//@property (strong,nonatomic) NSMutableArray *ClassTimeTableAllArray;
//@property (strong,nonatomic) NSMutableArray *ClassSchedulePositionArray;

@property (strong,nonatomic) ClassTimeTableRecord *ClassTimeTableObject;

//@property (strong,nonatomic) UIScrollView *datescrollbar;
//@property (strong,nonatomic) NSMutableArray *schoolDateArray;
@property (strong,nonatomic) NSMutableArray *InstructorArray;
@property (nonatomic,strong) NSMutableArray *InstructorNameArray;
@property (nonatomic,strong) NSMutableArray *AvailableInstructorNameArray;
@property (nonatomic,strong) NSMutableArray *AvailableClassroomArray;
@property (strong,nonatomic) Instructor *InstructorObject;
@property (strong,nonatomic) NSArray *classDay;
@property (strong,nonatomic) NSMutableArray *classTime;
@property (strong,nonatomic) NSString *TimeTableMode;
@property (strong,nonatomic) NSString *Subjectselected;
@property (strong,nonatomic) NSString *globalselecteddate;
@property (strong,nonatomic) NSString *tmpselecteddate;

@property (strong,nonatomic) ClassScheduleRecord *ClassScheduleRecordObject;
@property (strong,nonatomic) NSMutableArray *ClassScheduleRecordArray;
@property (strong,nonatomic) UIPopoverPresentationController *myPopoverController;
//@property (strong,nonatomic) UIPopoverPresentationController *myStudentPopoverController;
//@property (strong,nonatomic) UIPopoverPresentationController *myDTPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myFreeSchedulePopoverController;
@property (strong,nonatomic) UITableView *ClassDetailTable;

@property (strong,nonatomic) UIScrollView *masterScrollView;
@property (strong,nonatomic) UIView *freeschedulemasterView;

//@property (strong,nonatomic) TimeTableDetails *TimeTableDetailsObject;
//@property (strong,nonatomic) NSMutableArray *TimeTableDetailsArray;
//@property (strong,nonatomic) NSMutableArray *TimeTableDetailsPositionArray;

@property (strong,nonatomic) FreeScheduleClass *FreeScheduleClassObject;
@property (strong,nonatomic) NSMutableArray *FreeScheduleClassArray;
@property (strong,nonatomic) UITableView *FreeScheduleTable;
@property (strong,nonatomic) FSSegmentedControl *scscheduletype;
//@property (strong,nonatomic) NSArray *colorcodearray;

//@property (strong, nonatomic) UISegmentedControl *scviewtype;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scviewtype;

@property (strong,nonatomic) id<myClassTimeTableViewControllerDelegate>delegate;

@property (strong,nonatomic) UIPickerView *myPicker;

@property (strong,nonatomic) NSString *subjectallclassremarks;
@property (strong,nonatomic) NSString *draftenrollmentkey;
@property (strong,nonatomic) NSString *draftclasskey;

@property (strong,nonatomic) UIView *headerview;
@property (strong,nonatomic) UIButton *classtablebutton;

@property (strong,nonatomic) NSString *timetableselectedclassdate;
@property (strong,nonatomic) NSString *startupmonday;

@property (strong,nonatomic) NSString *preferredinstructor;
@property (strong,nonatomic) NSString *preferredclassroom;
@property (strong,nonatomic) UIPopoverPresentationController *myClassTypeSelectionPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myClassSelectionPopoverController;
@property (strong,nonatomic) NSString *studentkey;
@property (strong,nonatomic) NSString *sourcemode;
@property (strong,nonatomic) NSString *EnrollmentMode;
@property (strong,nonatomic) NSString *selectedschedulekey;



-(BOOL) generateTimeTablewithViewOption:(NSString *)viewoption pastMonday:(NSString *)pastMonday classtype:(NSString *)classtype redrawscoller:(BOOL)redrawscroller;
-(void) closesidewindow;
- (IBAction)opencalendar:(id)sender;
- (IBAction)openviewoption:(id)sender;
- (IBAction)filterbuttonpressed:(id)sender;
- (IBAction)selectclasstype:(id)sender;

@end
