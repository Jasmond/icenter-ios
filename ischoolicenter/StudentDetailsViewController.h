//
//  StudentDetailsViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 3/6/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "EnrollmentPopoverViewController.h"
#import "ClassPopoverViewController.h"
#import "StudentEditViewController.h"
#import "MakeupPopoverViewController.h"
//#import "MessagePopoverViewController.h"
#import "SalesPopoverViewController.h"
#import "DocumentFolderPopoverViewController.h"
#import "CallLogPopoverViewController.h"
#import "SwitchCenterViewController.h"
#import "ClassRemarksPopoverViewController.h"
#import "FullScreenPhotoViewController.h"
#import "PickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "StaffPopoverViewController.h"
#import "AdvancedSearchPopoverViewController2.h"
#import "CouponPopoverViewController.h"
#import "PointPopoverViewController.h"
#import "PointViewController.h"
#import "MainViewController.h"

@protocol myStudentViewController <NSObject>
-(void) updateCategoryCount;
-(void) gobackStudentCategory;
-(void) enableAddStudentButton;
-(void) disableAddStudentButton;
-(void) refreshstudentdetailviewpresentingviewcontent;
-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload;
-(void) gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys saleskey:(NSString *)saleskey;
-(void) refreshparentviewdocumentfoldercount;
-(void) donotrunviewdidappearinstudentinformation;
-(void) returnSearchResult:(NSMutableArray *)student_Array;
-(void) dismissAdvancedSearchWithLoading:(BOOL)loading;
-(void) dismissEditStudentView;

@end

@interface StudentDetailsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,myPopoverVCDelegate,myClassPopoverVCDelegate,myStudentEditViewControllerDelegate,myMakeupPopoverViewControllerDelegate,mySalesPopoverViewControllerDelegate,myDocumentFolderPopoverViewController,myCallLogPopoverViewControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,mySwitchCenterViewControllerDelegate,myClassRemarksPopoverViewControllerDelegate,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,myFullScreenPhotoViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myPickerViewControllerDelegate,UIDocumentPickerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate,myStaffPopoverViewControllerDelegate,myAdvancedSearchPopoverViewControllerDelegate,myCouponPopoverViewControllerDelegate,myPointPopoverViewControllerDelegate,myPointViewControllerDelegate,UIPrintInteractionControllerDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    GlobalVariables *globalvariables;
    
    UIPopoverPresentationController *myPopoverController;
    

    
    NSMutableArray *ClassRecordArray;
    
    //UILabel *nophotolabel;
    
    BOOL DataChanged;
    
    UIImage *boyimage;
    UIImage *girlimage;
    
    UITableView *RemainingClassSummaryTable;
    
    NSMutableArray *ClassSummaryRecordArray;
    
    __weak IBOutlet UIButton *remainingclassbutton;
    
    UIPopoverPresentationController *myClassSummaryPopoverController;
    
    UILabel *classsummaryoutstandingextendtimelabel;
    UILabel *classsummarysubjectlabel;
    UILabel *classsummarynextclasslabel;
    UILabel *classsummarylastclasslabel;
    UILabel *classsummaryremainingclasslabel_scheduledclass;
    UILabel *classsummaryremainingclasslabel_tbdclass;
    UILabel *classsummaryremainingclasslabel_tbdmakeup;
    UILabel *classsummaryoutstandinglabel;
    UILabel *classsummarysubjectschedulelabel;
    UIImageView *classsummaryautorenewimage;
    
    //UITableView *absentmakeupconfirmationtable;
    
    UIPopoverPresentationController *mypopovercontroller;
    NSString *makeuporabsent;
    
    //UITableView *DetailsViewMessageTable;
    __weak IBOutlet UITableView *DetailsViewMessageTable;
    //UISegmentedControl *scmessagecategory;
    
    NSMutableArray *filteredMessageArray;
    
    InboxMessageRecord *messagerecordobject;
    OutboxMessageRecord *workingMessage;

    
    NSMutableArray *allclassremarksArray;
    
    NSMutableArray *SubjectArray;
    CAShapeLayer *subjectpointer;

    UITableView *ClassSelectionTable;
