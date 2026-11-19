//
//  LeadDetailsViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 17/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "LeadEditViewController.h"
//#import "MessagePopoverViewController.h"
#import "CallLogPopoverViewController.h"
#import "DTAddEditViewController.h"
#import "SwitchCenterViewController.h"
#import "FullScreenPhotoViewController.h"
#import "PickerViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol myLeadDetailsViewController <NSObject>
-(void) updateCategoryCount;
-(void) gobackLeadCategory;
-(void) enableAddLeadButton;
-(void) refreshleaddetailviewpresentingviewcontent;
-(void) updateleadinformationlist:(NSString *)leadkey;
-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys;
-(void) closeleadprofile;
-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord;
-(void) donotrunviewdidappearinleadinformation;

@end

@interface LeadDetailsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,myLeadEditViewControllerDelegate,UIPopoverPresentationControllerDelegate,myCallLogPopoverViewControllerDelegate,myDTAddEditViewControllerDelegate,UIGestureRecognizerDelegate,mySwitchCenterViewControllerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,myFullScreenPhotoViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myPickerViewControllerDelegate,UIDocumentPickerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate>
{
    GlobalVariables *globalvariables;
    MainViewController *mainviewcontroller;
    UIPopoverPresentationController *myPopoverController;
    UISwitch *swflag;
    UISwitch *swpromotion;
    UIButton *leadstatusbutton;
    UITableView *LeadStatusSelectionTable;
    NSArray *LeadStatusArray;

    NSMutableArray *DTRecordArray;
    
    
    UIImageView *viewleadimage;

    BOOL DataChanged;

    UIPopoverPresentationController *mypopovercontroller;


    //NSMutableArray *messageArray;
    NSMutableArray *filteredMessageArray;
    
    InboxMessageRecord *messagerecordobject;

    CAShapeLayer *subjectpointer;

    NSMutableArray *CallLogCalledByArray;

    NSMutableArray *CallLogRecordArray;
    UILabel *calllogheaderlabel;
    UITableView *CallLogCalledBySelectionTable;
    
    NSDateFormatter *df;

    UILabel *dtheaderlabel;

    UITableView *DTSubjectSelectionTable;
    NSString *dtsubjectselected;
    NSMutableArray *DTSubjectArray;

    UITableView *DTTypeSelectionTable;
    NSString *dttypeselected;
    NSMutableArray *DTTypeArray;

    CallLogRecord *calllogobj;


    
    NSMutableArray *MediaArray;
    NSMutableArray *SourceArray;
    
    UILabel *title_Gender;
    UILabel *title_Date_of_Birth;
    UILabel *title_Age;
    UILabel *title_Preferred_Language;
    UILabel *title_Grade;
    UILabel *title_School;
    UILabel *title_Parent_Name;
    UILabel *title_Phone;
    UILabel *title_Email;
    UILabel *title_Address;
    UILabel *title_Lead_Media;
    UILabel *title_Lead_Source;
    UILabel *title_Remarks;
    UILabel *title_Flag;
    UILabel *title_Lead_ID;
    UILabel *title_Promotional_Message;
    
    NSArray *messagecategoryarray;
    
    UIButton *AttendanceButton;
    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *makeupdtattendancebuttonarray;
    long lasttouchedsector;
    
    UIPanGestureRecognizer *panGesture;
    
    NSMutableArray *tableoptionarray;
    
    
    //NSCache *imageCache;
    UIButton *tableoptionbutton;
    UIView *tableoptionbottombar;
    
    NSMutableArray *staffArray;
    
    UIRefreshControl *tablerefresh;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    

    
    UIView *photofullscreenview;
    UIScrollView *fullscreen_scrollview;
    UIButton *fullscreen_closebutton;
    UIImageView *fullscreen_imageview;
    UILabel *fullscreen_studentname;
    
    NSMutableArray *viewhistoryarray;
    
    UITableView *ViewHistoryTable;
    
    UIImageView *viewhistoryimageview;
    UILabel *viewhistorynamelabel;
    UILabel *viewhistoryidlabel;
    
