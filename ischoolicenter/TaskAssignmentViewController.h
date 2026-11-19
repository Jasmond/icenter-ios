//
//  TaskAssignmentViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 3/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "SwitchCenterViewController.h"
#import "CalendarView.h"
#import "MakeupPopoverViewController.h"
#import "StudentDetailsNavController.h"
#import "StudentDetailsViewController.h"

@interface TaskAssignmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,mySwitchCenterViewControllerDelegate,myCalendarViewDelegate,UISearchBarDelegate,myMakeupPopoverViewControllerDelegate,myStudentViewController>
{
    //sqlite3 *isdb;
    MainViewController *mainviewcontroller;
    GlobalVariables *globalvariables;
    UILabel *viewtitle;
    
    UILabel *createdatetimelabel;
    UILabel *assignedbylabel;
    UILabel *assignedtolabel;
    UILabel *assignedbytolabel;
    UILabel *followupdatetimelabel;
    UILabel *tasknamelabel;
    UILabel *remarkslabel;
    UILabel *statuslabel;
    
    NSMutableArray *JSONArray;
    
    NSMutableArray *MyTaskArray;
    NSMutableArray *TasksToOthersArray;
    NSMutableArray *AllOtherTasksArray;
    
    __weak IBOutlet UIView *taskview;
    __weak IBOutlet UIView *requestview;
    __weak IBOutlet UITableView *TaskTable;
    __weak IBOutlet UITableView *RequestTable;
    __weak IBOutlet UISegmentedControl *sctaskview;
    __weak IBOutlet UISegmentedControl *sctype;
    __weak IBOutlet UISegmentedControl *screquestor;
    __weak IBOutlet UISegmentedControl *screqueststatus;
    __weak IBOutlet UIStackView *actionTitleStack;
    __weak IBOutlet UITextField *search_text;
    IBOutlet UISegmentedControl *scstatus;
    IBOutlet UIButton *assigntaskbutton;
    
    UISegmentedControl *scrowstatus;
    
    UITableView *taskAddTable;
    //UITableView *taskEditTaskTable;
    UITableView *statusUpdateTaskTable;
    
    
    
    BOOL showtaskdatetimepicker;
    UILabel *taskAddlabel;
    UILabel *taskAddAssignBylabel;
    UILabel *taskAddAssignTolabel;
    UILabel *taskAddDateTimelabel;
    UITextView *taskAddTaskNametext;
    
    NSString *selectedItem;
    
    NSString *tmptaskcreatedatetime;
    NSString *tmpowner;
    NSString *tmpassignee;
    NSString *tmptaskadddatetime;
    NSString *tmptaskaddtaskname;
    NSString *tmptaskkey;
    int tmpassignclasstype;
    
    //NSMutableArray *datePickerViewMenu;
    NSMutableArray *hourPickerViewMenu;
    NSMutableArray *minutePickerViewMenu;
    //NSMutableArray *AssigneeListArray;
    
    NSMutableArray *pickerViewMenu;
    NSString *selectedValue;
    UIPickerView *myPickerView;
    
    float keyboardheight;
    

    
    NSMutableArray *groupMemberArray;
    
    long presetRow;
    long datePresetRow;
    long hourPresetRow;
    long minutePresetRow;
    
    UITextView *closemytaskupdatetext;
    

    NSString *donebuttonmode;
    
    IBOutlet UILabel *assignedbytoheaderlabel;
    
    BOOL showallothertasks;
    
    UIButton *reloadbutton;
    NSInteger lasttaskindex;
    NSInteger laststatusindex;
    
    TaskRecord *taskrecordobject;
    StudentRequestRecord *studentrequestrecordobject;
    StudentRequestRecord *selectedstudentrequestrecord;
    
    UIPopoverPresentationController *myCloseTaskPopoverController;
    IBOutlet UILabel *title_Date_Created;
    IBOutlet UILabel *title_Assigned_To;
    IBOutlet UILabel *title_Assigned_By;
    IBOutlet UILabel *title_Followup_On;
    IBOutlet UILabel *title_Task_Description;
    IBOutlet UILabel *title_Remarks;
    IBOutlet UILabel *title_Status;
    
    __weak IBOutlet UILabel *title_task_Student;
    __weak IBOutlet UILabel *title_task_Subject;
    __weak IBOutlet UILabel *title_task_Request_Date;
    __weak IBOutlet UILabel *title_task_Requestor;
    __weak IBOutlet UILabel *title_task_Requesting_From;
    __weak IBOutlet UILabel *title_task_Requesting_To;
    __weak IBOutlet UILabel *title_task_Reason;
    __weak IBOutlet UILabel *title_task_Status;
    __weak IBOutlet UILabel *title_task_Action;
    
    
    UISegmentedControl *scassigntype;
    
    NSArray *statusarray;
    
    NSDateFormatter *df;
    
    UIRefreshControl *tablerefresh;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    UIViewController *taskdetailsviewcontroller;
    
    UIView *OwnerTableMasterView;
    UITableView *OwnerTable;
    UIToolbar *OwnerTableToolBar;
    UISearchBar *ownersearchbar;
    BOOL showOwnTable;
    
    UIView *AssigneeTableMasterView;
    UITableView *AssigneeTable;
    UIToolbar *AssigneeTableToolBar;
    UISearchBar *assigneesearchbar;
    BOOL showAssigneeTable;
    
    NSMutableArray *allStaffArray;
    NSMutableArray *filteredStaffArray;
    NSMutableArray *allGroupArray;
    NSMutableArray *filteredGroupArray;
    
    NSMutableArray *studentRequestArray;
    NSMutableArray *filteredStudentRequestArray;
    
    ClassValidateStatus *classvalidatestatus;
    ClassValidateMessage *classvalidatemessage;
    
    NSInteger sideWindowType;

    
    
}
@property (strong,nonatomic) UIPopoverPresentationController *myPopoverController;
@property (strong,nonatomic) NSString *selectedtaskkey;
@property (strong,nonatomic) NSString *selectedtaskview;
@property (strong,nonatomic) NSString *selectedview;

- (IBAction)selectstatus:(id)sender;
- (IBAction)assignedtaskbuttonpressed:(id)sender;
- (IBAction)menubutton:(id)sender;
- (IBAction)selecttype:(UISegmentedControl *)sender;
- (IBAction)selectrequestor:(id)sender;
- (IBAction)selectrequeststatus:(id)sender;
-(void) validationPassed:(BOOL)pass;




@end