//    UIView *eyelevelhqview;
    
    //UITableView *SalesTable;
    __weak IBOutlet UITableView *SalesTable;
    
    UILabel *salesheaderlabel;
    NSMutableArray *SalesRecordArray;
    NSMutableArray *filteredSalesRecordArray;
    NSMutableArray *ProductCategoryArray;
    NSMutableArray *CallLogCalledByArray;
    
    UITableView *ProductCategorySelectionTable;
    
    //UITableView *CallLogTable;
    __weak IBOutlet UITableView *CallLogTable;
    NSMutableArray *CallLogRecordArray;
    NSMutableArray *filteredCallLogRecordArray;
    UILabel *calllogheaderlabel;
    UITableView *CallLogCalledBySelectionTable;
    
    NSDateFormatter *df;
    
    //UILabel *OrderColorLabel;

    
    
    __weak IBOutlet UILabel *sales_header_orderdate;
    __weak IBOutlet UILabel *sales_header_product;
    __weak IBOutlet UILabel *sales_header_quantity;
    __weak IBOutlet UILabel *sales_header_givenout;
    __weak IBOutlet UILabel *sales_header_totalprice;
    __weak IBOutlet UILabel *sales_header_remarks;
    __weak IBOutlet UILabel *sales_header_invoiceremarks;
    __weak IBOutlet NSLayoutConstraint *sales_header_leadingconstraint;
    
    __weak IBOutlet UILabel *coupon_header_couponid;
    __weak IBOutlet UILabel *coupon_header_coupon;
    __weak IBOutlet UILabel *coupon_header_type;
    __weak IBOutlet UILabel *coupon_header_issuedate;
    __weak IBOutlet UILabel *coupon_header_effectivefrom;
    __weak IBOutlet UILabel *coupon_header_effectiveto;
    __weak IBOutlet UILabel *coupon_header_useddate;
    __weak IBOutlet UILabel *coupon_header_remarks;
    
    
    UIPopoverPresentationController *myProductCategorySelectionPopoverController;
    UIPopoverPresentationController *myCallLogCalledBySelectionPopoverController;
    __weak IBOutlet UIButton *documentfolderbutton;
    UILabel *documentfoldercountlabel;
    NSString *invoiceorreceipt;
    
    UIActivityIndicatorView *aishareprint;
    UIActivityIndicatorView *aishareothers;
    UIActivityIndicatorView *aishareemail;
    
    UIView *CallLogCellView;
    UILabel *CallLogCallDateLabel;
    UILabel *CallLogCalledByLabel;
    UILabel *CallLogDetailsLabel;
    
    //NSMutableArray *userListArray;
    //NSMutableArray *AssigneeListArray;
    CallLogRecord *calllogobj;
    
    //UITableView *DetailsViewDTTable;
    __weak IBOutlet UITableView *DetailsViewDTTable;
    UILabel *dtheaderlabel;
    
    //UIButton *DTSubjectSelectionButton;
    __weak IBOutlet UIButton *DTSubjectSelectionButton;
    UITableView *DTSubjectSelectionTable;
    NSString *dtsubjectselected;
    NSMutableArray *DTSubjectArray;

    __weak IBOutlet UIButton *DTTypeSelectionButton;
    //UIButton *DTTypeSelectionButton;
    UITableView *DTTypeSelectionTable;
    NSString *dttypeselected;
    NSMutableArray *DTTypeArray;
    
//    UIButton *classsummarybutton;
    
    NSMutableArray *MediaArray;
    NSMutableArray *SourceArray;
    NSMutableArray *NewContactArray;
    InboxMessageRecord *forwardmessagerecord;
    NSMutableArray *allstaffgrouparray;
    
//    UIButton *hqmathbutton;
//    UIButton *hqengbutton;
//    UIButton *hqsparkbutton;
//    UIButton *hqplaymathbutton;
//    UIButton *hqhappytalkbutton;
    