    ViewHistoryRecord *viewhistoryobject;
    UILabel *viewhistorytableheader;
    NSString *imagelastupdatetime;

    UIButton *viewhistorybutton;
    
    Lead *leadobject;
    BOOL runviewdidappear;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
    float selfViewWidth;
    
    //UILabel *copyrightmessagelabel;
    
    UIScrollView *remarksscrollview;
    
    __weak IBOutlet UILabel *dt_header_subject;
    __weak IBOutlet UILabel *dt_header_level;
    __weak IBOutlet UILabel *dt_header_start;
    __weak IBOutlet UILabel *dt_header_time;
    __weak IBOutlet UILabel *dt_header_instructor;
    __weak IBOutlet UILabel *dt_header_classroom;
    __weak IBOutlet UILabel *dt_header_attendance;
    __weak IBOutlet UILabel *dt_header_remarks;
    __weak IBOutlet UILabel *dt_header_type;
    
    float messagecontentwidth;
    NSInteger maxphotoperline;
    UIImageView *fullscreen_messageimageview;
    
    UIImageView *shareimageview;
    UIButton *shareimagebutton;
    
    //UISearchBar *messagesearchbar;
    //UISearchBar *calllogsearchbar;
    //UISearchBar *dtsearchbar;
    
    NSMutableArray *sortingarray;
    SortingRecord *sortingobject;
    
    NSMutableArray *filteredCallLogRecordArray;
    NSMutableArray *filteredDetailsViewDTArray;
    
    //UIButton *dtsortbutton;
    //UIButton *calllogsortbutton;
    //UIButton *messagesortbutton;
    UITableView *sortingtable;
    NSMutableArray *tableoptionviewarray;
    
    __weak IBOutlet UITableView *DetailsViewMessageTable;
    __weak IBOutlet UITableView *CallLogTable;
    __weak IBOutlet UITableView *DetailsViewDTTable;
    __weak IBOutlet UIButton *DTSubjectSelectionButton;
    __weak IBOutlet UIButton *DTTypeSelectionButton;
    __weak IBOutlet UISearchBar *messagesearchbar;
    __weak IBOutlet UISearchBar *calllogsearchbar;
    __weak IBOutlet UISearchBar *dtsearchbar;
    __weak IBOutlet UILabel *copyrightmessagelabel;
    
    __weak IBOutlet UIView *MasterView;
    __weak IBOutlet UILabel *menulabel_lead;
    __weak IBOutlet UILabel *menulabel_messages;
    __weak IBOutlet UILabel *menulabel_calllog;
    __weak IBOutlet UILabel *menulabel_trial;
    
    __weak IBOutlet UIView *menuview_lead;
    __weak IBOutlet UIView *menuview_messages;
    __weak IBOutlet UIView *menuview_calllog;
    __weak IBOutlet UIView *menuview_trial;
    
    __weak IBOutlet NSLayoutConstraint *systemMessageTrailingConstraint;
    __weak IBOutlet UIImageView *calllog_callerarrow;
    __weak IBOutlet UIImageView *dt_coursearrow;
    __weak IBOutlet UIImageView *dt_typearrow;
    
    UILabel * countrycode;
    UIImageView * ccimage;
    
    OutboxMessageRecord *workingMessage;
    NSMutableArray *messageArray;

    UIButton *addphotobutton;
    __weak IBOutlet UITextView *messageinputtext;
    __weak IBOutlet UIView *textinputbox;
    __weak IBOutlet UISegmentedControl *scsender;
    __weak IBOutlet UIButton *channelbutton;
    __weak IBOutlet UIImageView *contactimage;
    __weak IBOutlet UILabel *contactlabel;
    __weak IBOutlet UIView *instantmessagetopbox;
    
