//
//  DTViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/11/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "DTAddEditViewController.h"
#import "SwitchCenterViewController.h"
#import "LeadDetailsViewController.h"
#import "LeadDetailsNavController.h"


@interface DTViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,myDTAddEditViewControllerDelegate,UIGestureRecognizerDelegate,mySwitchCenterViewControllerDelegate,UISearchBarDelegate,myLeadDetailsViewController>{
    
    MainViewController *mainviewcontroller;
    
    UILabel *StudentNameLabel;
    UILabel *GenderLabel;
    UILabel *DTDateLabel;
    UILabel *DTTimeLabel;
    UILabel *ClassLabel;
    UILabel *GradeLabel;
    UILabel *LevelLabel;
    UILabel *ClassDurationLabel;
    UILabel *ClassTypeLabel;
    UILabel *InstructorLabel;
    UILabel *RemarksLabel;
    UILabel *ParentnameLabel;
    UILabel *ParentcontactLabel;
    UILabel *TypeLabel;
    UIButton *AttendanceButton;
    UIImageView *studentimage;

    
    GlobalVariables *globalvariables;

    UILabel *viewtitle;
    
    NSMutableArray *InstructorArray;
    //UISegmentedControl *scStatusBar;
    __weak IBOutlet UISegmentedControl *scStatusBar;
    
    UIButton *allbutton;
    UIButton *reloadbutton;
    IBOutlet UIButton *addDTbutton;
    NSInteger laststatusindex;

    __weak IBOutlet UILabel *title_Student;
    __weak IBOutlet UILabel *title_Type;
    __weak IBOutlet UILabel *title_Subject;
    __weak IBOutlet UILabel *title_Date;
    __weak IBOutlet UILabel *title_Time;
    __weak IBOutlet UILabel *title_Duration;
    __weak IBOutlet UILabel *title_Instructor;
    __weak IBOutlet UILabel *title_Grade;
    __weak IBOutlet UILabel *title_Level;
    __weak IBOutlet UILabel *title_Remarks;
    __weak IBOutlet UILabel *title_Status;
    __weak IBOutlet UILabel *title_Attendance;
    __weak IBOutlet UILabel *title_Classroom;
    
    NSArray *statusarray;
    NSArray *typearray;
    
    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *makeupdtattendancebuttonarray;
    long lasttouchedsector;
    
    UIRefreshControl *tablerefresh;
    

    
    NSDateFormatter *df;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    

    
    __weak IBOutlet UISearchBar *dtsearchbar;
//    UISearchBar *dtsearchbar;
    NSMutableArray *filteredDTArray;
    
    UITableView *sortingtable;
    NSMutableArray *sortingarray;
    UILabel *sortingnamelabel;
//    UIButton *sortingorderbutton;
    __weak IBOutlet UIButton *sortingorderbutton;
    SortingRecord *sortingobject;
    
//    UITableView *DTTable;
    __weak IBOutlet UITableView *DTTable;
    
    UITableView *datebartable;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
//    UIView *tableview;
    
}

@property (nonatomic, strong) NSMutableArray * JSONArray;
@property (nonatomic, strong) AssessmentTrialRecord *DTObject;
@property (nonatomic, strong) NSMutableArray * DTArray;

@property (strong,nonatomic) UIPopoverPresentationController *myPopoverController;
//@property (strong,nonatomic) UIScrollView *monthscroller;
//@property (strong,nonatomic) NSMutableArray *schoolMonthArray;
@property (strong,nonatomic) NSString *selectedmonth;
@property (strong,nonatomic) UISegmentedControl *scStatus;
//@property (strong, nonatomic) UISegmentedControl *sctype;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sctype;
@property (strong,nonatomic) NSString *selecteddtkey;
@property (strong,nonatomic) UIPopoverPresentationController *myStudentPopoverController;



- (IBAction)selecttype:(id)sender;
- (IBAction)addDTRecord:(id)sender;
- (IBAction)menubutton:(id)sender;


@end