//    UISegmentedControl *scselecthqstatus;


    __weak IBOutlet UILabel *enrollment_header_subject;
    __weak IBOutlet UILabel *enrollment_header_start;
    __weak IBOutlet UILabel *enrollment_header_level;
    __weak IBOutlet UILabel *enrollment_header_time;
    __weak IBOutlet UILabel *enrollment_header_instructor;
    __weak IBOutlet UILabel *enrollment_header_classroom;
    __weak IBOutlet UILabel *enrollment_header_day;
    __weak IBOutlet UILabel *enrollment_header_noofclass;
    __weak IBOutlet UILabel *enrollment_header_end;
    __weak IBOutlet UILabel *enrollment_header_remarks;
    __weak IBOutlet NSLayoutConstraint *enrollment_header_leadingconstraint;
    
    __weak IBOutlet UILabel *class_header_subject;
    __weak IBOutlet UILabel *class_header_level;
    __weak IBOutlet UILabel *class_header_start;
    __weak IBOutlet UILabel *class_header_day;
    __weak IBOutlet UILabel *class_header_time;
    __weak IBOutlet UILabel *class_header_instructor;
    __weak IBOutlet UILabel *class_header_classroom;
    __weak IBOutlet UILabel *class_header_attendance;
    __weak IBOutlet UILabel *class_header_makeupdetails;
    __weak IBOutlet UILabel *class_header_extendedtime;
    __weak IBOutlet UILabel *class_header_remarks;

    __weak IBOutlet UILabel *dt_header_subject;
    __weak IBOutlet UILabel *dt_header_level;
    __weak IBOutlet UILabel *dt_header_start;
    __weak IBOutlet UILabel *dt_header_time;
    __weak IBOutlet UILabel *dt_header_instructor;
    __weak IBOutlet UILabel *dt_header_classroom;
    __weak IBOutlet UILabel *dt_header_attendance;
    __weak IBOutlet UILabel *dt_header_remarks;
    __weak IBOutlet UILabel *dt_header_type;
    BOOL showGivenOut;
    
    
    NSArray *dayarray;
    //NSArray *makeupabsentarray;