    __weak IBOutlet UIButton *sendinstantmessagebutton;
    __weak IBOutlet UIButton *camerabutton;
    __weak IBOutlet UICollectionView *instantPhotoCollectionView;
    FullScreenPhotoViewController *fullscreenphotoviewcontroller;
    NSMutableArray *readmessagearray;
    UIImagePickerController *imagepicker;
    __weak IBOutlet NSLayoutConstraint *messageinputtextheightconstraint;
    __weak IBOutlet NSLayoutConstraint *messageinputtextbottomconstraint;
    BOOL keyboardshow;
    CGFloat keyboardheight;
    
    __weak IBOutlet UIButton *recordAudioButton;
    __weak IBOutlet UIView *recordingStatusView;
    __weak IBOutlet UILabel *recordingDuration;
    __weak IBOutlet UILabel *slideToCancelTitle;
    __weak IBOutlet UIImageView *audioRecordingImage;
    
    UIImpactFeedbackGenerator *impactFeedbackGenerator;
    AVAudioPlayer *audioPlayer;
    NSTimer *sliderTimer;
    UISlider *selectedUIslide;
    
    AVAudioRecorder *audioRecorder;
    NSTimer *audioRecorderTimer;
    
    __weak IBOutlet UIButton *lead_editButton;
    __weak IBOutlet UIButton *lead_goToStudentButton;
    __weak IBOutlet UIButton *addContactLogbutton;
    __weak IBOutlet UIButton *addDTbutton;
    
    __weak IBOutlet UIView *selectStatusView;
    NSString *selectMode;
    NSMutableArray *selectedinboxmessages;
    NSMutableArray *selectedoutboxmessages;
    __weak IBOutlet UIButton *cancelSelectButton;
    __weak IBOutlet UIButton *deleteMessageButton;
//    __weak IBOutlet UIButton *forwardMessageButton;
    __weak IBOutlet UILabel *selectedTitle;
    
}

@property (weak, nonatomic) IBOutlet UIView *systemMessageView;
@property (weak, nonatomic) IBOutlet UILabel *systemMessageLabel;
@property (weak, nonatomic) IBOutlet UIStackView *TopMenuView;

@property (nonatomic,assign) NSInteger lastviewindex;

@property (nonatomic,strong) NSMutableArray *InstructorArray;
@property (weak, nonatomic) IBOutlet UIView *MessageView;
@property (weak, nonatomic) IBOutlet UIView *CallLogView;
@property (weak, nonatomic) IBOutlet UIView *DTRecordView;
@property (weak, nonatomic) IBOutlet UIButton *CallLogCalledBySelectionButton;


//lead view label
@property (nonatomic,strong) UILabel * leadnamelabel;
@property (nonatomic,strong) UILabel * genderlabel;
@property (nonatomic,strong) UILabel * dateofbirthlabel;
@property (nonatomic,strong) UILabel * schoollabel;
@property (nonatomic,strong) UILabel * gradelabel;
@property (nonatomic,strong) UILabel * preferredlanguagelabel;
@property (nonatomic,strong) UILabel * agelabel;
@property (strong, nonatomic) UILabel * parentname;
@property (strong, nonatomic) UILabel * parentcontact;
@property (strong, nonatomic) UILabel * parentemail;
@property (strong, nonatomic) UILabel * parentaddress;
@property (strong, nonatomic) UILabel * remarks;
@property (strong, nonatomic) UILabel *leadidlabel;
@property (strong, nonatomic) UILabel *medialabel;
@property (strong, nonatomic) UILabel *sourcelabel;

@property (weak, nonatomic) id<myLeadDetailsViewController>delegate;
//@property (strong, nonatomic) UILabel *systemMessageLabel;
//@property (strong, nonatomic) UIView *systemMessageView;
@property (nonatomic,strong) UIView *ViewHistoryTableMasterView;

@property (strong, nonatomic) NSString *leadAction;
@property (strong ,nonatomic) NSString *selectedMenu;
@property (strong ,nonatomic) NSString *presetValue;

//@property (weak, nonatomic) IBOutlet UIView *ViewLead;
//@property (strong, nonatomic) UIView *TopMenuView;

//@property (weak, nonatomic) IBOutlet UIView *EnrollmentClassMenuView;

@property (nonatomic,strong) Lead * DetailsViewLead;

