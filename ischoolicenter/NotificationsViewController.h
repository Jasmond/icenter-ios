//
//  NotificationsViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 2/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "SwitchCenterViewController.h"
//#import "CalendarViewController.h"
#import "CalendarView.h"
#import "slideView.h"
#import "FullScreenPhotoViewController.h"
#import "PickerViewController.h"
#import "MessagePopoverViewController.h"
#import "ClassPhotoPopoverViewController.h"
#import "WhatsNewViewController.h"
#import "DocumentFolderPopoverViewController.h"
#import "MainViewController.h"

@import Charts;

@interface NotificationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,mySwitchCenterViewControllerDelegate,myCalendarViewDelegate,mySlideViewDelegate,myFullScreenPhotoViewControllerDelegate,myPickerViewControllerDelegate,myMessagePopoverViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myClassPhotoPopoverVCDelegate,myWhatsNewViewControllerDelegate,myDocumentFolderPopoverViewController,UIPopoverPresentationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    MainViewController *mainviewcontroller;
    __weak IBOutlet UILabel *todaylabel;
    NSDate *displaydate;
    NSDate *olddisplaydate;
    
    __weak IBOutlet UITableView *NotificationsTable;
    __weak IBOutlet UITableView *StatusTable;
    __weak IBOutlet UIStackView *mainstackview;
    
    UILabel *notificationlabel;
    
    NSMutableArray *JSONArray;
    NSMutableArray *FirstClassArray;
    NSMutableArray *LastClassArray;
    NSMutableArray *OutstandingArray;
    NSMutableArray *PendingRenewalArray;
    NSMutableArray *MakeupClassArray;
    NSMutableArray *AbsentClassArray;
    NSMutableArray *AssessmentClassArray;
    NSMutableArray *TrialClassArray;
    
    NSMutableArray *MyTaskArray;
    NSMutableArray *TaskToOthersArray;
    NSMutableArray *AllOtherTaskArray;
    
    NSMutableArray *ImportantMessageArray;
    NSMutableArray *PromotionalMessageArray;
    NSMutableArray *GeneralMessageArray;
    
    NSMutableArray *SlideArray;
    
    UILabel *messagestarttimelabel;
    UILabel *messagelabel;
    UILabel *messagereceipientlabel;
    
    MessageRecord *messagerecordobject;

    /*BOOL showallothertasks;
    
    BOOL showfirstclass;
    BOOL showlastclass;
    BOOL showoutstanding;
    BOOL showpendingrenewal;
    BOOL showassessclass;
    BOOL showtrialclass;
    BOOL showmakeupclass;
    BOOL showabsentclass;
    
    BOOL shownotaskrecord;
    BOOL showmytask;
    BOOL showtasktoother;
    BOOL showallothertask;*/
    
    BOOL shownonotificationrecord;
    
    UIImageView *studentimageview;

    
    NSDateFormatter *df;
    
    NSMutableArray *subjectarray;
    NSMutableArray *productarray;
    
    UIRefreshControl *tablerefresh;

    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    UIButton *calendarbutton;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    
    UserPrivilege *userprivilege;
    
    __weak IBOutlet UIVisualEffectView *blurEffectView;
    
    UIButton *reloadbutton;
    
    __weak IBOutlet UIView *masterview;
    __weak IBOutlet UIView *filterview;
    __weak IBOutlet UIImageView *backgroundcenterimage;
    
    __weak IBOutlet UILabel *title_hotnews;
    __weak IBOutlet UILabel *title_status;
    UIButton *masterviewbutton;
    __weak IBOutlet UILabel *title_notification;

    CalendarView *calendarview;

    __weak IBOutlet NSLayoutConstraint *masterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *masterviewtrailingconstrain;
    
    __weak IBOutlet UIScrollView *slideScrollView;
    __weak IBOutlet UIStackView *slideStack;
    
    FullScreenPhotoViewController *fullscreenphotoviewcontroller;
    
    BOOL runviewdidappear;
    
    NSInteger lastscrollindex;
    
    float slidewidth;
    float slideheight;
    
    NSMutableArray *StatusTableRowArray;
    NSNumberFormatter *currencyformatter;
    
    NSString *period;
    NSInteger myoutstandingtaskcount;
    NSInteger outstandingtasktoothercount;
    NSInteger pendingrequestcount;
    NSInteger autorenewfailurecount;
    NSMutableArray *paidrecordchartvalues;
    NSMutableArray *enrollmentcountrecordsdataset;
    NSMutableArray *paidrecordsdataset;
    float totalpaid;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIActivityIndicatorView *ailoadindicator;
    UIWindow *mainWindow;
    
    UIButton *addclassphotobutton;
    
    float totaloutstanding;
    NSInteger latestwhatsnewbuild;
    
    UIButton *documentfolderbutton;
    UILabel *documentfoldercountlabel;
    DocumentFolderPopoverViewController *documentfolderpopover;
    
    CGFloat lastAppWidth;
}
@property (nonatomic,strong) UIImagePickerController *imagepicker;
@property (nonatomic,strong) UIPopoverPresentationController *mypopovercontroller;
- (IBAction)previousday:(id)sender;
- (IBAction)opencalendar:(id)sender;
- (IBAction)nextday:(id)sender;


@end