//    NSArray *activedraftarray;
    NSArray *activedraftarray_enrollment;
    NSArray *activedraftarray_class;
    NSArray *messagecategoryarray;
    
    NSMutableArray *productlistarray;
    
    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *regularattendancebuttonarray;
    long lasttouchedsector;
    
    
    
    UIRefreshControl *tablerefresh;
    
    //long selectedtableindex;
    NSMutableArray *tableoptionarray;
    
    UIButton *tableoptionbutton;
    UIView *tableoptionbottombar;
    
    NSMutableArray *staffArray;
    
    UITableView *DaySelectionTable;
    UITableView *TypeSelectionTable;
    
    //UIActivityIndicatorView *aimainloadindicator;
    
    UILabel *DT_subjectname;
    UILabel *DT_subjectcode;
    UILabel *DT_separator;
    UILabel *DT_subjectfullname;
    
    NSMutableArray *tableoptionviewarray;
    
    UIView *headertitleview;
    
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    

    
    __weak IBOutlet UIView *photofullscreenview;
    UIScrollView *fullscreen_scrollview;
    UIButton *fullscreen_closebutton;
    UIImageView *fullscreen_imageview;
    UILabel *fullscreen_studentname;
    
    __weak IBOutlet UITableView *SiblingTable;
    
    UIImageView *siblingimageview;
    UILabel *siblingnamelabel;
    UILabel *siblingrelationshiplabel;
    
    SiblingRecord *siblingobject;
    //NSCache *imageCache;
    
    NSString *imagelastupdatetime;
    
    __weak IBOutlet UILabel *siblingtableheader;
    UILabel *viewhistorytableheader;
    
    __weak IBOutlet UILabel *siblingnonelabel;
    
    NSMutableArray *viewhistoryarray;
    
    UITableView *ViewHistoryTable;
    
    UIButton *viewhistorybutton;
    
    UIImageView *viewhistoryimageview;
    UILabel *viewhistorynamelabel;
    UILabel *viewhistoryidlabel;
    
    ViewHistoryRecord *viewhistoryobject;

    __weak IBOutlet UIButton *addEnrollmentbutton;
    __weak IBOutlet UIButton *addSalesbutton;
    __weak IBOutlet UIButton *addContactLogbutton;
    __weak IBOutlet UIButton *addDTbutton;
    __weak IBOutlet UIButton *addCouponbutton;
    
    __weak IBOutlet UISearchBar *enrollmentsearchbar;
    __weak IBOutlet UISearchBar *classsearchbar;
    __weak IBOutlet UISearchBar *salessearchbar;
    __weak IBOutlet UISearchBar *messagesearchbar;
    __weak IBOutlet UISearchBar *calllogsearchbar;
    __weak IBOutlet UISearchBar *dtsearchbar;
    __weak IBOutlet UISearchBar *couponsearchbar;

    UIButton *dtsortbutton;
    
    UITableView *sortingtable;
    NSMutableArray *sortingarray;
    UILabel *sortingnamelabel;
    UIButton *sortingorderbutton;
    SortingRecord *sortingobject;
    
    UIImageView *shareimageview;
    UIButton *shareimagebutton;
    
    
    
    
    NSMutableArray *filteredDetailsViewEnrollmentArray;
    NSMutableArray *filteredDetailsViewClassArray;
    NSMutableArray *filteredDetailsViewDTArray;
    
    //__weak IBOutlet UILabel *copyrightmessagelabel;
    

    //UILabel *studentview_parentname_label;
    //UILabel *studentview_email_label;
    //UILabel *studentview_address_label;
    //UILabel *studentview_media_label;
    //UILabel *studentview_source_label;
    //UILabel *studentview_remarks_label;
    //UILabel *studentview_iparent_label;
    __weak IBOutlet UILabel *studentview_parentname_label;
    __weak IBOutlet UILabel *studentview_parentname2_label;
    __weak IBOutlet UILabel *studentview_email_label;
    __weak IBOutlet UILabel *studentview_address_label;
    __weak IBOutlet UILabel *studentview_media_label;
    __weak IBOutlet UILabel *studentview_source_label;
    __weak IBOutlet UILabel *studentview_remarks_label;
    __weak IBOutlet UILabel *studentview_directdebitauthorization_label;
    __weak IBOutlet UIImageView *studentview_dda_imageview;
    
    __weak IBOutlet UILabel *studentview_gender_label;
    __weak IBOutlet UILabel *studentview_studentid_label;
    __weak IBOutlet UILabel *studentview_dateofbirth_label;
    __weak IBOutlet UILabel *studentview_age_label;
    __weak IBOutlet UILabel *studentview_preferredlanguage_label;
    __weak IBOutlet UILabel *studentview_grade_label;
    __weak IBOutlet UILabel *studentview_school_label;
    __weak IBOutlet UILabel *studentview_fcmemberid_label;
    __weak IBOutlet UILabel *studentview_ddaaccountno_label;
    __weak IBOutlet UILabel *studentview_ddaaccountname_label;
    __weak IBOutlet UILabel *studentview_ddadebtorreference_label;
    __weak IBOutlet UILabel *studentview_ddalimit_label;
    __weak IBOutlet UILabel *studentview_extrafield1_label;
    __weak IBOutlet UILabel *studentview_extrafield2_label;
    __weak IBOutlet UIScrollView *parentcontactscrollview;
    __weak IBOutlet UIImageView *parentcontactmoreview;
    __weak IBOutlet UIStackView *ddastackview;
    __weak IBOutlet UIStackView *extrafieldstack;
    __weak IBOutlet UIStackView *extrafield1stack;
    __weak IBOutlet UIStackView *extrafield2stack;
    
    //UIButton *combinepaymentbutton;
    __weak IBOutlet UIButton *combinepaymentbutton;
    
    BOOL isSelectCombinePayment;
    
    DocumentFolderPopoverViewController *documentfolderpopover;
    //UIScrollView *parentcontactscrollview;
    //UIImageView *parentcontactmoreview;
    
    Student *studentobject;
    
    BOOL runviewdidappear;
    BOOL showstudentpage;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    NSLayoutConstraint *sidewindowleadingcontraint;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    NSMutableDictionary *LevelDictionary;
    LastLevelRecord *lastlevelobject;
    
    float selfViewWidth;
    
    float messagecontentwidth;
    NSInteger maxphotoperline;
    UIImageView *fullscreen_messageimageview;
    
    NSString *selectedAttendanceStatus;
    
    ClassValidateMessage *classvalidatemessage;
    ClassValidateStatus *classvalidatestatus;
    __weak IBOutlet UIView *MasterView;
    __weak IBOutlet UILabel *menulabel_student;
    __weak IBOutlet UILabel *menulabel_enrollment;
    __weak IBOutlet UILabel *menulabel_class;
    __weak IBOutlet UILabel *menulabel_sales;
    __weak IBOutlet UILabel *menulabel_messages;
    __weak IBOutlet UILabel *menulabel_calllog;
    __weak IBOutlet UILabel *menulabel_trial;
    __weak IBOutlet UILabel *menulabel_coupon;
    
    __weak IBOutlet UIView *menuview_student;
    __weak IBOutlet UIView *menuview_enrollment;
    __weak IBOutlet UIView *menuview_class;
    __weak IBOutlet UIView *menuview_sales;
    __weak IBOutlet UIView *menuview_messages;
    __weak IBOutlet UIView *menuview_calllog;
    __weak IBOutlet UIView *menuview_trial;
    __weak IBOutlet UIView *menuview_coupon;
    
    __weak IBOutlet UIImageView *menuimage_enrollment;
    __weak IBOutlet UIImageView *menuimage_sales;
    __weak IBOutlet UIImageView *menuimage_coupon;
    __weak IBOutlet NSLayoutConstraint *systemMessageTrailingConstraint;
    __weak IBOutlet UIImageView *productcategorybuttonarrow;
    __weak IBOutlet UIImageView *calllog_callerarrow;
    __weak IBOutlet UIImageView *classselection_arrow;
