//
//  ClassTimeTableDetailsPopoverViewController.h
//  iCenter
//
//  Created by Jasmond Luk on 15/11/2021.
//  Copyright © 2021 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"
#import "PickerViewController.h"
#import "MainViewController.h"


@protocol myClassTimeTableDetailsPopoverViewController <NSObject>
@required
-(NSMutableArray *) refreshClassScheduleWithLesson:(ClassTimeTableRecord3 *)object;
-(void) reloadClassTimeTable:(BOOL)reload;
-(void) closesidewindow;
-(void) enrollStudentwithlessonobject:(ClassTimeTableRecord3 *)lessonobject studentkey:(NSString *)studentkey classscheduleobject:(ClassScheduleRecord *)classschedulerecord;
@end


//NS_ASSUME_NONNULL_BEGIN

@interface ClassTimeTableDetailsPopoverViewController : UIViewController<UIGestureRecognizerDelegate,UISearchBarDelegate,myPickerViewControllerDelegate>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UITableView *ClassScheduleTable;
    
    MainViewController *mainviewcontroller;
    BOOL editattendanceviewopened;
    NSMutableArray *filteredClassScheduleRecordArray;
    NSMutableArray *selectededitattendanceclasskeyarray;
    NSMutableDictionary *validateclassarray;
    __weak IBOutlet UISearchBar *searchbar;
    UILongPressGestureRecognizer *clpgr;
    UIView *attendanceringview;
    NSString *selectedAttendanceStatus;
    ClassValidateMessage *classvalidatemessage;
    ClassValidateStatus *classvalidatestatus;
    ClassScheduleRecord *ClassScheduleObject;
    UIButton *warningbuttonselected;
    UILabel *warningmessagelabel;
    UILabel *warningtitlelabel;
    FreeScheduleClass *freescheduleclassobject;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *regularattendancebuttonarray;
    NSMutableArray *makeupdtattendancebuttonarray;
    NSString *selecteddate;
    long lasttouchedsector;
    BOOL reloadclasstimetable;

    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    UIActivityIndicatorView *ailoadindicator;
    
    UIStoryboard *mainStoryboard;
    
    NSMutableArray *allstudentarray;
    NSMutableArray *allleadarray;
    NSMutableArray *allstaffarray;
    NSMutableArray *sortingarray;
    
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
    
    __weak IBOutlet UIButton *attendanceUnknownButton;
    __weak IBOutlet UIButton *attendancePresentButton;
    __weak IBOutlet UIButton *attendanceAbsentButton;
    __weak IBOutlet UIButton *attendanceMakeupButton;
    __weak IBOutlet UIButton *attendanceExtendButton;
    __weak IBOutlet UIButton *sendParentNoteButton;
    __weak IBOutlet UIButton *sendMessageButton;
    __weak IBOutlet UIButton *actionsButton;
    __weak IBOutlet UIView *editattendanceview;
    __weak IBOutlet UIButton *canceleditattendancebutton;
    __weak IBOutlet UILabel *attendancecountlabel;
    __weak IBOutlet UIButton *selectallbutton;
    __weak IBOutlet UIButton *deselectallbutton;
    __weak IBOutlet UIImageView *selectallicon;
    __weak IBOutlet UIImageView *deselectallicon;
    __weak IBOutlet UIButton *selectbutton;
    
    __weak IBOutlet UILabel *title_datetime;
    __weak IBOutlet UILabel *title_subject;
    __weak IBOutlet UILabel *title_instructor;
    __weak IBOutlet UILabel *title_sinstructor;
    __weak IBOutlet UILabel *title_classroom;
    __weak IBOutlet UIStackView *attendancestackview;
    __weak IBOutlet UIButton *editlessonbutton;
    __weak IBOutlet UIStackView *sinstructorStack;
    
    FreeScheduleClass* return_freescheduleclass;
    BOOL return_updatefollowinglessons;
    NSMutableArray *return_updatefollowinglessonsfields;
    
}
@property (strong,nonatomic) id<myClassTimeTableDetailsPopoverViewController>delegate;
@property (strong ,nonatomic) NSMutableArray *ClassScheduleRecordArray;
@property (strong ,nonatomic) ClassTimeTableRecord3 *lesson;
@property (nonatomic) NSDate *dateselected;
@property (strong, nonatomic) NSString *timetablemode;
- (IBAction)attendanceUnknownButtonPressed:(id)sender;
- (IBAction)attendancePresentButtonPressed:(id)sender;
- (IBAction)attendanceMakeupButtonPressed:(id)sender;
- (IBAction)attendanceAbsentButtonPressed:(id)sender;
- (IBAction)attendanceExtendButtonPressed:(id)sender;
- (IBAction)sendParentNoteButtonPressed:(id)sender;
- (IBAction)sendMessageButtonPressed:(id)sender;
- (IBAction)selectallbuttonpressed:(id)sender;
- (IBAction)deselectallbuttonpressed:(id)sender;
- (IBAction)selectbuttonpressed:(id)sender;
- (IBAction)editlessonbuttonpressed:(id)sender;
- (IBAction)addstudentbuttonpressed:(id)sender;
- (IBAction)actionsButtonPressed:(id)sender;

-(void) validationPassed:(BOOL)pass;
@end

//NS_ASSUME_NONNULL_END
