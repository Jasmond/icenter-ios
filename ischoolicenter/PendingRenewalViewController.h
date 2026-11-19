//
//  PendingRenewalViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "MyObject.h"
#import "EnrollmentPopoverViewController.h"
#import "StudentDetailsViewController.h"
#import "StudentDetailsNavController.h"
#import "SwitchCenterViewController.h"
#import "CalendarView.h"

@interface PendingRenewalViewController : UIViewController<UITabBarControllerDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,myPopoverVCDelegate,UITableViewDataSource,UITableViewDelegate,mySwitchCenterViewControllerDelegate,myPopoverVCDelegate,UIGestureRecognizerDelegate,myCalendarViewDelegate,myStudentViewController>
{
    //UIView *renewalmanualmenudayview;
    __weak IBOutlet UIView *renewalrecordtablelistview;
    //UIView *renewalbatchmenuview;
    __weak IBOutlet UIView *renewallogtablelistview;
    MainViewController *mainviewcontroller;
    
    
    UIImageView *AutoRenewImage;

    NSString *selecteddatemanual;
    NSString *lastcellcolor;
    long selecteddayindex;
    GlobalVariables *globalvariables;
    UILabel *viewtitle;
    

    NSInteger lastdayofweekindex;
    
    UIButton *reloadbutton;
    __weak IBOutlet UILabel *studenttitle;
    __weak IBOutlet UILabel *classtitle;
    __weak IBOutlet UILabel *schedulenametitle;
    __weak IBOutlet UILabel *daytitle;
    __weak IBOutlet UILabel *timetitle;
    //UILabel *leveltitle;
    __weak IBOutlet UILabel *scheduledlefttitle;
    __weak IBOutlet UILabel *TBDmakeuplefttitle;
    __weak IBOutlet UILabel *lastdatetitle;
    __weak IBOutlet UILabel *renewalstarttitle;
    __weak IBOutlet UILabel *TBDclasslefttitle;
    __weak IBOutlet UIView *LeftBlock;
    
    __weak IBOutlet UILabel *studenttitle_log;
    __weak IBOutlet UILabel *subjecttitle_log;
    __weak IBOutlet UILabel *scheduletitle_log;
    __weak IBOutlet UILabel *renewalstatustitle_log;
    __weak IBOutlet UILabel *previousendtitle_log;
    __weak IBOutlet UILabel *renewalstarttitle_log;
    __weak IBOutlet UILabel *renewallogtitle_log;
    
    //NSCache *imageCache;
    //NSString *imagelastupdatetime;
    __weak IBOutlet UITableView *RenewalRecordTable;
    __weak IBOutlet UITableView *LogTable;
    __weak IBOutlet UITableView *LogDetailsTable;

    
    __weak IBOutlet UIButton *RemainingClassThresholdButton;
    __weak IBOutlet UIButton *ManualRenewalButton;
    __weak IBOutlet UIButton *BatchRenewalButton;
    //NSString *renewalmode;
    NSString *selecteddatebatch;

    NSMutableArray *BatchRenewalLogArray;
    RenewalLog *RenewalLogObject;
    RenewalRecord *RenewalRecordObject;
    
    NSMutableArray * RenewalRecordArrayAllResult;
    NSMutableArray * RenewalRecordArrayFilterResult;
    NSMutableArray * RenewalLogArray;
    
    NSMutableArray *RenewalGroupLogArray;
    //NSMutableArray *RenewalGroupLogExpandRowArray;
    NSMutableArray *BatchRenewalEnrollmentkeyArray;
    NSMutableArray *PreviousFilteredScheduleArray;
    
    //UITableView *FilterScheduleTable;
    NSMutableArray *AllScheduleArray;
    NSMutableArray *FilteredScheduleArray;
    
    UILabel *filter_schedulenamelabel;
    UIImageView *filter_schedulenamechecker;
    UILabel *filter_scheduleseparator;
    
    NSMutableArray * JSONArray;
    
    NSString *highlightedconectionid;
    
    

    __weak IBOutlet UIView *menubottombar;
    UIRefreshControl *tablerefresh;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    
    //UITableView *datebartable;
    //UILabel *datebardatelabel;
    //UILabel *datebardaylabel;
    //UILabel *datebartodaylabel;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    UIView *remainingclassthresholdMasterView;
    
    UIView *firstloadcover;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
    BOOL batchrenewalviewopened;
    __weak IBOutlet UIView *batchrenewalview;
    UIButton *submitbatchrenewalbutton;
    UILongPressGestureRecognizer *clpgr;
    
    __weak IBOutlet UISegmentedControl *sccoursetype;
    __weak IBOutlet UIButton *cutoffdatebutton;
    __weak IBOutlet UITextField *search_text;
    __weak IBOutlet UITextField *auto_search_text;
    __weak IBOutlet UIView *supermasterview;
    __weak IBOutlet UIButton *selectbutton;
    UIButton *supermasterviewbutton;
    CalendarView *calendarview;
    LessonRecord2 *lesson2object;
    __weak IBOutlet NSLayoutConstraint *batchrenewalviewheightconstraint;
    __weak IBOutlet NSLayoutConstraint *supermasterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *supermasterviewtrailingconstraint;
    
    NSInteger groupLogSelected;
    RenewalGroupLog *RenewalGroupObject;
    
    BOOL gotoautorenewal;
    NSMutableArray *renewallogarray;
    NSMutableArray *filteredrenewallogarray;
}

//- (IBAction)menubutton:(id)sender;
@property (nonatomic, strong) NSMutableArray * InstructorArray;
//@property (strong, nonatomic) UIScrollView *monthscoller;
//@property (strong, nonatomic) UIScrollView *datescrollbar;

//@property (strong,nonatomic) NSMutableArray *schoolDateArray;
@property (strong,nonatomic) UIPopoverPresentationController *myPopoverController;

@property (strong,nonatomic) Student *DetailsViewStudent;
@property (strong,nonatomic) EnrollmentRecord *DetailsViewEnrollment;
@property (strong,nonatomic) NSMutableArray *DetailsViewEnrollmentArray;
@property (strong,nonatomic) NSMutableArray *childRenewalRecordEnrollmentKey;
@property (strong,nonatomic) UIPopoverPresentationController *myStudentPopoverController;
-(void) gotoautorenewal;



@end