//    __weak IBOutlet UIImageView *dayselectionarrow;
//    __weak IBOutlet UIImageView *typeselectionarrow;
    __weak IBOutlet UIImageView *dt_coursearrow;
    __weak IBOutlet UIImageView *dt_typearrow;
    
    NSMutableArray *messageArray;
    //MessageContactRecord *selectedmessagecontact;
    NSInteger unreadcount;
    NSInteger firstunreadrow;
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
    
    NSNumberFormatter *currencyformatter;
    BOOL addedtofolder;
    
    __weak IBOutlet UIImageView *viewstudentimage;
    __weak IBOutlet UILabel *studentview_nophoto_label;
    __weak IBOutlet UILabel *studentnamelabel;
    __weak IBOutlet UILabel *studentview_flag_label;
    __weak IBOutlet UILabel *studentview_inactive_label;
    __weak IBOutlet UILabel *studentview_promotionmessage_label;
    __weak IBOutlet UILabel *studentview_sendmessage_label;
    __weak IBOutlet UISwitch *swflag;
    __weak IBOutlet UISwitch *swinactive;
    __weak IBOutlet UISwitch *swpromotionalmessage;
    __weak IBOutlet UISwitch *swsendmessage;
    
    __weak IBOutlet UILabel *studentidlabel;
    __weak IBOutlet UILabel *fcmemberidlabel;
    __weak IBOutlet UILabel *genderlabel;
    __weak IBOutlet UILabel *dateofbirthlabel;
    __weak IBOutlet UILabel *schoollabel;
    __weak IBOutlet UILabel *gradelabel;
    __weak IBOutlet UILabel *preferredlanguagelabel;
    __weak IBOutlet UILabel *agelabel;
    __weak IBOutlet UIStackView *fcmemberidstack;
    __weak IBOutlet UILabel *parentname;
    __weak IBOutlet UILabel *parentname2;
    __weak IBOutlet UILabel *parentemail;
    __weak IBOutlet UILabel *parentaddress;
    __weak IBOutlet UILabel *studentmedialabel;
    __weak IBOutlet UILabel *studentsourcelabel;
    __weak IBOutlet UILabel *ddaaccountnolabel;
    __weak IBOutlet UILabel *ddaaccountnamelabel;
    __weak IBOutlet UILabel *ddadebtorreferencelabel;
    __weak IBOutlet UILabel *ddalimitlabel;
    __weak IBOutlet UILabel *remarks;
    __weak IBOutlet UILabel *extrafield1label;
    __weak IBOutlet UILabel *extrafield2label;
    
    __weak IBOutlet UIView *replyToMessageBar;
    __weak IBOutlet UIView *replyToMessageView;
    __weak IBOutlet UILabel *replyToMessageTitle;
    __weak IBOutlet UIImageView *replyToImageView;
    __weak IBOutlet UILabel *replyToSender;
    
    InboxMessageRecord *replyToMessageRecord;
    
    NSMutableDictionary *replyToMessageDict;
    
    __weak IBOutlet UITableView *couponTable;
    
    NSMutableArray *DetailsViewCouponArray;
    NSMutableArray *filteredDetailsViewCouponArray;
    __weak IBOutlet UISegmentedControl *couponStatusSC;
    __weak IBOutlet UISegmentedControl *subcategorySC;
    
    MainViewController *mainviewcontroller;
    