//@property (nonatomic,strong) UIButton *ClassSelectionButton;
//@property (nonatomic,strong) NSString *subjectselected;

//@property (strong, nonatomic) UISegmentedControl *sctableoption;
//@property (strong, nonatomic) UITableView *DetailsViewDTTable;



@property (nonatomic, strong) NSMutableArray * DetailsViewDTArray;
//@property (nonatomic, strong) NSString * DetailsViewLeadkey;
@property (nonatomic, strong) NSMutableArray * JSONArray;

//@property (weak, nonatomic) IBOutlet UIView *ViewLead;
@property (strong, nonatomic) UIView *ViewLead;
//@property (strong, nonatomic) UIView *DTRecordView;
//@property (strong, nonatomic) UIView *MessageView;
//@property (strong, nonatomic) UIView *CallLogView;

@property (nonatomic,retain) UIPopoverPresentationController *myPopoverController;
@property (nonatomic, strong) UIPopoverPresentationController *myCallLogSelectionPopoverController;
@property (nonatomic, strong) UIPopoverPresentationController *myDTSelectionPopoverController;
@property (nonatomic,strong) NSString *LeadViewMode;

@property (nonatomic,retain) NSArray *tableViewMenu;
@property (nonatomic,retain) NSArray *pickerViewmenu;
@property (nonatomic,retain) NSMutableArray *datePickerViewMenu;
@property (nonatomic,retain) NSArray *hourPickerViewMenu;
@property (nonatomic,retain) NSArray *minutePickerViewMenu;
@property (nonatomic,retain) UIPickerView *myPickerView;
@property (nonatomic,retain) UITableView *tableMenu;
@property (nonatomic,strong) DTRecord *DetailsViewDTObject;

@property (nonatomic,strong) NSString *selectedDTkey;


//@property (nonatomic,strong) UIButton *CallLogCalledBySelectionButton;
@property (nonatomic,strong) NSString *calllogcalledbyselected;


@property (strong,nonatomic) LeadEditViewController *destleadeditviewcontroller;
//@property (strong, nonatomic) UIView *MasterView;

#pragma mark -
#pragma mark Methods

-(BOOL) retrieveLead:(NSString *)leadkey;
//-(BOOL) retrieveDTWithSubject:(NSString *)subject leadkey:(NSString *)leadkey;
-(void) createLeadViewNavigationButton;
-(void) createDTViewNavigationButton;
-(void) createMessageViewNavigationButton;
-(void) seguetoleadeditview;
//-(BOOL) retrieveleadsubject;
-(void) highlighttableoptionbuttonwithbuttontag:(long)buttontag;
-(void) reloadPageWithFirstLoad:(BOOL)firstload;
-(void) showviewhistory:(BOOL)show;
-(void) closesidewindow;
-(void) retrieveDTrecords;
-(void) stopAudioPlaying;
-(BOOL) retrieveMessageRecord;
-(void) createCallLogViewNavigationButton;
-(BOOL) retrieveCallLogRecord;


- (IBAction)selecttable:(id)sender;
- (IBAction)sortingbuttonpressed:(id)sender;
- (IBAction)selectcalllogcalledby:(id)sender;
- (IBAction)selectdtclass:(id)sender;
- (IBAction)selectdttype:(id)sender;
- (IBAction)camerabuttonpressed:(id)sender;
- (IBAction)channelbuttonpressed:(id)sender;
- (IBAction)selectsender:(id)sender;
- (IBAction)sendinstantmessagebuttonpressed:(id)sender;
- (IBAction)startAudioRecording:(id)sender;
- (IBAction)stopAudioRecording:(id)sender;
- (IBAction)addnewcalllog:(id)sender;
- (IBAction)addnewdt:(id)sender;
- (IBAction)editLead:(id)sender;
- (IBAction)gotostudentprofile:(id)sender;

- (IBAction)deleteMessageButtonPressed:(id)sender;
//- (IBAction)forwardMessageButtonPressed:(id)sender;
- (IBAction)cancelSelectButtonPressed:(id)sender;

@end