//    NSMutableArray *bulkcouponstudentkeys;
    
    NSString *pointbalance;
    NSDictionary *expirypointdict;
    __weak IBOutlet UIView *pointBox;
    __weak IBOutlet UILabel *pointBalance;
    __weak IBOutlet UILabel *pointTitleLabel;
    __weak IBOutlet UIStackView *pointExpiryStack;
    __weak IBOutlet UILabel *pointExpiryTitle;

    PointViewController *pointviewcontroller;
    
    UIButton *invoiceprintbutton;
    UIButton *receiptprintbutton;
    
//    UITableView *sharetable;
    
    UIDocumentInteractionController *documentInteractionController;
    
    SalesRecord *DetailsViewSales;
    
    
    __weak IBOutlet UIButton *student_editButton;
    __weak IBOutlet UIButton *student_goToLeadButton;
    
    __weak IBOutlet UIView *MenuView;
    
    __weak IBOutlet UIView *selectStatusView;
    NSString *selectMode;
    NSMutableArray *selectedinboxmessages;
    NSMutableArray *selectedoutboxmessages;
    __weak IBOutlet UIButton *cancelSelectButton;
    __weak IBOutlet UIButton *deleteMessageButton;
    __weak IBOutlet UIButton *forwardMessageButton;
    __weak IBOutlet UILabel *selectedTitle;
    
    NSMutableArray *selectededitattendanceclasskeyarray;
    
}
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,assign) NSInteger lastviewindex;
@property (nonatomic,assign) NSInteger lastdayofweekindex;
@property (nonatomic,assign) NSInteger lastactivedraftindex_enrollment;
@property (nonatomic,assign) NSInteger lastactivedraftindex_class;
@property (nonatomic,assign) NSInteger lasttypeindex;

//@property (nonatomic,strong) NSMutableArray *InstructorArray;

//student view label
@property (weak, nonatomic) IBOutlet UIView *ViewStudent;
@property (weak, nonatomic) id<myStudentViewController>delegate;
@property (weak, nonatomic) IBOutlet UIView *systemMessageView;
@property (weak, nonatomic) IBOutlet UILabel *systemMessageLabel;
@property (nonatomic,strong) NSString *studentAction;
@property (nonatomic,strong) NSString *selectedMenu;
@property (nonatomic,strong) NSString *presetValue;
@property (nonatomic,strong) UIView *ViewHistoryTableMasterView;

@property (nonatomic,strong) Student * DetailsViewStudent;
@property (nonatomic,strong) IBOutlet UIButton *ClassSelectionButton;
@property (nonatomic,strong) NSString *subjectselected;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scactiveoption_enrollment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scactiveoption_class;
@property (weak, nonatomic) IBOutlet UITableView *DetailsViewClassTable;
@property (weak, nonatomic) IBOutlet UITableView *DetailsViewEnrollmentTable;


@property (nonatomic, strong) NSMutableArray * DetailsViewClassArray;
@property (nonatomic, strong) NSMutableArray * DetailsViewEnrollmentArray;
@property (nonatomic, strong) NSMutableArray * JSONArray;
@property (nonatomic, strong) ClassRecord * DetailsViewClass;
@property (nonatomic, strong) EnrollmentRecord * DetailsViewEnrollment;

@property (weak, nonatomic) IBOutlet UIStackView *TopMenuView;

@property (weak, nonatomic) IBOutlet UIView *EnrollmentClassMenuView;
@property (weak, nonatomic) IBOutlet UIView *EnrollmentRecordView;
@property (weak, nonatomic) IBOutlet UIView *ClassRecordView;
@property (weak, nonatomic) IBOutlet UIView *MessageView;
@property (weak, nonatomic) IBOutlet UIView *CallLogView;
@property (weak, nonatomic) IBOutlet UIView *SalesView;
@property (weak, nonatomic) IBOutlet UIView *DTRecordView;
@property (weak, nonatomic) IBOutlet UIView *CouponView;
@property (nonatomic,strong) NSString *classviewmode;

@property (nonatomic,retain) UIPopoverPresentationController *myPopoverController;
@property (nonatomic,strong) UIPopoverPresentationController *mySharePopoverController;
@property (nonatomic,strong) UIPopoverPresentationController *myClassSelectionPopoverController;
@property (nonatomic,strong) UIPopoverPresentationController *myDTSelectionPopoverController;
@property (nonatomic,strong) UIPopoverPresentationController *myDaySelectionPopoverController;
@property (nonatomic,strong) UIPopoverPresentationController *myTypeSelectionPopoverController;
@property (nonatomic,strong) NSString *StudentViewMode;

@property (nonatomic,retain) NSArray *tableViewMenu;
@property (nonatomic,retain) NSArray *pickerViewmenu;
@property (nonatomic,retain) NSMutableArray *datePickerViewMenu;
@property (nonatomic,retain) NSArray *hourPickerViewMenu;
@property (nonatomic,retain) NSArray *minutePickerViewMenu;
@property (nonatomic,retain) UIPickerView *myPickerView;
@property (nonatomic,retain) UITableView *tableMenu;
@property (nonatomic,strong) Lead *DetailsViewLeadObject;
@property (nonatomic,strong) AssessmentTrialRecord *DetailsViewATObject;
@property (nonatomic,strong) ClassScheduleRecord *DetailsViewClassScheduleObject;
@property (nonatomic,strong) DTRecord *DetailsViewDTObject;
@property (nonatomic, strong) NSMutableArray * DetailsViewDTArray;
@property (nonatomic,strong) NSString *selectedDTkey;
@property (nonatomic,strong) NSString *selectedClasskey;
@property (nonatomic,strong) NSString *selectedEnrollmentkey;
@property (nonatomic,strong) NSString *selectedSaleskey;
//@property (nonatomic,strong) UIButton *ProductCategorySelectionButton;
@property (weak, nonatomic) IBOutlet UIButton *ProductCategorySelectionButton;
@property (nonatomic,strong) NSString *productcategoryselected;
//@property (nonatomic,strong) UISegmentedControl *sceventselection;
//@property (nonatomic,strong) UIPopoverPresentationController *myDocumentFolderPopoverController;
//@property (nonatomic,strong) UIButton *CallLogCalledBySelectionButton;
@property (weak, nonatomic) IBOutlet UIButton *CallLogCalledBySelectionButton;
@property (nonatomic,strong) NSString *calllogcalledbyselected;
@property (strong,nonatomic) StudentEditViewController *deststudenteditviewcontroller;
@property (strong,nonatomic) NSArray *dayarray;
@property (strong,nonatomic) NSArray *typearray;
@property (strong,nonatomic) NSArray *activedraftarray;
@property (strong,nonatomic) NSArray *messagecategoryarray;
@property (strong,nonatomic) IBOutlet UIButton *DaySelectionButton;
@property (strong,nonatomic) IBOutlet UIButton *TypeSelectionButton;
@property (strong,nonatomic) NSString *dayselected;
@property (strong,nonatomic) NSString *typeselected;
@property (strong,nonatomic) DocumentFolderPopoverViewController *documentfolderpopover;
@property (weak, nonatomic) IBOutlet UIImageView *typeselectionarrow;
@property (weak, nonatomic) IBOutlet UIImageView *dayselectionarrow;
@property (strong,nonatomic) UILabel *headertitlename;


#pragma mark -
#pragma mark Methods

-(BOOL)retrieveStudent:(NSString *)studentkey;
-(BOOL) retrieveClassWithEnrollmentkey:(NSString *)enrollmentkey;
-(BOOL) retrieveEnrollmentWithStudentkey:(NSString *)studentkey;
-(void) retrieveDTrecords;
-(BOOL) retrieveSalesRecord;
-(BOOL) retrieveCallLogRecord;
-(BOOL) retrieveMessageRecord;
-(BOOL) retrieveCouponRecord;
-(void) createStudentViewNavigationButton;
-(void) createEnrollmentViewNavigationButton;
-(void) createClassViewNavigationButton;
-(void) createMessageViewNavigationButton;
-(void) createSalesViewNavigationButton;
-(void) createCallLogViewNavigationButton;
-(void) createDTViewNavigationButton;
-(void) createCouponViewNavigationButton;
-(void) seguetostudenteditview;
//-(BOOL) retrievestudentsubject;
-(void) highlighttableoptionbuttonwithbuttontag:(long)buttontag;
-(void) drawpointerwithoption:(NSString *)option button:(UIButton *)button;
-(void) reloadPageWithFirstLoad:(BOOL)firstload;
-(void) showviewhistory:(BOOL)show;
-(void) closesidewindow;
-(void) validationPassed:(BOOL)pass;
-(void) highlightduebuttonwithreloadstudentlist:(BOOL)reload;
-(void) showAdvancedSearchWindow;
-(void) stopAudioPlaying;
-(void) issueCouponToStudents:(NSMutableArray *)studentkeys;
-(void) issuePointToStudents:(NSMutableArray *)studentkeys multipleStudents:(BOOL)multiplestudents;
//-(void) donotrunviewdidappear;
- (IBAction)selecttable:(id)sender;
- (IBAction)combinepaymentbuttonpressed:(id)sender;
- (IBAction)sortingbuttonpressed:(id)sender;
- (IBAction)selectproductcategory:(id)sender;
- (IBAction)selectcalllogcalledby:(id)sender;
- (IBAction)selectdtclass:(id)sender;
- (IBAction)selectdttype:(id)sender;
- (IBAction)camerabuttonpressed:(id)sender;
- (IBAction)channelbuttonpressed:(id)sender;
- (IBAction)selectsender:(id)sender;
- (IBAction)sendinstantmessagebuttonpressed:(id)sender;
- (IBAction)startAudioRecording:(id)sender;
- (IBAction)stopAudioRecording:(id)sender;
- (IBAction)replyToMessageCancelButtonPressed:(id)sender;
- (IBAction)updateCouponFilter:(id)sender;
- (IBAction)pointbuttonpressed:(id)sender;
-(void) drawpointerwithoption:(NSString *)option imageview:(UIImageView *)imageview;
- (IBAction)editStudent:(id)sender;
- (IBAction)gotoleadprofile:(id)sender;
- (IBAction)documentfolderbuttonpressed:(id)sender;
- (IBAction)addEnrollment:(id)sender;
- (IBAction)addnewsales:(id)sender;
- (IBAction)addnewcoupon:(id)sender;
- (IBAction)addnewcalllog:(id)sender;
- (IBAction)addnewdt:(id)sender;
- (IBAction)remainingclasssummary:(id)sender;


- (IBAction)deleteMessageButtonPressed:(id)sender;
- (IBAction)forwardMessageButtonPressed:(id)sender;
- (IBAction)cancelSelectButtonPressed:(id)sender;

@end
